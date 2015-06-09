package {
	import flash.net.SharedObject;
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

	import entities.*;
	import menu.MenuEvent;
	import tiles.*;
	import tutorial.*;

	public class Game extends Sprite {
		public static const FLOOR_FAIL_TEXT:String =
				"Nea was defeated!\nClick here to continue building.";
		public static const LEVEL_UP_TEXT:String =
				"Nea levelled up!\nHealth fully restored!\n+{0} max health\n+{1} attack\nClick to dismiss";
		public static const BUILD_TUTORIAL_TEXT:String =
				"Buy tiles to make a path for Nea.\nClick the arrows to choose the tile walls.";
		public static const PLACE_TUTORIAL_TEXT:String =
				"Place the tile on one of the green highlighted spots.";
		public static const RUN_TUTORIAL_TEXT:String =
				"Click here when\nyou're done building.";
		public static const MOVE_TUTORIAL_TEXT:String = "To move Nea";
		public static const HEALTH_TUTORIAL_TEXT:String =
				"This is Nea's health. Nea loses health when fighting adventurers."
		public static const STAMINA_TUTORIAL_TEXT:String =
				"This is Nea's stamina. Nea can move until she runs out of stamina."
		public static const SHOP_TUTORIAL_TEXT:String =
				"Click here to upgrade Nea's stats.";
		public static const ENTITY_TUTORIAL_TEXT:String =
				"Click up here to buy and place an enemy, health boost, stamina boost, or trap.";
		public static const ENTITY_DROPDOWN_TUTORIAL_TEXT:String =
				"Click the buttons to see other choices.";
		public static const DELETE_TUTORIAL_TEXT:String =
				"Click here to sell back tiles you placed.";
		public static const SPEED_MOVE_TUTORIAL_TEXT:String =
				"Click here to make Nea move faster.";
		public static const SPEED_COMBAT_TUTORIAL_TEXT:String =
				"Click here to speed up combat.";
		public static const PAN_TUTORIAL_TEXT:String =
				"To go to other parts of the dungeon"

		public static const PHASE_BANNER_DURATION:Number = 0.75; // seconds
		public static const PHASE_BANNER_THRESHOLD:Number = 0.05;
		public static const PHASE_CHANGE_THRESHOLD:Number = 0.40;

		public static const MIN_TILES_ON_SCREEN:int = 5;

		public static const DEFAULT_CAMERA_ACCEL:int = 1;
		public static const MAX_CAMERA_ACCEL:int = 4;

		public static const STATE_BUILD:String = "game_build";
		public static const STATE_RUN:String = "game_run";
		public static const STATE_COMBAT:String = "game_combat";
		public static const STATE_TUTORIAL:String = "game_tutorial";
		public static const STATE_SUMMARY:String = "game_summary";
		public static const STATE_CINEMATIC:String = "game_cinematic";

		// tutorialState values
		public static const TUTORIAL_WAITING_FOR_EDGES:String = "waiting_for_edges";
		public static const TUTORIAL_WAITING_FOR_PLACE:String = "waiting_for_place";
		public static const TUTORIAL_WAITING_FOR_RUN:String = "waiting_for_run";
		public static const TUTORIAL_WAITING_FOR_SPEED:String = "waiting_for_speed";

		public static const UNLOCK_TUTORIAL_STATE_NONE:int = 0;
		public static const UNLOCK_TUTORIAL_STATE_FIRST:int = 1;
		public static const UNLOCK_TUTORIAL_STATE_SHOWN:int = 2;

		private var runButton:Clickable;
		private var endButton:Clickable;
		private var combatSpeedButton:Clickable;
		private var runSpeedButton:Clickable;
		private var helpButton:Sprite;
		private var helpImageSprite:Sprite;
		private var helpImage:Image;

		private var bgmMuteButton:Clickable;
		private var sfxMuteButton:Clickable;

		private var cursorHighlight:Image;

		private var world:Sprite;
		private var currentFloor:Floor;

		private var numberOfTilesPlaced:int;
		private var entitiesPlaced:int;
		private var goldSpent:int;

		private var currentCombat:CombatHUD;
		private var combatSkip:Boolean;
		private var runPhaseSpeed:Boolean;
		private var runHud:RunHUD;
		private var goldHud:GoldHUD;
		private var shopHud:ShopHUD;
		private var buildHud:BuildHUD;
		private var showBuildHudImage:Boolean;

		private var runSummary:Summary;
		private var unlock:Unlock;

		private var gameState:String;
		private var popupActive:Boolean;
		// True if endRun() needs to be called after the current popup is dismissed.
		private var endRunDeferred:Boolean;

		private var gold:int;

		private var phaseBanner:Image;
		private var phaseBannerTimer:Number;
		private var phaseTimer:Number;

		private var tileUnlockTimer:Number;

		private var cameraAccel:Number;
		// Key -> Boolean representing which keys are being held down
		private var pressedKeys:Dictionary;

		// The most recent position of the mouse
		private var lastMouseX:int;
		private var lastMouseY:int;

		// for action 21, logging hover info help
		private var helping:Boolean;
		private var timeHovered:Number;

		private var saveGame:SharedObject;

		// for keeping track of scores
		// best per run
		private var bestRunGoldEarned:int;
		private var bestRunDistance:int;
		private var bestRunEnemiesDefeated:int;
		//private var bestRunTrapsUsed;

		// overall stats
		private var overallGoldEarned:int;
		private var overallDistance:int;
		private var overallEnemiesDefeated:int;
		//private var overallTrapsUsed;
		private var overallTilesPlaced:int;
		private var overallGoldSpent:int;

		// Tutorial state
		private var tutorialManager:TutorialManager;
		private var cinematic:Cinematic;
		private var buildCount:int;
		private var runCount:int;
		private var tutorialCount:int;
		private var unlockTutorialState:int;

		public function Game(fromSave:Boolean,
							 sfxMuteButton:Clickable,
							 bgmMuteButton:Clickable) {
			super();
			saveGame = SharedObject.getLocal("saveGame");

			this.sfxMuteButton = sfxMuteButton;
			this.bgmMuteButton = bgmMuteButton;

			// Log variables
			numberOfTilesPlaced = 0;
			timeHovered = 0;

			cameraAccel = DEFAULT_CAMERA_ACCEL;
			pressedKeys = new Dictionary();

			gameState = fromSave ? STATE_BUILD : STATE_TUTORIAL;
			gold = fromSave ? saveGame.data["gold"] : Util.STARTING_GOLD;
			Util.speed = Util.SPEED_SLOW;
			combatSkip = false;

			popupActive = false;
			endRunDeferred = false;

			// setting up scores and stats
			bestRunGoldEarned = fromSave ? saveGame.data["bestRunGoldEarned"] : 0;
			bestRunDistance = fromSave ? saveGame.data["bestRunDistance"] : 0;
			bestRunEnemiesDefeated = fromSave ? saveGame.data["bestRunEnemiesDefeated"] : 0;
			//bestRunTrapsUsed = fromSave ? saveGame.data["bestRunTrapsUsed"] : 0;

			overallGoldEarned = fromSave ? saveGame.data["overallGoldEarned"] : 0;
			overallDistance = fromSave ? saveGame.data["overallDistance"] : 0;
			overallEnemiesDefeated = fromSave ? saveGame.data["overallEnemiesDefeated"] : 0;
			//overallTrapsUsed = fromSave ? saveGame.data["overallTrapsUsed"] : 0;
			overallTilesPlaced = fromSave ? saveGame.data["overallTilesPlaced"] : 0;
			overallGoldSpent = fromSave ? saveGame.data["overallGoldSpent"] : 0;

			initializeWorld(fromSave);
			initializeUI();
			initializeTutorial(fromSave, saveGame);

			addChild(world);
			addChild(sfxMuteButton);
			addChild(bgmMuteButton);
			addChild(combatSpeedButton);
			addChild(runSpeedButton);
			addChild(goldHud);
			addChild(helpButton);
			addChild(runHud);
			addChild(endButton);
			addChild(tutorialManager);
			runHud.startRun();
			gameState = STATE_RUN;
			currentFloor.toggleRun(gameState);

			// Update build hud with unlocks if loading from save.
			if (fromSave) {
				if (saveGame.data["unlocks"]) {
					for (var i:int = 0; i < saveGame.data["unlocks"].length; i++) {
						buildHud.entityFactory.unlockTile(saveGame.data["unlocks"][i]);
					}
					buildHud.updateHUD();
				}
			}

			centerWorldOnCharacter();

			Util.logger.logLevelStart(1, {
				"characterHP": currentFloor.char.maxHp,
				"characterStamina": currentFloor.char.maxStamina,
				"characterAttack": currentFloor.char.attack
			});

			Assets.mixer.play(Util.FLOOR_BEGIN);

			// Game loop event.
			addEventListener(EnterFrameEvent.ENTER_FRAME, onFrameBegin);

			// Input events.
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(TouchEvent.TOUCH, onMouseEvent);

			// Combat animation events.
			addEventListener(AnimationEvent.CHAR_DIED, onCombatFailure);
			addEventListener(AnimationEvent.ENEMY_DIED, onCombatSuccess);

			// Game events.
			addEventListener(GameEvent.BUILD_HUD_IMAGE_CHANGE, clearBuildHUDImage);
			addEventListener(GameEvent.COMPLETE_ROOM, onRoomComplete);
			addEventListener(GameEvent.CHARACTER_LOS_CHANGE, onLosChange);
			addEventListener(GameEvent.ENTERED_COMBAT, startCombat);
			addEventListener(GameEvent.GAIN_GOLD, onGainGold);
			addEventListener(GameEvent.SHOP_SPEND, onShopSpend);
			addEventListener(GameEvent.STAMINA_EXPENDED, onStaminaExpended);
			addEventListener(GameEvent.UNLOCK_TILE, onEntityUnlock);
			addEventListener(GameEvent.ARRIVED_AT_EXIT, onCharExited);
			addEventListener(GameEvent.GET_TRAP_REWARD, onGetTrapReward);
			addEventListener(GameEvent.KEYBOARD_TOGGLE_TILE, onKeyboardToggleTile);

			// Tutorial-specific game events.
			addEventListener(GameEvent.MOVE_CAMERA, onMoveCamera);

			addEventListener(TutorialEvent.CLOSE_TUTORIAL, onCloseTutorial);
			addEventListener(TutorialEvent.END_RUN, onTutorialEndRun);
			addEventListener(TutorialEvent.REVEAL_ENEMY, onTutorialRevealEnemy);
			addEventListener(TutorialEvent.REVEAL_TRAP, onTutorialRevealTrap);
			addEventListener(GameEvent.SURFACE_ELEMENT, sendToTop);
		}

		private function initializeWorld(fromSave:Boolean):void {
			world = new Sprite();

			cursorHighlight = new Image(Assets.textures[Util.TILE_HL_B]);
			cursorHighlight.touchable = false;

			runSummary = new Summary(40, 40, returnToBuild, null, Assets.textures[Util.SUMMARY_BACKGROUND]);

			var health:int = fromSave ? saveGame.data["hp"] : Util.STARTING_HEALTH;
			var stamina:int = fromSave ? saveGame.data["stamina"] : Util.STARTING_STAMINA;
			var attack:int = fromSave ? saveGame.data["attack"] : Util.STARTING_ATTACK;
			var los:int = fromSave ? saveGame.data["los"] : Util.STARTING_LOS;

			currentFloor = new Floor(Assets.floors[Util.MAIN_FLOOR],
									 health,
									 stamina,
									 attack,
									 los,
									 runSummary);
			currentFloor.changeVisibleChildren(world.x, world.y, true);

			world.addChild(cursorHighlight);
			world.addChild(currentFloor);
		}

		private function initializeUI():void {
			combatSpeedButton = new Clickable(0, 0, toggleCombatSpeed, null, Assets.textures[Util.ICON_SLOW_COMBAT]);
			combatSpeedButton.x = bgmMuteButton.x - combatSpeedButton.width - Util.UI_PADDING;
			combatSpeedButton.y = Util.STAGE_HEIGHT - combatSpeedButton.height - Util.UI_PADDING;
			runSpeedButton = new Clickable(0, 0, toggleRunSpeed, null, Assets.textures[Util.ICON_SLOW_RUN]);
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
			var helpButtonImage:Image = new Image(Assets.textures[Util.ICON_HELP]);
			helpButton.addChild(helpButtonImage);
			helpButton.x = runSpeedButton.x - helpButton.width - Util.UI_PADDING;
			helpButton.y = runSpeedButton.y;

			goldHud = new GoldHUD(gold);
			goldHud.x = Util.STAGE_WIDTH - goldHud.width;
			goldHud.y = Util.UI_PADDING;

			runButton = new Clickable(3 *  Util.PIXELS_PER_TILE,
									  Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE,
									  runFloor,
									  null,
									  Assets.textures[Util.ICON_RUN]);
			runButton.x = goldHud.x - runButton.width - Util.UI_PADDING;
			runButton.y = Util.UI_PADDING;

			shopHud = new ShopHUD();
			shopHud.char = currentFloor.char;

			endButton = new Clickable(3 *  Util.PIXELS_PER_TILE,
									  Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE,
									  endRunButton,
									  null,
									  Assets.textures[Util.ICON_END]);
			endButton.x = runButton.x;
			endButton.y = runButton.y;

			runHud = new RunHUD(); // textures not needed for now but maybe in future
			buildHud = new BuildHUD();
		}

		private function initializeTutorial(fromSave:Boolean, saveGame:SharedObject):void {
			tutorialManager = new TutorialManager();
			if (!fromSave) {
				tutorialManager.addTutorial(Assets.textures[Util.TUTORIAL_NEA]);
				tutorialManager.addTutorial(Assets.textures[Util.TUTORIAL_EXIT]);
			}

			buildCount = fromSave ? saveGame.data["buildCount"] : 0;
			if (saveGame.data["buildCount"] == null) {
				buildCount = 0;
			}
			runCount = fromSave ? saveGame.data["runCount"] : 0;
			if (saveGame.data["runCount"] == null) {
				runCount = 0;
			}
			tutorialCount = fromSave ? saveGame.data["tutorialCount"] : 0;
			if (saveGame.data["tutorialCount"] == null) {
				tutorialCount = 0;
			}
		}

		private function returnToMenu():void {
			dispatchEvent(new MenuEvent(MenuEvent.EXIT));
		}

		private function startCombat(e:GameEvent):void {
			currentCombat = new CombatHUD(currentFloor.char,
										  currentFloor.entityGrid[e.x][e.y],
										  combatSkip);
			removeChild(endButton);
			addChild(currentCombat);
			popupActive = true;
			currentFloor.char.moveLock = true;
		}

		private function onCombatSuccess(event:AnimationEvent):void {
			removeChild(currentCombat);
			addChild(endButton);

			currentFloor.onCombatSuccess(event.enemy);
			gold += event.enemy.reward;
			runSummary.goldCollected += event.enemy.reward;
			goldHud.update(gold);

			popupActive = false;
			currentFloor.char.moveLock = false;
			if (endRunDeferred) {
				endRunDeferred = false;
				endRun();
			}
		}

		private function onCombatFailure(event:AnimationEvent):void {
			removeChild(currentCombat);

			popupActive = false;
			currentFloor.char.moveLock = false;

			Util.logger.logAction(4, {
				"characterAttack":event.character.attack,
				"enemyAttack":event.enemy.attack,
				"enemyHealthLeft":event.enemy.hp
			});

			endRun();
		}

		public function onShopSpend(e:GameEvent):void {
			var cost:int = e.gameData["cost"];
			if (gold - cost < 0) {
				// Cannot purchase item
				goldHud.setFlash();
				return;
			}

			gold -= cost;
			goldSpent += cost;
			goldHud.update(gold);
			shopHud.incStat(e.gameData["type"], cost);
		}

		public function constructPhaseBanner(run:Boolean = true):void {
			removeChild(phaseBanner);
			phaseBanner = new Image(Assets.textures[run ? Util.RUN_BANNER : Util.BUILD_BANNER]);
			phaseBanner.y = (Util.STAGE_HEIGHT - phaseBanner.height) / 2;
			phaseBannerTimer = 0;
			addChild(phaseBanner);

			tutorialManager.canSkip(false);
		}

		public function runFloor():void {
			if ((tutorialManager.state != "" && tutorialManager.state != TutorialManager.RUN)
			 	|| gameState == STATE_CINEMATIC) {
				return;
			}

			Util.logger.logAction(3, {
				"numberOfTiles":numberOfTilesPlaced,
				"numberOfEntitiesPlaced":entitiesPlaced,
				"goldSpent":goldSpent
			});

			// set up saving before running floor as well.
			saveGame.clear();
			saveGame.data["gold"] = gold;
			saveGame.data["unlocks"] = new Array();
			for (var unlock:String in buildHud.entityFactory.entitySet) {
				saveGame.data["unlocks"].push(unlock);
			}

			// insert score stuff here yet again
			saveGame.data["bestRunGoldEarned"] = bestRunGoldEarned;
			saveGame.data["bestRunDistance"] = bestRunDistance;
			saveGame.data["bestRunEnemiesDefeated"] = bestRunEnemiesDefeated;

			saveGame.data["overallGoldEarned"] = overallGoldEarned;
			saveGame.data["overallDistance"] = overallDistance;
			saveGame.data["overallEnemiesDefeated"] = overallEnemiesDefeated;
			overallTilesPlaced += numberOfTilesPlaced;
			saveGame.data["overallTilesPlaced"] = overallTilesPlaced;
			overallGoldSpent += goldSpent;
			saveGame.data["overallGoldSpent"] = overallGoldSpent;

			saveGame.data["buildCount"] = buildCount;
			saveGame.data["runCount"] = runCount;
			saveGame.data["tutorialCount"] = tutorialCount;

			saveGame.flush();

			currentFloor.save();

			goldSpent = 0;
			numberOfTilesPlaced = 0;
			entitiesPlaced = 0;

			currentFloor.clearHighlightedLocations();
			buildHud.deselect();

			removeChild(runButton);
			removeChild(buildHud);
			removeChild(shopHud);

			addChild(endButton);
			addChild(runHud);
			runCount += 1;
			gameState = STATE_RUN;

			if (tutorialManager.state == TutorialManager.RUN) {
				// This means the run button was hit, so clean up the build hud
				// tutorial and remove all of the interactivity.
				tutorialManager.setInteractive(false);
				tutorialManager.state = "";
				tutorialManager.closeTutorial();
			}

			if (runCount == 2) {
				tutorialManager.addTutorialWithBackground(
						Assets.textures[Util.TUTORIAL_HEALTH_STAMINA],
						Assets.textures[Util.TUTORIAL_HEALTH_STAMINA_SHADOW]);
			}
			if (runCount == 5) {
				tutorialManager.addTutorialWithBackground(
						Assets.textures[Util.TUTORIAL_SPEED],
						Assets.textures[Util.TUTORIAL_SPEED_SHADOW]);
			}

			runHud.startRun();
			currentFloor.toggleRun(gameState);
			constructPhaseBanner();
		}

		public function onStaminaExpended(event:GameEvent):void {
			if (popupActive || gameState != STATE_RUN) {
				endRunDeferred = true;
			} else {
				endRun();
			}
		}

		private function onRoomComplete(event:GameEvent):void {
			if(!event.gameData["completed"]) {
				return;
			}
		}

		public function endRun():void {
			var reason:String;
			if (currentFloor.char.hp <= 0) {
				reason = "healthExpended";
			} else if (currentFloor.char.stamina <= 0) {
				reason = "staminaExpended";
			} else {
				reason = "endRunButton";
			}
			Util.logger.logAction(8, {
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

			if (buildHud.directions[Util.NORTH]) {
				buildHud.toggleNorth();
			}

			if (buildHud.directions[Util.SOUTH]) {
				buildHud.toggleSouth();
			}

			if (buildHud.directions[Util.WEST]) {
				buildHud.toggleWest();
			}

			if (buildHud.directions[Util.EAST]) {
				buildHud.toggleEast();
			}

			buildHud.deselect();

			gameState = STATE_SUMMARY;
			bestRunGoldEarned = Math.max(bestRunGoldEarned, runSummary.goldCollected);
			bestRunDistance = Math.max(bestRunDistance, runSummary.distanceTraveled);
			bestRunEnemiesDefeated = Math.max(bestRunEnemiesDefeated, runSummary.enemiesDefeated);
			runSummary.bestGold = bestRunGoldEarned;
			runSummary.bestDistance = bestRunDistance;
			runSummary.bestEnemies = bestRunEnemiesDefeated;
			if (reason == "endRunButton") {
				runSummary.reason = "";
			} else if (reason == "staminaExpended") {
				runSummary.reason = "Ran out of Stamina";
			} else {
				runSummary.reason = "Ran out of Health";
			}
			addChild(runSummary);
			currentFloor.toggleRun(STATE_BUILD);

			if (runCount == 0) {
				dispatchEvent(new TutorialEvent(TutorialEvent.END_RUN));
			}
		}

		public function endRunButton():void {
			if(currentFloor && gameState == STATE_RUN && !popupActive) {
				endRun();
			}
		}

		public function returnToBuild():void {
			removeChild(runSummary);

			saveGame.clear();
			saveGame.data["gold"] = gold;
			saveGame.data["unlocks"] = new Array();
			for (var unlock:String in buildHud.entityFactory.entitySet) {
				saveGame.data["unlocks"].push(unlock);
			}

			// insert score stuff here (for run based stuff)
			saveGame.data["bestRunGoldEarned"] = Math.max(bestRunGoldEarned, runSummary.goldCollected);
			bestRunGoldEarned = saveGame.data["bestRunGoldEarned"];
			saveGame.data["bestRunDistance"] = Math.max(bestRunDistance, runSummary.distanceTraveled);
			bestRunDistance = saveGame.data["bestRunDistance"];
			saveGame.data["bestRunEnemiesDefeated"] = Math.max(bestRunEnemiesDefeated, runSummary.enemiesDefeated);
			bestRunEnemiesDefeated = saveGame.data["bestRunEnemiesDefeated"];

			overallGoldEarned += runSummary.goldCollected;
			saveGame.data["overallGoldEarned"] = overallGoldEarned;
			overallDistance += runSummary.distanceTraveled;
			saveGame.data["overallDistance"] = overallDistance;
			overallEnemiesDefeated += runSummary.enemiesDefeated;
			saveGame.data["overallEnemiesDefeated"] = overallEnemiesDefeated;
			saveGame.data["overallTilesPlaced"] = overallTilesPlaced;
			saveGame.data["overallGoldSpent"] = overallGoldSpent;

			saveGame.data["buildCount"] = buildCount;
			saveGame.data["runCount"] = runCount;
			saveGame.data["tutorialCount"] = tutorialCount;

			saveGame.flush();

			runSummary.reset();

			addChild(runButton);

			buildHud.updateUI();
			addChild(buildHud);
			addChild(shopHud);

			gameState = STATE_BUILD;
			buildCount += 1;
			currentFloor.resetFloor();
			centerWorldOnCharacter();
			constructPhaseBanner(false); // happens after the summary dialog box

			if (buildCount == 1) {
				// First build phase
				tutorialManager.addTutorialWithBackground(
						Assets.textures[Util.TUTORIAL_BUILD_HUD],
						Assets.textures[Util.TUTORIAL_BUILDHUD_SHADOW]);
				tutorialManager.addTutorialWithBackground(
						Assets.textures[Util.TUTORIAL_PLACE],
						Assets.textures[Util.TUTORIAL_PLACE_SHADOW]);
				tutorialManager.addTutorialNoBackground(
						Assets.textures[Util.TUTORIAL_START_RUN]);
				tutorialManager.setInteractive(true);
				tutorialManager.state = TutorialManager.BUILD;
			} else if (buildCount == 2) {
				tutorialManager.addTutorial(Assets.textures[Util.TUTORIAL_PAN]);
			} else if (buildCount == 4) {
				tutorialManager.addTutorialWithBackground(
						Assets.textures[Util.TUTORIAL_SECONDARY_BUILD],
						Assets.textures[Util.TUTORIAL_SECONDARY_BUILD_SHADOW]);
			} else if (buildCount == 6) {
				tutorialManager.addTutorial(Assets.textures[Util.TUTORIAL_HELP]);
			}

			if (unlockTutorialState == UNLOCK_TUTORIAL_STATE_FIRST) {
				unlockTutorialState = UNLOCK_TUTORIAL_STATE_SHOWN;
				tutorialManager.addTutorialWithBackground(
						Assets.textures[Util.TUTORIAL_UNLOCK],
						Assets.textures[Util.TUTORIAL_ENTITY_SHADOW]);
			}
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
			currentFloor.changeVisibleChildren(world.x, world.y, true);
		}

		private function onFrameBegin(event:EnterFrameEvent):void {
			if (helping) {
				timeHovered += event.passedTime;
			}

			cameraAccel += event.passedTime;
			if(cameraAccel > MAX_CAMERA_ACCEL) {
				cameraAccel = MAX_CAMERA_ACCEL;
			}

			var worldShift:int = Util.CAMERA_SHIFT * cameraAccel;
			if (pressedKeys[Util.DOWN_KEY]) {
				world.y -= worldShift;
				//if (world.y < -1 * Util.PIXELS_PER_TILE * (currentFloor.gridHeight - 1)) {
				if (world.y < -1 * Util.PIXELS_PER_TILE * (currentFloor.gridHeight - MIN_TILES_ON_SCREEN)) {
					world.y = -1 * Util.PIXELS_PER_TILE * (currentFloor.gridHeight - MIN_TILES_ON_SCREEN);
				}
				currentFloor.changeVisibleChildren(world.x, world.y);
			}

			if (pressedKeys[Util.UP_KEY]) {
				world.y += worldShift;
				if (world.y > Util.PIXELS_PER_TILE * -1 + Util.grid_to_real(4)) {//Util.STAGE_HEIGHT) {
					world.y = Util.PIXELS_PER_TILE * -1 + Util.grid_to_real(4);//Util.STAGE_HEIGHT;
				}
				currentFloor.changeVisibleChildren(world.x, world.y);
			}

			if (pressedKeys[Util.RIGHT_KEY]) {
				world.x -= worldShift;
				if (world.x < -1 * Util.PIXELS_PER_TILE * (currentFloor.gridWidth - MIN_TILES_ON_SCREEN - 2)) {
					world.x = -1 * Util.PIXELS_PER_TILE * (currentFloor.gridWidth - MIN_TILES_ON_SCREEN - 2);
				}
				currentFloor.changeVisibleChildren(world.x, world.y);
			}

			if (pressedKeys[Util.LEFT_KEY]) {
				world.x += worldShift;
				if (world.x > Util.PIXELS_PER_TILE * -1 + Util.grid_to_real(4)) {//Util.STAGE_WIDTH) {
					world.x = Util.PIXELS_PER_TILE * -1 + Util.grid_to_real(4);//Util.STAGE_WIDTH;
				}
				currentFloor.changeVisibleChildren(world.x, world.y);
			}

			if (phaseBanner) {
				phaseBannerTimer += event.passedTime;
				addChild(phaseBanner);
				if(phaseBannerTimer > PHASE_BANNER_DURATION) {
					removeChild(phaseBanner);
					phaseBanner = null;
					tutorialManager.canSkip(true);
				}
			}

			removeChild(buildHud.currentImage);
			if (gameState == STATE_BUILD && buildHud && buildHud.hasSelected() && showBuildHudImage) {
				addChild(buildHud.currentImage);
			}

			if (gameState == STATE_RUN && runHud && currentFloor && cinematic == null) {
				runHud.update(currentFloor.char);
				centerWorldOnCharacter();
			}
		}

		private function onMouseEvent(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			if (!touch) {
				return;
			}

			lastMouseX = touch.globalX;
			lastMouseY = touch.globalY;

			var xOffset:int = touch.globalX < world.x ? Util.PIXELS_PER_TILE : 0;
			var yOffset:int = touch.globalY < world.y ? Util.PIXELS_PER_TILE : 0;
			cursorHighlight.x = Util.grid_to_real(Util.real_to_grid(touch.globalX - world.x - xOffset));
			cursorHighlight.y = Util.grid_to_real(Util.real_to_grid(touch.globalY - world.y - yOffset));

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

			// If we are in the build hud tutorial, check to see if the player
			// has successfully selected a tile before advancing..
			if (tutorialManager.state == TutorialManager.BUILD) {
				trace("checking the build hud directions");
				// We want the player to click at least two arrows before
				// letting them place. It's less sudden and gives them a
				// usable tile.
				var ctr:int = 0;
				for (var i:int = 0; i < Util.DIRECTIONS.length; i++) {
					if (buildHud.directions[Util.DIRECTIONS[i]]) {
						ctr++;
					}
				}
				if (ctr > 1) {
					trace("more than 1 direction selected, moving to next state");
					tutorialManager.state = TutorialManager.PLACE;
					tutorialManager.closeTutorial();
				}
			}

			if (tutorialManager.isActive()) {
				return;
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
				helpImage = new Image(Assets.textures[gameState == STATE_BUILD ? Util.BUILD_HELP : Util.RUN_HELP]);
				helpImageSprite.addChild(helpImage);
				addChild(helpImageSprite);
				helping = true;
			} else {
				if (helping && (gameState == STATE_BUILD || gameState == STATE_RUN) && timeHovered >= 1) {
					var state:String = gameState == STATE_BUILD ? "buildState" : "runState";
					Util.logger.logAction(21, {
						"phaseHovered":state,
						"timeHovered":timeHovered
					});
					timeHovered = 0;
					helping = false;
					removeChild(helpImageSprite);
				}
			}

			if(phaseBanner && touch.phase == TouchPhase.BEGAN && phaseBannerTimer > PHASE_BANNER_THRESHOLD) {
				removeChild(phaseBanner);
				phaseBanner = null;
				tutorialManager.canSkip(true);
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
					var refund:int = buildHud.getRefundForDelete(currentTile, currentEntity);
					gold += refund;
					goldSpent -= refund;
					goldHud.update(gold);
					Assets.mixer.play(Util.TILE_REMOVE);
				} else {
					Assets.mixer.play(Util.TILE_FAILURE);
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
					currentFloor.removeFoggedLocationsInPath();
					currentFloor.changeVisibleChildren(world.x, world.y, true);
					numberOfTilesPlaced += 1;
					Util.logger.logAction(1, {
						"goldSpent": cost,
						"northOpen":newTile.north,
						"southOpen":newTile.south,
						"eastOpen":newTile.east,
						"westOpen":newTile.west
					});
					goldSpent += cost;
					Assets.mixer.play(Util.TILE_MOVE);

					// If we are in the build hud tutorial, and waiting for the
					// player to place a tile, then advance to the next part.
					if (tutorialManager.state == TutorialManager.PLACE) {
						tutorialManager.state = TutorialManager.RUN;
						tutorialManager.closeTutorial();
					}

				} else if (currentFloor.highlightedLocations[newTile.grid_x][newTile.grid_y]) {
					// Could place but do not have gold required
					goldHud.setFlash();
					Util.logger.logAction(28, {
						"type":"tile"
					});
				} else {
					// Invalid placement
					Assets.mixer.play(Util.TILE_FAILURE);
					Util.logger.logAction(27, {
						"type":"tile"
					});
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
					currentFloor.addChild(newEntity);
					if (newEntity is Enemy) {
						currentFloor.activeEnemies.push(newEntity);
						type = "enemy";
					} else if (newEntity is Trap) {
						type = "trap";
					} else if (newEntity is StaminaHeal) {
						type = "stamina";
					}
					Assets.mixer.play(Util.TILE_MOVE);
					Util.logger.logAction(18, {
						"cost":cost,
						"entityPlaced":type
					});
					goldSpent += cost;
					entitiesPlaced++;
				} else if (currentFloor.isEmptyTile(currentTile)) {
					// Could place but do not have gold required
					goldHud.setFlash();
					Util.logger.logAction(28, {
						"type":"entity"
					});
				} else {
					// Invalid placement
					Assets.mixer.play(Util.TILE_FAILURE);
					Util.logger.logAction(27, {
						"type":"entity"
					});
				}
			}
			currentFloor.clearHighlightedLocations();
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if (gameState == STATE_CINEMATIC ||
				currentFloor.char.inCombat ||
				tutorialManager.isActive() ||
				phaseBanner != null) {
				pressedKeys = new Dictionary(); // Clear all currently pressed keys in loss of control
				return;
			}

			// to ensure that they can't move the world around until
			// a floor is loaded, and not cause flash errors
			pressedKeys[event.keyCode] = true;
			if (event.keyCode == Util.BGM_MUTE_KEY) {
				bgmMuteButton.onClick();
			}

			if (event.keyCode == Util.SFX_MUTE_KEY) {
				sfxMuteButton.onClick();
			}

			if (event.keyCode == Util.CHANGE_PHASE_KEY && phaseBanner == null) {
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
				if (currentCombat && gameState == STATE_COMBAT) {
					if (currentCombat.skipping != combatSkip) {
						currentCombat.toggleSkip();
					}
				}
			}

			if (event.keyCode == Util.SPEED_TOGGLE_KEY) {
				toggleRunSpeed();
			}
		}

		public function onKeyUp(event:KeyboardEvent):void {
			pressedKeys[event.keyCode] = false;

			if (!pressedKeys[Util.UP_KEY] && !pressedKeys[Util.DOWN_KEY] &&
				!pressedKeys[Util.LEFT_KEY] && !pressedKeys[Util.RIGHT_KEY]) {
				cameraAccel = DEFAULT_CAMERA_ACCEL;
			}
		}

		public function onKeyboardToggleTile(event:GameEvent):void {
			if (gameState == STATE_BUILD && buildHud.hasSelected()) {
				// Move buildHud image to cursor
				buildHud.currentImage.x = lastMouseX - buildHud.currentImage.width / 2;
				buildHud.currentImage.y = lastMouseY - buildHud.currentImage.height / 2;
				currentFloor.highlightAllowedLocations(buildHud.directions, buildHud.hudState);
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
			var addAmount:int = 0;
			if (event.x >= 0 && event.x < currentFloor.gridWidth &&
			    event.y >= 0 && event.y < currentFloor.gridHeight) { // if floor tile has gold
				var coin:Coin = currentFloor.goldGrid[event.x][event.y];
				addAmount += coin.gold;
				Util.logger.logAction(22, {
					"goldEarned":coin.gold
				});
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
				Util.logger.logAction(19, {
					"type":"gold",
					"goldEarned":addAmount
				});
			}

			gold += addAmount;
			runSummary.goldCollected += addAmount;
			runHud.goldCollected += addAmount;
			goldHud.update(gold);
		}

		public function toggleRunSpeed():void {
			Util.logger.logAction(15, {
				"buttonClicked":"Increase Speed"
			});

			runPhaseSpeed = !runPhaseSpeed;

			var chosen:String = runPhaseSpeed ? Util.ICON_FAST_RUN : Util.ICON_SLOW_RUN;
			runSpeedButton.updateImage(null, Assets.textures[chosen]);

			Util.speed = runPhaseSpeed ? Util.SPEED_FAST : Util.SPEED_SLOW;
			currentFloor.updateRunSpeed();
		}

		public function toggleCombatSpeed():void {
			Util.logger.logAction(15, {
				"buttonClicked":"Combat Skip"
			});

			combatSkip = !combatSkip;

			var chosen:String = combatSkip ? Util.ICON_FAST_COMBAT : Util.ICON_SLOW_COMBAT;
			combatSpeedButton.updateImage(null, Assets.textures[chosen]);
		}

		public function playCinematic(commands:Array, onComplete:Function):void {
			cinematic = new Cinematic(world.x,
									  world.y,
									  Util.CAMERA_SHIFT * 6,
									  commands,
									  onComplete);
			addChild(cinematic);
		}

		public function onMoveCamera(event:GameEvent):void {
			world.x += event.x;
			world.y += event.y;
			currentFloor.changeVisibleChildren(world.x, world.y);
		}

		public function onEntityUnlock(event:GameEvent):void {
			if(event.gameData["type"] && event.gameData["entity"]) {
				Assets.mixer.play(Util.LEVEL_UP);
				tileUnlockTimer = 0;

				if (unlockTutorialState == UNLOCK_TUTORIAL_STATE_NONE) {
					unlockTutorialState = UNLOCK_TUTORIAL_STATE_FIRST;
				}

				// Remove the entity from the grid.
				var reward:Reward = event.gameData["entity"];
				if (reward.permanent) {
					currentFloor.removedEntities.push(reward);
				}
				currentFloor.removeChild(reward);
				currentFloor.entityGrid[reward.grid_x][reward.grid_y] = null;

				// Unlock the tile in the build hud.
				buildHud.entityFactory.unlockTile(event.gameData["type"]);
				buildHud.updateHUD();


				var unlockedTile:Dictionary = buildHud.entityFactory.masterSet[event.gameData["type"]];
				var newEntity:Entity = unlockedTile["constructor"]();


				unlock = new Unlock(newEntity.img,
									newEntity.generateOverlay(),
									buildHud.entityFactory.entityText[event.gameData["type"]][0],
									newEntity.generateDescription(),
									buildHud.entityFactory.entityText[event.gameData["type"]][1],
									closeEntityUnlock);

				if (newEntity is Enemy) {
					var temp:Enemy = newEntity as Enemy;
					Util.logger.logAction(19, {
						"type":"enemy",
						"enemyHealth":temp.hp,
						"enemyAttack":temp.attack,
						"enemyReward":temp.reward,
						"enemyName":temp.enemyName
					});
				} else if (newEntity is StaminaHeal) {
					var tempS:StaminaHeal = newEntity as StaminaHeal;
					Util.logger.logAction(19, {
						"type":"staminaHeal",
						"staminaRestored":tempS.stamina
					});
				} else if (newEntity is Healing) {
					var tempH:Healing = newEntity as Healing;
					Util.logger.logAction(19, {
						"type":"healing",
						"healthRestored":tempH.health
					});
				} else if (newEntity is Trap) {
					var tempT:Trap = newEntity as Trap;
					Util.logger.logAction(19, {
						"type":"trap",
						"trapType":tempT.type,
						"trapDamage":tempT.damage,
						"trapRadius":tempT.radius
					});
				}

				addChild(unlock);
				popupActive = true;
				currentFloor.char.moveLock = true;
			}
		}

		public function closeEntityUnlock():void {
			removeChild(unlock);
			popupActive = false;
			currentFloor.char.moveLock = false;
			if (endRunDeferred) {
				endRunDeferred = false;
				endRun();
			}
		}

		private function onLosChange(event:GameEvent):void {
			currentFloor.removeFoggedLocationsInPath();
		}

		// Event handler for when a character arrives at an exit tile.
		private function onCharExited(e:GameEvent):void {
			if (Util.logger) {
				Util.logger.logLevelEnd({
					"characterHpRemaining":currentFloor.char.hp,
					"characterMaxHP":currentFloor.char.maxHp
				});
			}
			Assets.mixer.play(Util.FLOOR_COMPLETE);
			currentFloor.completed = true;

			var winBox:Sprite = new Sprite();
			var popup:Image = new Image(Assets.textures[Util.POPUP_BACKGROUND])
			winBox.addChild(popup);
			winBox.addChild(new TextField(popup.width,
										  popup.height,
										  "You did it!\nThanks for playing!\nClick here to return the the main menu.",
										  Util.DEFAULT_FONT,
										  Util.MEDIUM_FONT_SIZE));
			winBox.x = (Util.STAGE_WIDTH - winBox.width) / 2 - x;
			winBox.y = (Util.STAGE_HEIGHT - winBox.height) / 2 - y;

			var nC:Clickable = new Clickable(0, 0, returnToMenu, winBox);

			addChild(nC);
			popupActive = true;
			currentFloor.char.moveLock = true;
		}

		private function onGetTrapReward(e:GameEvent):void {
			gold += e.gameData["reward"];
			runSummary.goldCollected += e.gameData["reward"];
			goldHud.update(gold);

			runSummary.damageTaken += e.gameData["damage"];
			if (currentFloor.char.hp <= 0) {
				endRun();
			}
		}

		private function onCloseTutorial(event:TutorialEvent):void {
			tutorialCount += 1;

			if (tutorialCount == 2) {
				// Set up cinematic to show exit
				var commands:Array = new Array();

				var moveToExit:Dictionary = new Dictionary();
				moveToExit["command"] = Cinematic.COMMAND_MOVE;
				moveToExit["destX"] = world.x + Util.grid_to_real(0);
				moveToExit["destY"] = world.y + Util.grid_to_real(34);

				var waitAtExit:Dictionary = new Dictionary();
				waitAtExit["command"] = Cinematic.COMMAND_WAIT;
				waitAtExit["timeToWait"] = 1.5;

				var moveToStart:Dictionary = new Dictionary();
				moveToStart["command"] = Cinematic.COMMAND_MOVE;
				moveToStart["destX"] = world.x;
				moveToStart["destY"] = world.y;

				commands.push(moveToExit);
				commands.push(waitAtExit);
				commands.push(moveToStart);

				removeChild(endButton);
				removeChild(goldHud);
				removeChild(runHud);

				gameState = STATE_CINEMATIC;
				playCinematic(commands, exitCinematicCallback);
			}
		}

		private function exitCinematicCallback():void {
			removeChild(cinematic);
			cinematic = null;
			centerWorldOnCharacter();

			addChild(endButton);
			addChild(goldHud);
			addChild(runHud);

			tutorialManager.addTutorial(Assets.textures[Util.TUTORIAL_MOVE]);
			//addChild(tutorialManager); // Make sure it's on top of other UI elements.

			gameState = STATE_RUN;
		}

		private function onTutorialEndRun(event:TutorialEvent):void {
			// tutorialManager.addTutorial(Assets.textures[Util.TUTORIAL_END_RUN]);
		}

		private function onTutorialRevealEnemy(event:TutorialEvent):void {
			tutorialManager.addTutorial(Assets.textures[Util.TUTORIAL_ENEMY]);
		}

		private function onTutorialRevealTrap(event:TutorialEvent):void {
			tutorialManager.addTutorial(Assets.textures[Util.TUTORIAL_TRAP]);
		}

		private function sendToTop(event:GameEvent):void {
			if (event.gameData == null || event.gameData["visual"] == null) {
				return;
			}

			addChild(event.gameData["visual"]);
		}
	}
}
