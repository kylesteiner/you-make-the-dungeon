package {
	import entities.Enemy;
	import entities.Entity;
	import flash.media.*;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.Texture;

	import clickable.*;
	import tiles.*;

	public class Game extends Sprite {
		public static const FLOOR_FAIL_TEXT:String = "Nea was defeated!\nClick here to continue building.";
		public static const LEVEL_UP_TEXT:String = "Nea levelled up!\nHealth fully restored!\n+{0} max health\n+{1} attack\nClick to dismiss";
		public static const PHASE_BANNER_DURATION:Number = 0.75; // seconds
		public static const PHASE_BANNER_THRESHOLD:Number = 0.05;

		private static const STATE_MENU:String = "game_menu";
		private static const STATE_BUILD:String = "game_build";
		private static const STATE_RUN:String = "game_run";
		private static const STATE_COMBAT:String = "game_combat";
		private static const STATE_POPUP:String = "game_popup";

		private var cursorAnim:MovieClip;
		private var cursorHighlight:Image;
		private var shopButton:Clickable;
		private var bgmMuteButton:Clickable;
		private var sfxMuteButton:Clickable;
		private var runButton:Clickable;
		private var endButton:Clickable;

		//private var charHud:CharHud;
		private var mixer:Mixer;
		private var textures:Dictionary;  // Map String -> Texture. See util.as.
		private var floors:Dictionary; // Map String -> String
		private var transitions:Dictionary; // Map String -> Texture
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
		private var emptyTiles:int;
		private var enemyTiles:int;
		private var healingTiles:int;

		private var currentCombat:CombatHUD;
		private var combatSkip:Boolean;
		private var runHud:RunHUD;
		private var goldHud:GoldHUD;
		private var shopHud:ShopHUD;
		private var buildHud:BuildHUD;
		private var showBuildHudImage:Boolean;

		private var gameState:String;
		private var gold:int;

		private var phaseBanner:Image;
		private var phaseBannerTimer:Number;

		public function Game() {
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

			// for keeping track of how many tiles are placed before hitting reset
			numberOfTilesPlaced = 0;

			textures = Embed.setupTextures();
			floors = Embed.setupFloors();
			transitions = Embed.setupTransitions();
			animations = Embed.setupAnimations();

			sfx = Embed.setupSFX();
			bgm = Embed.setupBGM();

			mixer = new Mixer(bgm, sfx);
			addChild(mixer);

			staticBackgroundImage = new Image(textures[Util.STATIC_BACKGROUND]);
			addChild(staticBackgroundImage);

			initializeFloorWorld();
			initializeMenuWorld();

			cursorAnim = new MovieClip(animations[Util.ICON_CURSOR][Util.ICON_CURSOR], Util.ANIM_FPS);
			cursorAnim.loop = true;
			cursorAnim.play();
			cursorAnim.touchable = false;
			addChild(cursorAnim);

			isMenu = false;
			createMainMenu();

			combatSkip = false;
			gold = Util.STARTING_GOLD;

			// Make sure the cursor stays on the top level of the drawtree.
			addEventListener(EnterFrameEvent.ENTER_FRAME, onFrameBegin);

			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
			addEventListener(GameEvent.ENTERED_COMBAT, startCombat);

			addEventListener(AnimationEvent.CHAR_DIED, onCombatFailure);
			addEventListener(AnimationEvent.ENEMY_DIED, onCombatSuccess);

			addEventListener(GameEvent.STAMINA_EXPENDED, onStaminaExpended);
			addEventListener(GameEvent.BUILD_HUD_IMAGE_CHANGE, clearBuildHUDImage);
		}

		private function initializeFloorWorld():void {
			world = new Sprite();

			sfxMuteButton = new Clickable(0, 0, toggleSFXMute, null, textures[Util.ICON_MUTE_SFX]);
			sfxMuteButton.x = Util.STAGE_WIDTH - sfxMuteButton.width - Util.UI_PADDING;
			sfxMuteButton.y = Util.UI_PADDING;

			bgmMuteButton = new Clickable(0, 0, toggleBgmMute, null, textures[Util.ICON_MUTE_BGM]);
			bgmMuteButton.x = sfxMuteButton.x - bgmMuteButton.width - Util.UI_PADDING;
			bgmMuteButton.y = sfxMuteButton.y;

			goldHud = new GoldHUD(Util.STARTING_GOLD, textures);
			goldHud.x = Util.STAGE_WIDTH - goldHud.width;
			goldHud.y = sfxMuteButton.y + sfxMuteButton.height + Util.UI_PADDING;

			runButton = new Clickable(3 *  Util.PIXELS_PER_TILE,
									  Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE,
									  runFloor,
									  null,
									  textures[Util.ICON_RUN]);
			runButton.x = Util.STAGE_WIDTH - runButton.width - Util.UI_PADDING;
			runButton.y = Util.STAGE_HEIGHT - runButton.height - Util.UI_PADDING;

			shopHud = new ShopHUD(goldHud, closeShopHUD, textures);
			shopButton = new Clickable(goldHud.x, goldHud.height, openShopHUD, null, textures[Util.ICON_SHOP]);
			shopButton.x = runButton.x - shopButton.width - Util.UI_PADDING
			shopButton.y = Util.STAGE_HEIGHT - shopButton.height - Util.UI_PADDING;

			endButton = new Clickable(3 *  Util.PIXELS_PER_TILE,
									  Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE,
									  endRun,
									  null,
									  textures[Util.ICON_END]);
			endButton.x = runButton.x;
			endButton.y = runButton.y;

			runHud = new RunHUD(textures); // textures not needed for now but maybe in future
			buildHud = new BuildHUD(textures);

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
		}

		private function onCombatFailure(event:AnimationEvent):void {
			removeChild(currentCombat);

			logger.logAction(4, {
				"characterAttack":event.character.attack,
				"enemyAttack":event.enemy.attack,
				"enemyHealthLeft":event.enemy.hp
			});

			var alertBox:Sprite = new Sprite();
			var alertPopup:Image = new Image(textures[Util.POPUP_BACKGROUND])
			alertBox.addChild(alertPopup);
			alertBox.addChild(new TextField(alertPopup.width, alertPopup.height, FLOOR_FAIL_TEXT, Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			alertBox.x = (Util.STAGE_WIDTH - alertBox.width) / 2 - this.parent.x;
			alertBox.y = (Util.STAGE_HEIGHT - alertBox.height) / 2 - this.parent.y;

			messageToPlayer = new Clickable(0, 0, resetFloorCharacter, alertBox);
			//messageToPlayer.x = (Util.STAGE_WIDTH / 2) - (messageToPlayer.width);
			//messageToPlayer.y = (Util.STAGE_HEIGHT / 2) - (messageToPlayer.height);

			addChild(messageToPlayer);
		}

		private function resetFloorCharacter():void {
			removeChild(messageToPlayer);
			//removeChild(charHud);
			currentFloor.resetCharacter();
			//charHud = new CharHud(currentFloor.char, textures);
			//addChild(charHud);
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
				//removeChild(resetButton);
				removeChild(runButton);
				//removeChild(charHud);
				removeChild(buildHud);
				removeChild(goldHud);
				removeChild(runHud);
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

		public function switchToTransition(transition:Texture,
										   floor:String,
										   initialHealth:int,
										   initialStamina:int,
										   initialLoS:int):void {
			prepareSwap();

			isMenu = false;
			currentTransition = new Transition(0,
											   0,
											   switchToFloor,
											   null,
											   transition,
											   floor,
											   initialHealth,
											   initialStamina,
											   initialLoS);
			addChild(currentTransition);
		}

		public function switchToFloor(floorData:String,
									  initialHealth:int,
									  initialStamina:int,
									  initialLoS:int):void {
			prepareSwap();

			isMenu = false;

			var nextFloorData:Array = new Array();
			currentFloor = new Floor(floorData,
									 textures,
									 animations,
									 initialHealth,
									 initialStamina,
									 initialLoS,
									 floors,
									 switchToTransition,
									 mixer);
			if (currentFloor.floorName == Util.FLOOR_8) {
				currentFloor.altCallback = transitionToStart;
			}

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
			//addChild(resetButton);
			addChild(runButton);
			addChild(goldHud);
			addChild(shopButton);
			//charHud = new CharHud(currentFloor.char, textures);
			//addChild(charHud);

			addChild(buildHud);

			mixer.play(Util.FLOOR_BEGIN);
			gameState = STATE_BUILD;
		}

		public function transitionToStart(a:Array):void {
			createMainMenu();
		}

		public function createMainMenu():void {
			var titleField:TextField = new TextField(512, 80, "You Make The Dungeon", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			titleField.x = (Util.STAGE_WIDTH / 2) - (titleField.width / 2);
			titleField.y = 32 + titleField.height / 2;

			floors = Embed.setupFloors();

			var startGameButton:StartGame = new StartGame(
					256,
					192,
					switchToTransition,
					new TextField(128, 40, "START", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE),
					null,
					transitions[Util.MAIN_FLOOR],
					floors[Util.MAIN_FLOOR],
					Util.STARTING_HEALTH,
					Util.STARTING_STAMINA,
					Util.STARTING_LOS);

			var creditsButton:Clickable = new Clickable(
					256,
					256,
					createCredits,
					new TextField(128, 40, "CREDITS", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			switchToMenu(new Menu(new Array(titleField, startGameButton, creditsButton)));
		}

		public function createCredits():void {
			var startButton:Clickable = new Clickable(256, 192, createMainMenu, new TextField(128, 40, "BACK", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			var creditsLine:TextField = new TextField(256, 256, "THANKS", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			switchToMenu(new Menu(new Array(startButton)));
		}

		public function openShopHUD():void {
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
		}

		public function toggleSFXMute():void {
			mixer.toggleSFXMute();
		}

		public function resetFloor():void {
			//logger.logAction(8, { "numberOfTiles":numberOfTilesPlaced, "AvaliableTileSpots":(currentFloor.gridHeight * currentFloor.gridWidth - currentFloor.preplacedTiles),
			//			     "EmptyTilesPlaced":emptyTiles, "MonsterTilesPlaced":enemyTiles, "HealthTilesPlaced":healingTiles} );
			//reset counters
			numberOfTilesPlaced = 0;
			emptyTiles = 0;
			enemyTiles = 0;
			healingTiles = 0;
			currentFloor.resetFloor();
			//charHud.char = currentFloor.char
			mixer.play(Util.TILE_REMOVE);
		}

		public function runFloor():void {
			logger.logAction(3, {
				"numberOfTiles":numberOfTilesPlaced,
				"EmptyTilesPlaced":emptyTiles,
				"MonsterTilesPlaced":enemyTiles,
				"HealthTilesPlaced":healingTiles
			});
			removeChild(runButton);
			buildHud.deselect();
			currentFloor.clearHighlightedLocations();
			removeChild(buildHud);
			removeChild(shopButton);

			addChild(endButton);
			addChild(runHud);
			gameState = STATE_RUN;
			currentFloor.toggleRun();

			constructPhaseBanner();
		}

		public function onStaminaExpended(event:GameEvent):void {
			endRun();
		}

		public function endRun():void {
			//TODO: I AM A STUB
			// 		call at end of run automatically when stamina <= 0
			//		reset char, bring up new display which triggers phase change afterwards
			//		add gold and other items
			// will log gold gained here, stamina left, health left,
			// and other keys as seen needed
			//TODO: figure out how to log gold earned
			logger.logAction(8, {
				"goldEarned":0,
				"staminaLeft": currentFloor.char.stamina,
				"healthLeft": currentFloor.char.hp
			});

			removeChild(endButton);
			removeChild(runHud);
			addChild(runButton);

			buildHud.updateUI();
			addChild(buildHud);
			addChild(shopButton);

			gameState = STATE_BUILD;
			currentFloor.toggleRun();
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

			if(phaseBanner) {
				phaseBannerTimer += event.passedTime;
				addChild(phaseBanner);
				if(phaseBannerTimer > PHASE_BANNER_DURATION) {
					removeChild(phaseBanner);
					phaseBanner = null;
				}
			}

			removeChild(buildHud.currentImage);
			if(gameState == STATE_BUILD && buildHud && buildHud.hasSelected() && showBuildHudImage) {
				addChild(buildHud.currentImage);
			}

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
					buildHud.currentImage.x = touch.globalX - (Util.PIXELS_PER_TILE / 2);
					buildHud.currentImage.y = touch.globalY - (Util.PIXELS_PER_TILE / 2);
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

			if(phaseBanner && touch.phase == TouchPhase.BEGAN && phaseBannerTimer > PHASE_BANNER_THRESHOLD) {
				removeChild(phaseBanner);
				phaseBanner = null;
			}
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
					emptyTiles++;
					logger.logAction(1, { } );
					mixer.play(Util.TILE_MOVE);
				} else {
					mixer.play(Util.TILE_FAILURE);
				}
			} else if (buildHud.hudState == BuildHUD.STATE_ENTITY) {
				cost = buildHud.getCost();
				if (currentFloor.isEmptyTile(currentTile) && gold - cost >= 0) {
					gold -= cost;
					goldHud.update(gold);
					// Player correctly placed the entity. Add it to the grid.
					newEntity = buildHud.buildEntityFromImage(currentTile);
					currentFloor.entityGrid[newEntity.grid_x][newEntity.grid_y] = newEntity;
					currentFloor.addChild(newEntity);
					mixer.play(Util.TILE_MOVE);
				} else {
					mixer.play(Util.TILE_FAILURE);
				}
			}
		}

		private function onKeyDown(event:KeyboardEvent):void {
			// to ensure that they can't move the world around until
			// a floor is loaded, and not cause flash errors
			var input:String = String.fromCharCode(event.charCode);


			if(input == Util.MUTE_KEY) {
				mixer.togglePlay();
			}

			if(input == Util.COMBAT_SKIP_KEY) {
				combatSkip = !combatSkip;
				if(currentCombat && gameState == STATE_COMBAT) {
					if(currentCombat.skipping != combatSkip) {
						currentCombat.toggleSkip();
					}
				}
			}

			if (currentFloor) {
				// TODO: set up dictionary of charCode -> callback?
				if(currentFloor.floorName == Util.TUTORIAL_PAN_FLOOR) {
					currentFloor.removeTutorial();
				}

				// TODO: add bounds that the camera cannot go beyond,
				//		 and limit what contexts the camera movement
				//		 can be used in.
				if (input == Util.DOWN_KEY) {
					world.y -= Util.grid_to_real(Util.CAMERA_SHIFT);
					if (world.y < -1 * Util.PIXELS_PER_TILE * (currentFloor.gridHeight - 1)) {
						currentFloor.shiftTutorialY(Util.PIXELS_PER_TILE * (currentFloor.gridHeight - 1) + world.y + Util.grid_to_real(Util.CAMERA_SHIFT));
						world.y = -1 * Util.PIXELS_PER_TILE * (currentFloor.gridHeight - 1);
					} else {
						currentFloor.shiftTutorialY(Util.grid_to_real(Util.CAMERA_SHIFT));
					}
					logger.logAction(2, { "pannedDirection":"down"} );
				}

				if (input == Util.UP_KEY) {
					world.y += Util.grid_to_real(Util.CAMERA_SHIFT);
					if (world.y > Util.PIXELS_PER_TILE * -1 + Util.STAGE_HEIGHT) {
						currentFloor.shiftTutorialY(-1 * Util.grid_to_real(Util.CAMERA_SHIFT) + world.y - Util.STAGE_HEIGHT + Util.PIXELS_PER_TILE);
						world.y = Util.PIXELS_PER_TILE * -1 + Util.STAGE_HEIGHT
					} else {
						currentFloor.shiftTutorialY( -1 * Util.grid_to_real(Util.CAMERA_SHIFT));
					}
					logger.logAction(2, { "pannedDirection":"up"} );
				}

				if (input == Util.RIGHT_KEY) {
					world.x -= Util.grid_to_real(Util.CAMERA_SHIFT);
					if (world.x < -1 * Util.PIXELS_PER_TILE * (currentFloor.gridWidth - 1)) {
						currentFloor.shiftTutorialX(Util.PIXELS_PER_TILE * (currentFloor.gridWidth -1 ) + world.x + Util.grid_to_real(Util.CAMERA_SHIFT));
						world.x = -1 * Util.PIXELS_PER_TILE * (currentFloor.gridWidth - 1);
					} else {
						currentFloor.shiftTutorialX(Util.grid_to_real(Util.CAMERA_SHIFT));
					}
					logger.logAction(2, { "pannedDirection":"right"} );
				}

				if (input == Util.LEFT_KEY) {
					world.x += Util.grid_to_real(Util.CAMERA_SHIFT);
					if (world.x > Util.PIXELS_PER_TILE * -1 + Util.STAGE_WIDTH) {
						currentFloor.shiftTutorialX(-1 * Util.grid_to_real(Util.CAMERA_SHIFT) + world.x - Util.STAGE_WIDTH + Util.PIXELS_PER_TILE);
						world.x = Util.PIXELS_PER_TILE * -1 + Util.STAGE_WIDTH
					} else {
						currentFloor.shiftTutorialX( -1 * Util.grid_to_real(Util.CAMERA_SHIFT));
					}
					logger.logAction(2, { "pannedDirection":"left"} );
				}
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
	}
}
