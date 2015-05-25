package {
	import entities.Enemy;
	import entities.Entity;
	import flash.media.*;
	import flash.ui.Mouse;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.HAlign;

	import entities.*;
	import tiles.*;

	public class Game extends Sprite {
		public static const FLOOR_FAIL_TEXT:String = "Nea was defeated!\nClick here to continue building.";
		public static const LEVEL_UP_TEXT:String = "Nea levelled up!\nHealth fully restored!\n+{0} max health\n+{1} attack\nClick to dismiss";
		public static const PHASE_BANNER_DURATION:Number = 0.75; // seconds
		public static const PHASE_BANNER_THRESHOLD:Number = 0.05;
		public static const TILE_UNLOCK_THRESHOLD:Number = 0.05;
		public static const DEFAULT_CAMERA_ACCEL:int = 1;
		public static const MAX_CAMERA_ACCEL:int = 3;

		public static const STATE_MENU:String = "game_menu";
		public static const STATE_BUILD:String = "game_build";
		public static const STATE_RUN:String = "game_run";
		public static const STATE_COMBAT:String = "game_combat";
		public static const STATE_POPUP:String = "game_popup";
		public static const STATE_TUTORIAL:String = "game_tutorial";
		public static const STATE_SUMMARY:String = "game_summary";
		public static const STATE_CINEMATIC:String = "game_cinematic";

		private var cursorAnim:MovieClip;
		private var cursorReticle:Image;
		private var cursorHighlight:Image;
		private var shopButton:Clickable;
		private var bgmMuteButton:Clickable;
		private var sfxMuteButton:Clickable;
		private var runButton:Clickable;
		private var endButton:Clickable;
		private var combatSpeedButton:Clickable;
		private var runSpeedButton:Clickable;
		private var helpButton:Sprite;
		private var helpImageSprite:Sprite;
		private var helpImage:Image;

		//private var charHud:CharHud;
		private var mixer:Mixer;
		private var textures:Dictionary;  // Map String -> Texture. See util.as.
		private var floors:Dictionary; // Map String -> String
		//private var transitions:Dictionary; // Map String -> Texture
		private var animations:Dictionary; // Map String -> Dictionary<String, Vector<Texture>>

		private var sfx:Dictionary; // Map String -> SFX
		private var bgm:Array;

		private var staticBackgroundImage:Image;
		private var world:Sprite;
		private var menuWorld:Sprite;
		private var currentFloor:Floor;
		private var currentTransition:Clickable;
		private var currentMenu:Menu;
		private var isMenu:Boolean; // probably need to change to state;
		private var messageToPlayer:Clickable;

		public var logger:Logger;
		private var numberOfTilesPlaced:int;
		private var entitiesPlaced:int;

		private var currentCombat:CombatHUD;
		private var combatSkip:Boolean;
		private var runPhaseSpeed:Boolean;
		private var runHud:RunHUD;
		private var goldHud:GoldHUD;
		private var shopHud:ShopHUD;
		private var buildHud:BuildHUD;
		private var showBuildHudImage:Boolean;
		private var runSummary:Summary;
		private var tileUnlockPopup:Clickable;
		private var tutorialHud:TutorialHUD;
		private var cinematic:Cinematic;

		private var gameState:String;
		private var gold:int;

		private var phaseBanner:Image;
		private var phaseBannerTimer:Number;

		private var tileUnlockTimer:Number;

		private var cameraAccel:Number;
		// Key -> Boolean representing which keys are being held down
		private var pressedKeys:Dictionary;

		public function Game() {
			this.addEventListener(Event.ADDED_TO_STAGE, startGame);
		}
		
		private function startGame(event:Event):void {
			Mouse.hide();

			var gid:uint = 115;
			var gname:String = "cgs_gc_YouMakeTheDungeon";
			var skey:String = "9a01148aa509b6eb4a3945f4d845cadb";

			// this is the current version, we'll treat 0 as the debugging
			// version, and change this for each iteration on, back to 0
			// for our own testing.
			var cid:int = 0;

			logger = Logger.initialize(gid, gname, skey, cid, null);
			Util.logger = logger;

			Util.speed = Util.SPEED_SLOW;

			sfx = Embed.setupSFX();
			bgm = Embed.setupBGM();

			mixer = new Mixer(bgm, sfx);
			addChild(mixer);
			Util.mixer = mixer;

			// for keeping track of how many tiles are placed before hitting reset
			numberOfTilesPlaced = 0;

			textures = Embed.setupTextures();
			floors = Embed.setupFloors();
			//transitions = Embed.setupTransitions();
			animations = Embed.setupAnimations();

			staticBackgroundImage = new Image(textures[Util.STATIC_BACKGROUND]);
			addChild(staticBackgroundImage);

			cameraAccel = DEFAULT_CAMERA_ACCEL;
			pressedKeys = new Dictionary();

			initializeFloorWorld();
			initializeMenuWorld();

			cursorReticle = new Image(textures[Util.CURSOR_RETICLE]);
			cursorReticle.touchable = false;
			addChild(cursorReticle);

			cursorAnim = new MovieClip(animations[Util.ICON_CURSOR][Util.ICON_CURSOR], Util.ANIM_FPS);
			cursorAnim.loop = true;
			cursorAnim.play();
			cursorAnim.touchable = false;
			addChild(cursorAnim);

			isMenu = false;
			createMainMenu();

			combatSkip = false;
			gold = Util.STARTING_GOLD;

			runSummary = new Summary(40, 40, returnToBuild, null, textures[Util.SHOP_BACKGROUND], textures);

			// Make sure the cursor stays on the top level of the drawtree.
			addEventListener(EnterFrameEvent.ENTER_FRAME, onFrameBegin);

			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
			addEventListener(GameEvent.ENTERED_COMBAT, startCombat);

			addEventListener(AnimationEvent.CHAR_DIED, onCombatFailure);
			addEventListener(AnimationEvent.ENEMY_DIED, onCombatSuccess);

			addEventListener(GameEvent.STAMINA_EXPENDED, onStaminaExpended);
			addEventListener(GameEvent.COMPLETE_ROOM, onRoomComplete);
			addEventListener(GameEvent.BUILD_HUD_IMAGE_CHANGE, clearBuildHUDImage);
			addEventListener(GameEvent.GAIN_GOLD, onGainGold);
			addEventListener(GameEvent.TUTORIAL_COMPLETE, onTutorialComplete);
			addEventListener(GameEvent.MOVE_CAMERA, onMoveCamera);
			addEventListener(GameEvent.CINEMATIC_COMPLETE, onCinematicComplete);
			addEventListener(GameEvent.UNLOCK_TILE, onTileUnlock);
		}

		private function initializeFloorWorld():void {
			world = new Sprite();

			sfxMuteButton = new Clickable(0, 0, toggleSFXMute, null, textures[Util.ICON_SFX_PLAY]);
			sfxMuteButton.x = Util.STAGE_WIDTH - sfxMuteButton.width - Util.UI_PADDING;
			sfxMuteButton.y = Util.STAGE_HEIGHT - sfxMuteButton.height - Util.UI_PADDING;

			bgmMuteButton = new Clickable(0, 0, toggleBgmMute, null, textures[Util.ICON_BGM_PLAY]);
			bgmMuteButton.x = sfxMuteButton.x - bgmMuteButton.width - Util.UI_PADDING;
			bgmMuteButton.y = sfxMuteButton.y;

			combatSpeedButton = new Clickable(0, 0, toggleCombatSpeed, null, textures[Util.ICON_SLOW_COMBAT]);
			combatSpeedButton.x = bgmMuteButton.x - combatSpeedButton.width - Util.UI_PADDING;
			combatSpeedButton.y = Util.STAGE_HEIGHT - combatSpeedButton.height - Util.UI_PADDING;

			runSpeedButton = new Clickable(0, 0, toggleRunSpeed, null, textures[Util.ICON_SLOW_RUN]);
			runSpeedButton.x = combatSpeedButton.x - runSpeedButton.width - Util.UI_PADDING;
			runSpeedButton.y = combatSpeedButton.y;

			helpImageSprite = new Sprite();
			helpImageSprite.x = -6;
			helpImageSprite.y = -48;
			var helpQuad:Quad = new Quad(Util.STAGE_WIDTH*2, Util.STAGE_HEIGHT*2, Color.WHITE);
			helpQuad.alpha = 0.7;
			helpImageSprite.addChild(helpQuad);
			helpButton = new Sprite();
			var helpButtonQuad:Quad = new Quad(32, 32, Color.WHITE);
			helpButtonQuad.alpha = 0;
			helpButton.addChild(helpButtonQuad);
			var helpButtonImage:Image = new Image(textures[Util.ICON_HELP]);
			helpButton.addChild(helpButtonImage);
			helpButton.x = runSpeedButton.x - helpButton.width - Util.UI_PADDING;
			helpButton.y = runSpeedButton.y;

			goldHud = new GoldHUD(Util.STARTING_GOLD, textures, mixer);
			goldHud.x = Util.STAGE_WIDTH - goldHud.width;
			goldHud.y = Util.UI_PADDING;

			runButton = new Clickable(3 *  Util.PIXELS_PER_TILE,
									  Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE,
									  runFloor,
									  null,
									  textures[Util.ICON_RUN]);
			runButton.x = goldHud.x - runButton.width - Util.UI_PADDING;
			runButton.y = Util.UI_PADDING;

			shopHud = new ShopHUD(goldHud, closeShopHUD, textures);
			shopButton = new Clickable(goldHud.x, goldHud.height, openShopHUD, null, textures[Util.ICON_SHOP]);
			shopButton.x = runButton.x - shopButton.width - Util.UI_PADDING
			shopButton.y = Util.UI_PADDING;

			endButton = new Clickable(3 *  Util.PIXELS_PER_TILE,
									  Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE,
									  endRunButton,
									  null,
									  textures[Util.ICON_END]);
			endButton.x = runButton.x;
			endButton.y = runButton.y;

			runHud = new RunHUD(textures); // textures not needed for now but maybe in future
			buildHud = new BuildHUD(textures);
			tutorialHud = new TutorialHUD(textures);

			cursorHighlight = new Image(textures[Util.TILE_HL_B]);
			cursorHighlight.touchable = false;
			world.addChild(cursorHighlight);
		}

		private function initializeMenuWorld():void {
			menuWorld = new Sprite();
			menuWorld.addChild(new Image(textures[Util.GRID_BACKGROUND]));
		}

		private function startCombat(e:GameEvent):void {
			currentCombat = new CombatHUD(textures,
										  animations,
										  currentFloor.char,
										  currentFloor.entityGrid[e.x][e.y],
										  combatSkip,
										  mixer,
										  logger);
			addChild(currentCombat);
		}

		private function onCombatSuccess(event:AnimationEvent):void {
			removeChild(currentCombat);
			currentFloor.onCombatSuccess(event.enemy);
			gold += event.enemy.reward;
			runSummary.goldCollected += event.enemy.reward;
			goldHud.update(gold);
		}

		private function onCombatFailure(event:AnimationEvent):void {
			removeChild(currentCombat);

			logger.logAction(4, {
				"characterAttack":event.character.attack,
				"enemyAttack":event.enemy.attack,
				"enemyHealthLeft":event.enemy.hp
			});

			endRun();

			// Short circuiting enemy death to end run page
			/*var alertBox:Sprite = new Sprite();
			var alertPopup:Image = new Image(textures[Util.POPUP_BACKGROUND])
			alertBox.addChild(alertPopup);
			alertBox.addChild(new TextField(alertPopup.width, alertPopup.height, FLOOR_FAIL_TEXT, Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			alertBox.x = (Util.STAGE_WIDTH - alertBox.width) / 2 - this.parent.x;
			alertBox.y = (Util.STAGE_HEIGHT - alertBox.height) / 2 - this.parent.y;

			messageToPlayer = new Clickable(0, 0, function():void {
				removeChild(messageToPlayer);
				endRun();
			},  alertBox);

			addChild(messageToPlayer);*/
		}

		private function prepareSwap():void {
			if(isMenu) {
				removeChild(menuWorld);
				removeChild(currentMenu);
			} else {
				world.removeChild(currentFloor);
				while (world.numChildren > 0) {
					world.removeChildAt(0);
				}
				removeChild(world);
				removeChild(messageToPlayer);
				// mute button should always be present
				removeChild(currentTransition);
				removeChild(runButton);
				removeChild(endButton);
				//removeChild(charHud);
				removeChild(buildHud);
				removeChild(goldHud);
				removeChild(runHud);
				removeChild(combatSpeedButton);
				removeChild(runSpeedButton);
				removeChild(helpButton);
				removeChild(helpImageSprite);
			}
		}

		public function switchToMenu(newMenu:Menu):void {
			prepareSwap();

			isMenu = true;
			gameState = STATE_MENU;
			currentMenu = newMenu;
			addChild(currentMenu);
			addChild(bgmMuteButton);
			addChild(sfxMuteButton);
		}

		public function switchToTransition(params:Object):void {
			prepareSwap();
			isMenu = false;

			currentTransition = new Clickable(0, 0, switchToFloor, null, params["transition"]);
			currentTransition.addParameter("floorData", params["floorData"]);
			currentTransition.addParameter("initHealth", params["initHealth"]);
			currentTransition.addParameter("initStamina", params["initStamina"]);
			currentTransition.addParameter("initAttack", params["initAttack"]);
			currentTransition.addParameter("initLos", params["initLos"]);
			addChild(currentTransition);
		}

		public function switchToFloor(params:Object):void {
			prepareSwap();
			isMenu = false;

			var nextFloorData:Array = new Array();
			currentFloor = new Floor(params["floorData"],
									 textures,
									 animations,
									 params["initHealth"],
									 params["initStamina"],
									 params["initAttack"],
									 params["initLos"],
									 floors,
									 transitionToStart,
									 mixer,
									 runSummary);
			//if (currentFloor.floorName == Util.FLOOR_8) {
			//	currentFloor.altCallback = transitionToStart;
			//}

			logger.logLevelStart(1, {
				"characterHP":currentFloor.char.maxHp,
				"characterStamina":currentFloor.char.maxStamina,
				"characterAttack":currentFloor.char.attack
			});

			world.addChild(currentFloor);
			world.addChild(cursorHighlight);

			centerWorldOnCharacter();

			addChild(world);
			// mute button should always be on top
			addChild(bgmMuteButton);
			addChild(sfxMuteButton);
			addChild(combatSpeedButton);
			addChild(runSpeedButton);
			//addChild(resetButton);
			addChild(runButton);
			addChild(goldHud);
			addChild(shopButton);
			addChild(helpButton);
			//charHud = new CharHud(currentFloor.char, textures);
			//addChild(charHud);

			addChild(buildHud);
			addChild(tutorialHud);

			mixer.play(Util.FLOOR_BEGIN);
			// gameState = STATE_BUILD; // need additional logic here if we have many tutorials
			gameState = STATE_TUTORIAL;
		}

		public function transitionToStart():void {
			createMainMenu();
		}

		public function createMainMenu():void {
			var titleField:TextField = new TextField(512, 80, "You Make The Dungeon", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			titleField.x = (Util.STAGE_WIDTH / 2) - (titleField.width / 2);
			titleField.y = 32 + titleField.height / 2;

			floors = Embed.setupFloors();

			var startGame:Clickable = new Clickable(
					256,
					192,
					switchToFloor,
					new TextField(128, 40, "START", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE),
					null);
			//startGame.addParameter("transition", transitions[Util.MAIN_FLOOR]);
			startGame.addParameter("floorData", floors[Util.MAIN_FLOOR]);
			startGame.addParameter("initHealth", Util.STARTING_HEALTH);
			startGame.addParameter("initStamina", Util.STARTING_STAMINA);
			startGame.addParameter("initAttack", Util.STARTING_ATTACK);
			startGame.addParameter("initLos", Util.STARTING_LOS);

			var creditsButton:Clickable = new Clickable(
					256,
					256,
					createCredits,
					new TextField(128, 40, "CREDITS", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			switchToMenu(new Menu(new Array(titleField, startGame, creditsButton)));
		}

		public function createCredits():void {
			var startButton:Clickable = new Clickable(256, 128, createMainMenu, new TextField(128, 40, "BACK", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			var creditsLine:TextField = new TextField(384, 256, "THANKS TO LOUISA FAN FOR THE GAME ART.\nWe'll get the other sources later.", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			creditsLine.x = startButton.x + (startButton.width - creditsLine.width) / 2;
			creditsLine.y = startButton.y + startButton.height;
			switchToMenu(new Menu(new Array(startButton, creditsLine)));
		}

		public function openShopHUD():void {
			if (gameState == STATE_TUTORIAL || gameState == STATE_CINEMATIC) {
				return;
			}

			if (getChildIndex(shopHud) == -1) {
				logger.logAction(13, { } );
				shopHud.update(currentFloor.char, gold);
				addChild(shopHud);
				buildHud.deselect();
			}
		}

		public function closeShopHUD():void {
			if (getChildIndex(shopHud) != -1) {
				gold = shopHud.gold;
				removeChild(shopHud);
			}
		}

		public function constructPhaseBanner(run:Boolean = true):void {
			removeChild(phaseBanner);
			phaseBanner = new Image(textures[run ? Util.RUN_BANNER : Util.BUILD_BANNER]);
			phaseBanner.y = (Util.STAGE_HEIGHT - phaseBanner.height) / 2;
			phaseBannerTimer = 0;
			addChild(phaseBanner);
		}

		public function toggleBgmMute():void {
			mixer.togglePlay();
			if (currentFloor) {
				Util.logger.logAction(15, {
					"buttonClicked":"BGM Mute"
				});
			}

			var chosen:String = mixer.playing ? Util.ICON_BGM_PLAY : Util.ICON_BGM_MUTE;
			bgmMuteButton.updateImage(null, textures[chosen]);
		}

		public function toggleSFXMute():void {
			mixer.toggleSFXMute();
			if (currentFloor) {
				Util.logger.logAction(15, {
					"buttonClicked":"SFX Mute"
				});
			}

			var chosen:String = mixer.sfxMuted ? Util.ICON_SFX_MUTE : Util.ICON_SFX_PLAY;
			sfxMuteButton.updateImage(null, textures[chosen]);
		}

		public function resetFloor():void {
			//logger.logAction(8, { "numberOfTiles":numberOfTilesPlaced, "AvaliableTileSpots":(currentFloor.gridHeight * currentFloor.gridWidth - currentFloor.preplacedTiles),
			//			     "EmptyTilesPlaced":emptyTiles, "MonsterTilesPlaced":enemyTiles, "HealthTilesPlaced":healingTiles} );
			//reset counters
			currentFloor.resetFloor();
			//charHud.char = currentFloor.char
			mixer.play(Util.TILE_REMOVE);
		}

		public function runFloor():void {
			if (gameState == STATE_TUTORIAL || gameState == STATE_CINEMATIC) {
				return;
			}

			logger.logAction(3, {
				"numberOfTiles":numberOfTilesPlaced,
				"numberOfEntitiesPlaced":entitiesPlaced
			});
			numberOfTilesPlaced = 0;
			entitiesPlaced = 0;
			removeChild(runButton);
			currentFloor.clearHighlightedLocations();
			removeChild(buildHud.currentImage);
			buildHud.deselect();
			removeChild(buildHud);
			removeChild(shopHud);
			removeChild(shopButton);

			addChild(endButton);

			runHud.startRun();
			addChild(runHud);
			gameState = STATE_RUN;
			currentFloor.toggleRun(gameState);

			constructPhaseBanner();
		}

		public function onStaminaExpended(event:GameEvent):void {
			endRun();
		}

		private function onRoomComplete(event:GameEvent):void {
			mixer.play(Util.COMBAT_SUCCESS);

			if(!event.gameData["completed"]) {
				return;
			}
		}

		public function endRun():void {
			var reason:String;
			if (currentFloor.char.stamina <= 0) {
				reason = "staminaExpended";
			} else if (currentFloor.char.hp <= 0) {
				reason = "healthExpended";
			} else {
				reason = "endRunButton";
			}
			logger.logAction(8, {
				"goldEarned":runSummary.goldCollected,
				"staminaLeft": currentFloor.char.stamina,
				"healthLeft": currentFloor.char.hp,
				"tilesVisited": runSummary.distanceTraveled,
				"enemiesDefeated":runSummary.enemiesDefeated,
				"damageTaken":runSummary.damageTaken,
				"reason":reason
			});

			removeChild(endButton);
			removeChild(runHud);
			removeChild(tileUnlockPopup);

			gameState = STATE_SUMMARY;
			addChild(runSummary);
			currentFloor.toggleRun(STATE_BUILD);
		}

		public function endRunButton():void {
			if(currentFloor && !currentFloor.completed && gameState == STATE_RUN) {
				endRun();
			}
		}

		public function returnToBuild():void {
			removeChild(runSummary);
			runSummary.reset();

			addChild(runButton);

			buildHud.updateUI();
			addChild(buildHud);
			addChild(shopButton);

			gameState = STATE_BUILD;
			//currentFloor.toggleRun(gameState);
			currentFloor.resetFloor();

			centerWorldOnCharacter();

			constructPhaseBanner(false); // happens after the summary dialog box
		}

		private function centerWorldOnCharacter(exact:Boolean = false):void {
			// Set exact to simulate camera snapping
			// Only really useful for ensuring that the top-left is well-centered
			// Parameter becomes completely useless with sliding instead of snapping pan

			var charWidth:int = currentFloor == null ? 0 : currentFloor.char == null ? 0 : currentFloor.char.width;
			var charX:int = currentFloor == null ? 0 : currentFloor.char == null ? 0 : currentFloor.char.x;
			if(exact) {
				charX = Util.grid_to_real(Util.real_to_grid(charX));
			}
			world.x = Util.STAGE_WIDTH / 2 - charX - Util.PIXELS_PER_TILE;

			var charHeight:int = currentFloor == null ? 0 : currentFloor.char == null ? 0 : currentFloor.char.height;
			var charY:int = currentFloor == null ? 0 : currentFloor.char == null ? 0 : currentFloor.char.y;
			if(exact) {
				charY = Util.grid_to_real(Util.real_to_grid(charY));
			}
			world.y = Util.STAGE_HEIGHT / 2 - charY - (Util.PIXELS_PER_TILE * 3.0 / 4);
		}

		private function onFrameBegin(event:EnterFrameEvent):void {
			cursorAnim.advanceTime(event.passedTime);

			cameraAccel += event.passedTime;
			if(cameraAccel > MAX_CAMERA_ACCEL) {
				cameraAccel = MAX_CAMERA_ACCEL;
			}

			var worldShift:int = Util.CAMERA_SHIFT * cameraAccel;
			if(pressedKeys[Keyboard.DOWN] || pressedKeys[Util.DOWN_KEY]) {
				world.y -= worldShift;

				if (world.y < -1 * Util.PIXELS_PER_TILE * (currentFloor.gridHeight - 1)) {
					world.y = -1 * Util.PIXELS_PER_TILE * (currentFloor.gridHeight - 1);
				}
			}

			if(pressedKeys[Keyboard.UP] || pressedKeys[Util.UP_KEY]) {
				world.y += worldShift;

				if (world.y > Util.PIXELS_PER_TILE * -1 + Util.STAGE_HEIGHT) {
					world.y = Util.PIXELS_PER_TILE * -1 + Util.STAGE_HEIGHT;
				}
			}

			if(pressedKeys[Keyboard.RIGHT] || pressedKeys[Util.RIGHT_KEY]) {
				world.x -= worldShift;

				if (world.x < -1 * Util.PIXELS_PER_TILE * (currentFloor.gridWidth - 1)) {
					world.x = -1 * Util.PIXELS_PER_TILE * (currentFloor.gridWidth - 1);
				}
			}

			if(pressedKeys[Keyboard.LEFT] || pressedKeys[Util.LEFT_KEY]) {
				world.x += worldShift;

				if (world.x > Util.PIXELS_PER_TILE * -1 + Util.STAGE_WIDTH) {
					world.x = Util.PIXELS_PER_TILE * -1 + Util.STAGE_WIDTH;
				}
			}

			if(phaseBanner) {
				phaseBannerTimer += event.passedTime;
				addChild(phaseBanner);
				if(phaseBannerTimer > PHASE_BANNER_DURATION) {
					removeChild(phaseBanner);
					phaseBanner = null;
				}
			}

			if(tileUnlockPopup) {
				tileUnlockTimer += event.passedTime;
			}

			removeChild(buildHud.currentImage);
			if(gameState == STATE_BUILD && buildHud && buildHud.hasSelected() && showBuildHudImage) {
				addChild(buildHud.currentImage);
			}

			addChild(cursorReticle);
			addChild(cursorAnim);

			if(gameState == STATE_RUN && runHud && currentFloor) {
				runHud.update(currentFloor.char);
				centerWorldOnCharacter();
			}
		}

		private function onMouseEvent(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);

			if(!touch) {
				return;
			}

			var xOffset:int = touch.globalX < world.x ? Util.PIXELS_PER_TILE : 0;
			var yOffset:int = touch.globalY < world.y ? Util.PIXELS_PER_TILE : 0;
			cursorHighlight.x = Util.grid_to_real(Util.real_to_grid(touch.globalX - world.x - xOffset));
			cursorHighlight.y = Util.grid_to_real(Util.real_to_grid(touch.globalY - world.y - yOffset));

			// TODO: make it so cursorAnim can move outside of the world
			cursorReticle.x = touch.globalX - cursorReticle.width / 2;
			cursorReticle.y = touch.globalY - cursorReticle.height / 2 - 2;
			cursorAnim.x = touch.globalX + Util.CURSOR_OFFSET_X;
			cursorAnim.y = touch.globalY + Util.CURSOR_OFFSET_Y;

			// Manage build hud display and current image
			showBuildHudImage = touch.isTouching(currentFloor);
			if (gameState == STATE_BUILD) {
				if (touch.phase == TouchPhase.BEGAN && !touch.isTouching(buildHud)) {
					buildHud.closePopup();
				}

				if (buildHud.hasSelected()) {
					// Move buildHud image to cursor
					buildHud.currentImage.x = touch.globalX - buildHud.currentImage.width / 2;
					buildHud.currentImage.y = touch.globalY - buildHud.currentImage.height / 2;
					currentFloor.highlightAllowedLocations(buildHud.directions, buildHud.hudState);
					if (touch.phase == TouchPhase.ENDED && touch.isTouching(currentFloor)) {
						// Player clicked inside grid
						buildHandleClick(touch);
					}
				} else {
					currentFloor.clearHighlightedLocations();
				}
			}


			// Click outside of shop (onblur)
			if (getChildIndex(shopHud) != -1 && !touch.isTouching(shopHud) && !touch.isTouching(shopButton) && touch.phase == TouchPhase.BEGAN) {
				removeChild(shopHud);
			}

			if (touch.phase == TouchPhase.BEGAN && tileUnlockPopup != null && tileUnlockTimer > TILE_UNLOCK_THRESHOLD) {
				closeTileUnlock();
			}

			var isTouchHelpButton:Boolean;
			var touchX:int = touch.globalX;
			var touchY:int = touch.globalY;
			if (touchX >= helpButton.x && touchX < helpButton.x + helpButton.width &&
				touchY >= helpButton.y && touchY < helpButton.y + helpButton.height) {
				isTouchHelpButton = true;
			}
			if (isTouchHelpButton && (gameState == STATE_BUILD || gameState == STATE_RUN)) {
				helpImageSprite.removeChild(helpImage);
				helpImage = new Image(textures[gameState == STATE_BUILD ? Util.BUILD_HELP : Util.RUN_HELP]);
				helpImageSprite.addChild(helpImage);
				addChild(helpImageSprite);
			} else {
				removeChild(helpImageSprite);
			}

			if(phaseBanner && touch.phase == TouchPhase.BEGAN && phaseBannerTimer > PHASE_BANNER_THRESHOLD) {
				removeChild(phaseBanner);
				phaseBanner = null;
			}

			/*if(gameState == STATE_BUILD) {
				showBuildHudImage = !touch.isTouching(buildHud);
				showBuildHudImage = showBuildHudImage ? !touch.isTouching(goldHud) : showBuildHudImage;
				showBuildHudImage = showBuildHudImage ? !touch.isTouching(bgmMuteButton) : showBuildHudImage;
				showBuildHudImage = showBuildHudImage ? !touch.isTouching(sfxMuteButton) : showBuildHudImage;
				showBuildHudImage = showBuildHudImage ? !touch.isTouching(runButton) : showBuildHudImage;
				showBuildHudImage = showBuildHudImage ? !touch.isTouching(shopButton) : showBuildHudImage;
			}*/
		}

		private function buildHandleClick(touch:Touch):void {
			var currentTile:Tile; var currentEntity:Entity; var newTile:Tile; var newEntity:Entity; var cost:int;

			var tempX:int = touch.globalX - world.x;
			var tempY:int = touch.globalY - world.y;
			if (tempX > 0 && tempX < currentFloor.gridWidth * Util.PIXELS_PER_TILE
				&& tempY > 0 && tempY < currentFloor.gridHeight * Util.PIXELS_PER_TILE) {
				currentTile = currentFloor.grid[Util.real_to_grid(tempX)][Util.real_to_grid(tempY)];
				currentEntity = currentFloor.entityGrid[Util.real_to_grid(tempX)][Util.real_to_grid(tempY)];
			} else {
				// Did not click a valid tile location
				return;
			}

			if (buildHud.hudState == BuildHUD.STATE_DELETE) {
				if (currentFloor.deleteSelected(currentTile, currentEntity)) {
					gold += buildHud.getRefundForDelete(currentTile, currentEntity);
					goldHud.update(gold);
					mixer.play(Util.TILE_REMOVE);
				} else {
					mixer.play(Util.TILE_FAILURE);
				}
			} else if (buildHud.hudState == BuildHUD.STATE_TILE) {
				newTile = buildHud.buildTileFromImage(world.x, world.y);
				cost = buildHud.getCost();
				if (currentFloor.highlightedLocations[newTile.grid_x][newTile.grid_y] && gold - cost >= 0) {
					gold -= cost;
					goldHud.update(gold);
					// Player correctly placed the tile. Add it to the grid.
					currentFloor.grid[newTile.grid_x][newTile.grid_y] = newTile;
					currentFloor.addChild(newTile);
					currentFloor.rooms.addTile(newTile);
					currentFloor.fogGrid[newTile.grid_x][newTile.grid_y] = false;
					currentFloor.removeFoggedLocations(newTile.grid_x, newTile.grid_y);
					// check if we placed the tile next to any preplaced tiles, and if we did, remove
					// the fogs for those as well. (it's so ugly D:)
					if (newTile.grid_x + 1 < currentFloor.grid.length && currentFloor.grid[newTile.grid_x + 1][newTile.grid_y]) {
						currentFloor.removeFoggedLocations(newTile.grid_x + 1, newTile.grid_y);
					}
					if (newTile.grid_x - 1 >= 0 && currentFloor.grid[newTile.grid_x - 1][newTile.grid_y]) {
						currentFloor.removeFoggedLocations(newTile.grid_x - 1, newTile.grid_y);
					}
					if (newTile.grid_y + 1 < currentFloor.grid[newTile.grid_x].length && currentFloor.grid[newTile.grid_x][newTile.grid_y + 1]) {
						currentFloor.removeFoggedLocations(newTile.grid_x, newTile.grid_y + 1);
					}
					if (newTile.grid_y - 1 >= 0 && currentFloor.grid[newTile.grid_x][newTile.grid_y - 1]) {
						currentFloor.removeFoggedLocations(newTile.grid_x, newTile.grid_y - 1);
					}
					numberOfTilesPlaced++;
					logger.logAction(1, {
						"goldSpend": cost,
						"northOpen":newTile.north,
						"southOpen":newTile.south,
						"eastOpen":newTile.east,
						"westOpen":newTile.west
					});
					mixer.play(Util.TILE_MOVE);
				} else {
					mixer.play(Util.TILE_FAILURE);
				}
			} else if (buildHud.hudState == BuildHUD.STATE_ENTITY) {
				cost = buildHud.getCost();
				if (currentFloor.isEmptyTile(currentTile) && gold - cost >= 0) {
					var type:String = "healing";
					gold -= cost;
					goldHud.update(gold);
					// Player correctly placed the entity. Add it to the grid.
					newEntity = buildHud.buildEntityFromImage(currentTile);
					currentFloor.entityGrid[newEntity.grid_x][newEntity.grid_y] = newEntity;
					trace(newEntity.grid_x);
					trace(newEntity.grid_y);
					currentFloor.addChild(newEntity);
					if (newEntity is Enemy) {
						currentFloor.activeEnemies.push(newEntity);
						type = "enemy";
					}
					mixer.play(Util.TILE_MOVE);
					logger.logAction(18, {
						"cost":cost,
						"entityPlaced":type
					});
					entitiesPlaced++;
				} else {
					mixer.play(Util.TILE_FAILURE);
				}
			}
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if(gameState == STATE_TUTORIAL || gameState == STATE_CINEMATIC) {
				return;
			}

			// to ensure that they can't move the world around until
			// a floor is loaded, and not cause flash errors
			pressedKeys[event.keyCode] = true;

			if (event.keyCode == Util.BGM_MUTE_KEY) {
				toggleBgmMute();
			}

			if (event.keyCode == Util.SFX_MUTE_KEY) {
				toggleSFXMute();
			}

			if (event.keyCode == Util.CHANGE_PHASE_KEY) {
				if (gameState == STATE_BUILD) {
					runFloor();
				} else if (gameState == STATE_RUN) {
					endRunButton();
				} else if (gameState == STATE_SUMMARY) {
					returnToBuild();
				}
			}

			if (event.keyCode == Util.COMBAT_SKIP_KEY) {
				//combatSkip = !combatSkip;
				toggleCombatSpeed();
				if(currentCombat && gameState == STATE_COMBAT) {
					if(currentCombat.skipping != combatSkip) {
						currentCombat.toggleSkip();
					}
				}
			}

			if (event.keyCode == Util.SPEED_TOGGLE_KEY) {
				toggleRunSpeed();
			}

			if (currentFloor) {
				// TODO: set up dictionary of charCode -> callback?
				if(currentFloor.floorName == Util.TUTORIAL_PAN_FLOOR) {
					currentFloor.removeTutorial();
				}
			}
		}

		public function onKeyUp(event:KeyboardEvent):void {
			pressedKeys[event.keyCode] = false;

			if(!pressedKeys[Util.UP_KEY] && !pressedKeys[Util.DOWN_KEY] &&
			   !pressedKeys[Util.LEFT_KEY] && !pressedKeys[Util.RIGHT_KEY] &&
			   !pressedKeys[Keyboard.UP] && !pressedKeys[Keyboard.DOWN] &&
			   !pressedKeys[Keyboard.LEFT] && !pressedKeys[Keyboard.RIGHT]) {
				cameraAccel = DEFAULT_CAMERA_ACCEL;
			}
		}

		public function clearBuildHUDImage(event:GameEvent):void {
			// Possible race condition which will leave phantom images
			// on the floor from discarded old buildHud images
			removeChild(buildHud.currentImage);

			if(currentFloor) {
				currentFloor.clearHighlightedLocations();
			}
		}

		public function onGainGold(event:GameEvent):void {
			// Get coin entity from floor
			// Remove coin entity from floor
			// Add amount to gold
			// TODO: Add gold population code to floor
			var addAmount:int = 0;
			if (event.x >= 0 && event.x < currentFloor.gridWidth &&
			    event.y >= 0 && event.y < currentFloor.gridHeight) { // if floor tile has gold
				var coin:Coin = currentFloor.goldGrid[event.x][event.y];
				addAmount += coin.gold;
				runHud.tilesVisited += 1;
				currentFloor.removeChild(currentFloor.goldGrid[event.x][event.y]);
				currentFloor.goldGrid[event.x][event.y] = null;
			}

			if(event.gameData["amount"] && event.gameData["entity"]) {
				addAmount += event.gameData["amount"];
				var reward:Reward = event.gameData["entity"];
				if(reward.permanent) {
					currentFloor.removedEntities.push(reward);
				}
				currentFloor.removeChild(reward);
				currentFloor.entityGrid[reward.grid_x][reward.grid_y] = null;
			}

			runHud.goldCollected += addAmount; // add gold amount
			gold += addAmount;
			goldHud.update(gold);
		}

		public function toggleRunSpeed():void {
			Util.logger.logAction(15, {
				"buttonClicked":"Increase Speed"
			});

			runPhaseSpeed = !runPhaseSpeed;

			var chosen:String = runPhaseSpeed ? Util.ICON_FAST_RUN : Util.ICON_SLOW_RUN;
			runSpeedButton.updateImage(null, textures[chosen]);

			Util.speed = runPhaseSpeed ? Util.SPEED_FAST : Util.SPEED_SLOW;
			currentFloor.updateRunSpeed();
		}

		public function toggleCombatSpeed():void {
			Util.logger.logAction(15, {
				"buttonClicked":"Combat Skip"
			});

			combatSkip = !combatSkip;

			var chosen:String = combatSkip ? Util.ICON_FAST_COMBAT : Util.ICON_SLOW_COMBAT;
			combatSpeedButton.updateImage(null, textures[chosen]);
		}

		public function onTutorialComplete(event:GameEvent):void {
			gameState = Game.STATE_CINEMATIC;
			removeChild(tutorialHud);
			playOpeningCinematic();
		}

		public function playOpeningCinematic():void {
			var commands:Array = new Array();

			var moveToExit:Dictionary = new Dictionary();
			moveToExit["command"] = Cinematic.COMMAND_MOVE;
			moveToExit["destX"] = world.x + Util.grid_to_real(9);
			moveToExit["destY"] = world.y + Util.grid_to_real(11);

			var waitAtExit:Dictionary = new Dictionary();
			waitAtExit["command"] = Cinematic.COMMAND_WAIT;
			waitAtExit["timeToWait"] = 1.5;

			var moveToStart:Dictionary = new Dictionary();
			moveToStart["command"] = Cinematic.COMMAND_MOVE;
			moveToStart["destX"] = world.x;
			moveToStart["destY"] = world.y;

			var waitAtStart:Dictionary = new Dictionary();
			waitAtStart["command"] = Cinematic.COMMAND_WAIT;
			waitAtStart["timeToWait"] = 0.5;

			commands.push(moveToExit);
			commands.push(waitAtExit);
			commands.push(moveToStart);
			commands.push(waitAtStart);

			cinematic = new Cinematic(world.x, world.y, Util.CAMERA_SHIFT * 3, commands);
			addChild(cinematic);

			removeChild(buildHud);
			removeChild(runButton);
			removeChild(goldHud);
			removeChild(shopButton);
		}

		public function onMoveCamera(event:GameEvent):void {
			world.x += event.x;
			world.y += event.y;
		}

		public function onCinematicComplete(event:GameEvent):void {
			gameState = STATE_BUILD;
			removeChild(cinematic);
			centerWorldOnCharacter();
			addChild(buildHud);
			addChild(goldHud);
			addChild(runButton);
			addChild(shopButton);

			Util.mixer.play(Util.LEVEL_UP);
		}

		public function onTileUnlock(event:GameEvent):void {
			removeChild(tileUnlockPopup);

			if(event.gameData["type"] && event.gameData["entity"]) {
				Util.mixer.play(Util.LEVEL_UP);

				tileUnlockTimer = 0;

				var reward:Reward = event.gameData["entity"];
				if(reward.permanent) {
					currentFloor.removedEntities.push(reward);
				}
				currentFloor.removeChild(reward);
				currentFloor.entityGrid[reward.grid_x][reward.grid_y] = null;

				var tileUnlockSprite:Sprite = new Sprite();
				var outerQuad:Quad = new Quad(Util.STAGE_WIDTH / 2,
											  Util.STAGE_HEIGHT / 2, Color.BLACK);
				var innerQuad:Quad = new Quad(outerQuad.width - 4, outerQuad.height - 4, Color.WHITE);
				innerQuad.x = outerQuad.x + 2;
				innerQuad.y = outerQuad.y + 2;

				var titleText:TextField = Util.defaultTextField(innerQuad.width, Util.LARGE_FONT_SIZE, "Tile Unlocked!", Util.LARGE_FONT_SIZE);
				titleText.x = innerQuad.x + (innerQuad.width - titleText.width) / 2;
				titleText.y = innerQuad.y;

				var closeText:TextField = Util.defaultTextField(innerQuad.width, Util.SMALL_FONT_SIZE, "Click to continue", Util.SMALL_FONT_SIZE);
				closeText.x = innerQuad.x + innerQuad.width - closeText.width;
				closeText.y = innerQuad.y + innerQuad.height - closeText.height;

				buildHud.entityFactory.unlockTile(event.gameData["type"]);
				buildHud.updateHUD();

				var unlockedTile:Array = buildHud.entityFactory.masterSet[event.gameData["type"]];
				var newEntity:Entity = unlockedTile[0]();
				var newEntitySprite:Sprite = new Sprite();
				newEntitySprite.addChild(newEntity.img);
				newEntitySprite.addChild(newEntity.generateOverlay());
				newEntitySprite.scaleX = 2;
				newEntitySprite.scaleY = 2;
				newEntitySprite.x = innerQuad.x + Util.PIXELS_PER_TILE / 4;
				newEntitySprite.y = innerQuad.y + (innerQuad.height / 4);

				var newEntityTitle:TextField = Util.defaultTextField(innerQuad.width - newEntitySprite.width - newEntitySprite.x + innerQuad.x,
																	Util.MEDIUM_FONT_SIZE, buildHud.entityFactory.entityText[event.gameData["type"]][0]);
				newEntityTitle.autoScale = true;
				newEntityTitle.hAlign = HAlign.LEFT;
				newEntityTitle.x = newEntitySprite.x + newEntitySprite.width;
				//newEntityTitle.y = titleText.y + titleText.height + Util.PIXELS_PER_TILE / 4;
				newEntityTitle.y = newEntitySprite.y;

				//var openSpace:int = innerQuad.height - titleText.height - newEntityTitle.height - (2 * Util.PIXELS_PER_TILE) / 4 - closeText.height;
				var openSpace:int = innerQuad.height - (newEntitySprite.y - innerQuad.y) - closeText.height - newEntityTitle.height;

				var newEntityText:TextField = Util.defaultTextField(innerQuad.width - newEntitySprite.width - newEntitySprite.x + innerQuad.x,
																	(openSpace * 2 / 3), newEntity.generateDescription());
				newEntityText.autoScale = true;
				newEntityText.hAlign = HAlign.LEFT;
				newEntityText.x = newEntitySprite.x + newEntitySprite.width;
				newEntityText.y = newEntityTitle.y + newEntityTitle.height;

				var newEntityFlavor:TextField = Util.defaultTextField(innerQuad.width - newEntitySprite.width - newEntitySprite.x + innerQuad.x,
				 													  (openSpace / 3), buildHud.entityFactory.entityText[event.gameData["type"]][1]);
				newEntityFlavor.autoScale = true;
				newEntityFlavor.hAlign = HAlign.LEFT;
				newEntityFlavor.x = newEntitySprite.x + newEntitySprite.width;
				newEntityFlavor.y = newEntityText.y + newEntityText.height;

				tileUnlockSprite.addChild(outerQuad);
				tileUnlockSprite.addChild(innerQuad);
				tileUnlockSprite.addChild(titleText);
				tileUnlockSprite.addChild(newEntitySprite);
				tileUnlockSprite.addChild(newEntityTitle);
				tileUnlockSprite.addChild(newEntityText);
				tileUnlockSprite.addChild(newEntityFlavor);
				tileUnlockSprite.addChild(closeText);

				tileUnlockPopup = new Clickable((Util.STAGE_WIDTH - tileUnlockSprite.width) / 2,
												(Util.STAGE_HEIGHT - tileUnlockSprite.height) / 2,
												closeTileUnlock, tileUnlockSprite);
			}

			addChild(tileUnlockPopup);
		}

		public function closeTileUnlock():void {
			removeChild(tileUnlockPopup);
			tileUnlockPopup = null;
		}
	}
}
