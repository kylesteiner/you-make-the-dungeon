package {
	import flash.utils.Dictionary;

	import starling.display.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;

	import flash.utils.ByteArray;
	import flash.media.*;
	import flash.ui.Mouse;

	import mx.utils.StringUtil;

	import Character;
	import tiles.*;
	import TileHud;
	import CharHud;
	import Util;
	import Menu;
	import Logger;

	public class Game extends Sprite {

		public static const FLOOR_FAIL_TEXT:String = "Nea was defeated!\nClick here to continue building.";
		public static const LEVEL_UP_TEXT:String = "Nea levelled up!\nHealth fully restored!\n+{0} max health\n+{1} attack\nClick to dismiss";

		private static const STATE_MENU:String = "game_menu";
		private static const STATE_BUILD:String = "game_build";
		private static const STATE_RUN:String = "game_run";
		private static const STATE_COMBAT:String = "game_combat";
		private static const STATE_POPUP:String = "game_popup";

		private var cursorAnim:MovieClip;
		private var cursorHighlight:Image;
		private var bgmMuteButton:Clickable;
		private var sfxMuteButton:Clickable;
		//private var resetButton:Clickable;
		private var runButton:Clickable;
		private var endButton:Clickable;
		private var tileHud:TileHud;
		//private var charHud:CharHud;
		private var mixer:Mixer;
		private var textures:Dictionary;  // Map String -> Texture. See util.as.
		private var floors:Dictionary; // Map String -> [ByteArray, ByteArray]
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

		private var logger:Logger;
		private var numberOfTilesPlaced:int;
		private var emptyTiles:int;
		private var enemyTiles:int;
		private var healingTiles:int;

		private var currentCombat:CombatHUD;
		private var combatSkip:Boolean;
		private var runHud:RunHUD;
		private var goldHud:GoldHUD;

		private var currentTile:Tile;
		// for sanity
		private var currentText:TextField;
		private var currentTextImage:Image;

		private var gameState:String;
		private var gold:int;

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

			// for keeping track of how many tiles are placed before hitting reset
			numberOfTilesPlaced = 0;

			textures = Embed.setupTextures();
			floors = Embed.setupFloors();
			animations = Embed.setupAnimations();

			sfx = Embed.setupSFX();
			bgm = Embed.setupBGM();

			mixer = new Mixer(bgm, sfx);
			addChild(mixer);

			//var staticBg:Texture = Texture.fromBitmap(new static_background());
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
			addEventListener(TileEvent.COMBAT, startCombat);

			addEventListener(AnimationEvent.CHAR_DIED, onCombatFailure);
			addEventListener(AnimationEvent.ENEMY_DIED, onCombatSuccess);

			addEventListener(GameEvent.STAMINA_EXPENDED, onStaminaExpended);
		}

		private function initializeFloorWorld():void {
			world = new Sprite();
			//world.height = 2048;
			//world.width = 2048;
			//world.addChild(new Quad(world.height, world.width, 0xff000000));
			//world.addChild(new Image(Texture.fromBitmap(new grid_background())));

			goldHud = new GoldHUD(Util.STARTING_GOLD, textures);
			goldHud.x = Util.STAGE_WIDTH - goldHud.width;

			sfxMuteButton = new Clickable(Util.PIXELS_PER_TILE, Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE, toggleSFXMute, null, textures[Util.ICON_MUTE_SFX]);
			//sfxMuteButton.x += (Util.BORDER_PIXELS + Util.BUTTON_SPACING) * Util.PIXELS_PER_TILE;
			//sfxMuteButton.y = Util.STAGE_HEIGHT - sfxMuteButton.height - (Util.BORDER_PIXELS * Util.PIXELS_PER_TILE);
			sfxMuteButton.x = goldHud.x - sfxMuteButton.width - Util.UI_PADDING;
			sfxMuteButton.y = Util.BORDER_PIXELS * Util.PIXELS_PER_TILE;

			bgmMuteButton = new Clickable(0, 0, toggleBgmMute, null, textures[Util.ICON_MUTE_BGM]);
			//bgmMuteButton.x = Util.BORDER_PIXELS * Util.PIXELS_PER_TILE;
			//bgmMuteButton.y = Util.STAGE_HEIGHT - bgmMuteButton.height - (Util.BORDER_PIXELS * Util.PIXELS_PER_TILE);
			bgmMuteButton.x = sfxMuteButton.x - bgmMuteButton.width - Util.UI_PADDING;
			bgmMuteButton.y = sfxMuteButton.y;

			//resetButton = new Clickable(2 * Util.PIXELS_PER_TILE, Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE, resetFloor, null, textures[Util.ICON_RESET]);
			//resetButton.x = Util.STAGE_WIDTH - resetButton.width - textures[Util.CHAR_HUD].width - 2 * (Util.BORDER_PIXELS + Util.BUTTON_SPACING) * Util.PIXELS_PER_TILE;
			//resetButton.y = Util.STAGE_HEIGHT - resetButton.height - (Util.BORDER_PIXELS * Util.PIXELS_PER_TILE);

			runButton = new Clickable(3 *  Util.PIXELS_PER_TILE, Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE, runFloor, null, textures[Util.ICON_RUN]);
			//runButton.x = resetButton.x - runButton.width - 2 * (Util.BORDER_PIXELS + Util.BUTTON_SPACING) * Util.PIXELS_PER_TILE;
			runButton.x = sfxMuteButton.x;
			runButton.y = Util.STAGE_HEIGHT - runButton.height - (Util.BORDER_PIXELS * Util.PIXELS_PER_TILE);

			endButton = new Clickable(3 *  Util.PIXELS_PER_TILE, Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE, endRun, null, textures[Util.ICON_END]);
			//endButton.x = resetButton.x - endButton.width - 2 * (Util.BORDER_PIXELS + Util.BUTTON_SPACING) * Util.PIXELS_PER_TILE;
			endButton.x = runButton.x;
			endButton.y = Util.STAGE_HEIGHT - endButton.height - (Util.BORDER_PIXELS * Util.PIXELS_PER_TILE);

			runHud = new RunHUD(textures); // textures not needed for now but maybe in future

			cursorHighlight = new Image(textures[Util.TILE_HL_B]);
			cursorHighlight.touchable = false;
			world.addChild(cursorHighlight);
		}

		private function initializeMenuWorld():void {
			menuWorld = new Sprite();
			menuWorld.addChild(new Image(textures[Util.GRID_BACKGROUND]));
		}

		private function startCombat(event:TileEvent):void {
			currentCombat = new CombatHUD(textures, animations, currentFloor.char, currentFloor.grid[event.grid_x][event.grid_y], combatSkip, mixer, logger);
			addChild(currentCombat);
		}

		private function onCombatSuccess(event:AnimationEvent):void {
			removeChild(currentCombat);
			currentFloor.onCombatSuccess(event.enemy);
		}

		private function fireTileHandled():void {
			removeChild(messageToPlayer);
			currentFloor.onCharHandled(new TileEvent(TileEvent.CHAR_HANDLED,
										Util.real_to_grid(currentFloor.x),
										Util.real_to_grid(currentFloor.y)));
		}

		private function onCombatFailure(event:AnimationEvent):void {
			//mixer.play(Util.COMBAT_FAILURE);
			removeChild(currentCombat);
			// event.enemy.state.hp = event.enemy.state.maxHp;
			// Prompt clickable into either floor reset or continue modifying floor
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
				removeChild(tileHud);
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

		public function switchToTransition(newTransitionData:Array):void {
			prepareSwap();

			isMenu = false;
			currentTransition = new Clickable(0, 0, newTransitionData[0] == null ? switchToFloor : newTransitionData[0], null, newTransitionData[1]);

			var i:int;
			for(i = 2; i < newTransitionData.length; i++) {
				currentTransition.addParameter(newTransitionData[i]);
			}

			addChild(currentTransition);
		}

		public function switchToFloor(newFloorData:Array):void {
			prepareSwap();

			isMenu = false;

			var nextFloorData:Array = new Array();
			currentFloor = new Floor(newFloorData[0],	// Floor data file
									 textures,
									 animations,
									 newFloorData[1],	// Initial health
									 newFloorData[2],	// Initial stamina
									 newFloorData[3],	// Initial line of sight
									 floors,
									 switchToTransition,
									 mixer,
									 logger);
			if(currentFloor.floorName == Util.FLOOR_8) {
				currentFloor.altCallback = transitionToStart;
			}

			//world.height = Util.grid_to_real(currentFloor.gridHeight);
			//world.width = Util.grid_to_real(currentFloor.gridWidth);

			// TODO: Logger is definitely broken here by the changes.
			// the logger doesn't like 0 based indexing.
/*<<<<<<< HEAD
			logger.logLevelStart(1, { "characterLevel":currentFloor.char.state.level } );
=======
			logger.logLevelStart(parseInt(currentFloor.floorName.substring(5)) + 1, { } );
>>>>>>> backend*/

			world.addChild(currentFloor);
			world.addChild(cursorHighlight);
			//world.x = Util.STAGE_WIDTH / 4;

			/*var charWidth:int = currentFloor == null ? 0 : currentFloor.char == null ? 0 : currentFloor.char.width;
			var charX:int = currentFloor == null ? 0 : currentFloor.char == null ? 0 : currentFloor.char.x;
			world.x = Util.STAGE_WIDTH / 2 - Util.grid_to_real(Util.real_to_grid(charX));

			var charHeight:int = currentFloor == null ? 0 : currentFloor.char == null ? 0 : currentFloor.char.height;
			var charY:int = currentFloor == null ? 0 : currentFloor.char == null ? 0 : currentFloor.char.y;
			world.y = Util.STAGE_HEIGHT / 2 - Util.grid_to_real(Util.real_to_grid(charY)) - (Util.PIXELS_PER_TILE * 3.0 / 4);*/
			centerWorldOnCharacter();
			//currentFloor.shiftTutorialX(-1 *(Util.STAGE_WIDTH / 4));
			//currentFloor.shiftTutorialY(-1 *(Util.STAGE_HEIGHT / 4));
			addChild(world);
			// mute button should always be on top
			addChild(bgmMuteButton);
			addChild(sfxMuteButton);
			//addChild(resetButton);
			addChild(runButton);
			addChild(goldHud);
			//charHud = new CharHud(currentFloor.char, textures);
			//addChild(charHud);
			tileHud = new TileHud(floors[Util.FLOOR_8][Util.DICT_TILES_INDEX], textures);
			addChild(tileHud);

			mixer.play(Util.FLOOR_BEGIN);
		}

		public function transitionToStart(a:Array):void {
			createMainMenu();
		}

		public function createMainMenu():void {
			var titleField:TextField = new TextField(512, 80, "You Make The Dungeon", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			titleField.x = (Util.STAGE_WIDTH / 2) - (titleField.width / 2);
			titleField.y = 32 + titleField.height / 2;

			var startButton:Clickable = new Clickable(256, 192, createFloorSelect, new TextField(128, 40, "START", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));

			floors = Embed.setupFloors();

			var beginGameButton:Clickable = new Clickable(256, 192, switchToTransition, new TextField(128, 40, "START", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			beginGameButton.addParameter(switchToFloor);
			beginGameButton.addParameter(floors[Util.FLOOR_1][Util.DICT_TRANSITION_INDEX]);
			beginGameButton.addParameter(floors[Util.MAIN_FLOOR]);
			//beginGameButton.addParameter(floors[Util.FLOOR_1][Util.DICT_FLOOR_INDEX]);
			//beginGameButton.addParameter(floors[Util.FLOOR_1][Util.DICT_TILES_INDEX]);
			beginGameButton.addParameter(Util.STARTING_HEALTH);
			beginGameButton.addParameter(Util.STARTING_STAMINA);
			beginGameButton.addParameter(Util.STARTING_LOS);
			//beginGameButton.addParameter(1);

			var creditsButton:Clickable = new Clickable(256, 256, createCredits, new TextField(128, 40, "CREDITS", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			switchToMenu(new Menu(new Array(titleField, beginGameButton, creditsButton)));
		}

		public function createFloorSelect():void {
			// TODO: eliminate or relegate to debug code
			var floor1Button:Clickable = new Clickable(256, 192, switchToTransition, new TextField(128, 40, "Floor 1", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			floor1Button.addParameter(switchToFloor);
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_TRANSITION_INDEX]);
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_FLOOR_INDEX]);
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_TILES_INDEX]);
			floor1Button.addParameter(Util.STARTING_LEVEL);  // Char level
			floor1Button.addParameter(Util.STARTING_XP);  // Char xp
			floor1Button.addParameter(1); // Tutorial to display

			var floor5button:Clickable = new Clickable(256, 256, switchToTransition, new TextField(128, 40, "Floor 5", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			floor5button.addParameter(switchToFloor);
			floor5button.addParameter(floors[Util.FLOOR_5][Util.DICT_TRANSITION_INDEX]);
			floor5button.addParameter(floors[Util.FLOOR_5][Util.DICT_FLOOR_INDEX]);
			floor5button.addParameter(floors[Util.FLOOR_5][Util.DICT_TILES_INDEX]);
			floor5button.addParameter(1);  // Char level
			floor5button.addParameter(1);  // Char xp
			floor5button.addParameter(0); // Tutorial to display

			var floor8button:Clickable = new Clickable(256, 320, switchToTransition, new TextField(128, 40, "Floor 8", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			floor8button.addParameter(switchToFloor);
			floor8button.addParameter(floors[Util.FLOOR_8][Util.DICT_TRANSITION_INDEX]);
			floor8button.addParameter(floors[Util.FLOOR_8][Util.DICT_FLOOR_INDEX]);
			floor8button.addParameter(floors[Util.FLOOR_8][Util.DICT_TILES_INDEX]);
			floor8button.addParameter(3);  // Char level
			floor8button.addParameter(0);  // Char xp
			floor8button.addParameter(3); // Tutorial to display

			switchToMenu(new Menu(new Array(floor1Button, floor5button, floor8button)));
		}

		public function createCredits():void {
			var startButton:Clickable = new Clickable(256, 192, createMainMenu, new TextField(128, 40, "BACK", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			var creditsLine:TextField = new TextField(256, 256, "THANKS", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			switchToMenu(new Menu(new Array(startButton)));
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
			tileHud.resetTileHud();
			//charHud.char = currentFloor.char
			mixer.play(Util.FLOOR_RESET);
		}

		public function runFloor():void {
			//logger.logAction(3, { "numberOfTiles":numberOfTilesPlaced, "AvaliableTileSpots":(currentFloor.gridHeight * currentFloor.gridWidth - currentFloor.preplacedTiles),
			//					   "EmptyTilesPlaced":emptyTiles, "MonsterTilesPlaced":enemyTiles, "HealthTilesPlaced":healingTiles} );
			removeChild(runButton);
			addChild(endButton);
			addChild(runHud);
			//currentFloor.removeTutorial();
			//currentFloor.runFloor();
			gameState = STATE_RUN;
			currentFloor.toggleRun();
		}

		public function onStaminaExpended(event:GameEvent):void {
			endRun();
		}

		public function endRun():void {
			//TODO: I AM A STUB
			// 		call at end of run automatically when stamina <= 0
			//		reset char, bring up new display which triggers phase change afterwards
			//		add gold and other items
			removeChild(endButton);
			removeChild(runHud);
			addChild(runButton);
			gameState = STATE_BUILD;
			currentFloor.toggleRun();
			currentFloor.resetFloor();

			centerWorldOnCharacter();
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


			/*if(currentFloor && currentFloor.tutorialImage && touch.phase == TouchPhase.BEGAN && currentFloor.floorName == Util.TUTORIAL_TILE_FLOOR) {
				currentFloor.removeTutorial();
			}*/

			var xOffset:int = touch.globalX < world.x ? Util.PIXELS_PER_TILE : 0;
			var yOffset:int = touch.globalY < world.y ? Util.PIXELS_PER_TILE : 0;
			cursorHighlight.x = Util.grid_to_real(Util.real_to_grid(touch.globalX - world.x - xOffset));
			cursorHighlight.y = Util.grid_to_real(Util.real_to_grid(touch.globalY - world.y - yOffset));

			// TODO: make it so cursorAnim can move outside of the world
			cursorAnim.x = touch.globalX + Util.CURSOR_OFFSET_X;
			cursorAnim.y = touch.globalY + Util.CURSOR_OFFSET_Y;

			if (tileHud) {
				var selectedTileIndex:int = tileHud.indexOfSelectedTile();
				if (selectedTileIndex == -1) {
					// There is no selected tile
					if (currentFloor && !currentFloor.completed) {
						var tempX:int = touch.globalX - world.x;
						var tempY:int = touch.globalY - world.y;
						if (tempX > 0 && tempX < currentFloor.gridWidth * Util.PIXELS_PER_TILE
						    && tempY > 0 && tempY < currentFloor.gridHeight * Util.PIXELS_PER_TILE) {
							var temp:Tile = currentFloor.grid[Util.real_to_grid(tempX)][Util.real_to_grid(tempY)];
							if (currentTile != temp) {
								if (currentTile)
									currentTile.removeInfo();
								currentTile = temp;
								if (currentTile) {
									currentText = currentTile.text;
									currentTextImage = currentTile.textImage;
								}
								if (currentTile && !currentFloor.fogGrid[Util.real_to_grid(tempX)][Util.real_to_grid(tempY)]) {
									currentTile.updateInfoPosition();
								}
							}
						} else if (currentTile) {
							currentTile.removeInfo();
							currentTile = null;
						}
					}
					return;
				}

				if(currentFloor && currentFloor.tutorialImage != null && currentFloor.floorName == Util.TUTORIAL_TILE_FLOOR) {
					currentFloor.removeTutorial();
				}

				// A tile is selected. Adjust its position to follow the cursor and allow player to place it.
				var selectedTile:Tile = tileHud.getTileByIndex(selectedTileIndex);
				tileHud.lockTiles();
				selectedTile.moveToTouch(touch, world.x, world.y, cursorAnim);
				currentFloor.highlightAllowedLocations(selectedTile);
				if (touch.phase == TouchPhase.ENDED) {
					if (touch.globalX < tileHud.HUD.x || touch.globalX > tileHud.HUD.x + tileHud.width ||
						touch.globalY < tileHud.HUD.y || touch.globalY > tileHud.HUD.y + tileHud.HUD.height) {
						// Player clicked outside the tile HUD bounds
						if (touch.globalX >= world.x && touch.globalX < world.x + currentFloor.width &&
							touch.globalY >= world.y && touch.globalY < world.y + currentFloor.height) {
							// Player clicked inside grid
							if (selectedTile.grid_x >= 0 && selectedTile.grid_x < currentFloor.gridWidth &&
								selectedTile.grid_y >= 0 && selectedTile.grid_y < currentFloor.gridHeight &&
								!currentFloor.grid[selectedTile.grid_x][selectedTile.grid_y] &&
								currentFloor.highlightedLocations[selectedTile.grid_x][selectedTile.grid_y]) {
								// Player correctly placed one of the available tiles
								// Move tile from HUD to grid. Add new tile to HUD.
								tileHud.removeAndReplaceTile(selectedTileIndex);
								currentFloor.grid[selectedTile.grid_x][selectedTile.grid_y] = selectedTile;
								currentFloor.addChild(selectedTile);
								currentFloor.fogGrid[selectedTile.grid_x][selectedTile.grid_y] = false;
								currentFloor.removeFoggedLocations(selectedTile.grid_x, selectedTile.grid_y);
								// check if we placed the tile next to any preplaced tiles, and if we did, remove
								// the fogs for those as well. (it's so ugly D:)
								if (selectedTile.grid_x + 1 < currentFloor.grid.length && currentFloor.grid[selectedTile.grid_x + 1][selectedTile.grid_y]) {
									currentFloor.removeFoggedLocations(selectedTile.grid_x + 1, selectedTile.grid_y);
								}
								if (selectedTile.grid_x - 1 >= 0 && currentFloor.grid[selectedTile.grid_x - 1][selectedTile.grid_y]) {
									currentFloor.removeFoggedLocations(selectedTile.grid_x - 1, selectedTile.grid_y);
								}
								if (selectedTile.grid_y + 1 < currentFloor.grid[selectedTile.grid_x].length && currentFloor.grid[selectedTile.grid_x][selectedTile.grid_y + 1]) {
									currentFloor.removeFoggedLocations(selectedTile.grid_x, selectedTile.grid_y + 1);
								}
								if (selectedTile.grid_y - 1 >= 0 && currentFloor.grid[selectedTile.grid_x][selectedTile.grid_y - 1]) {
									currentFloor.removeFoggedLocations(selectedTile.grid_x, selectedTile.grid_y - 1);
								}
								selectedTile.positionTileOnGrid(world.x, world.y);
								numberOfTilesPlaced++;
								selectedTile.onGrid = true;

								mixer.play(Util.TILE_MOVE);

								if (selectedTile is Tile) {
									emptyTiles++;
								}

								tileHud.unlockTiles();
								currentFloor.clearHighlightedLocations();
							} else {
								// Tile wasn't placed correctly on grid
								mixer.play(Util.TILE_FAILURE);
								tileHud.returnSelectedTile();
								tileHud.unlockTiles();
								currentFloor.clearHighlightedLocations();
							}
						} else {
							// Player clicked outside grid
							mixer.play(Util.TILE_FAILURE);
							tileHud.returnSelectedTile();
							tileHud.unlockTiles();
							currentFloor.clearHighlightedLocations();
						}
					} else {
						// Player clicked inside tile HUD
						mixer.play(Util.TILE_FAILURE);
						tileHud.returnSelectedTile();
						tileHud.unlockTiles();
						currentFloor.clearHighlightedLocations();
					}
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
				}

				if (input == Util.UP_KEY) {
					world.y += Util.grid_to_real(Util.CAMERA_SHIFT);
					if (world.y > Util.PIXELS_PER_TILE * -1 + Util.STAGE_HEIGHT) {
						currentFloor.shiftTutorialY(-1 * Util.grid_to_real(Util.CAMERA_SHIFT) + world.y - Util.STAGE_HEIGHT + Util.PIXELS_PER_TILE);
						world.y = Util.PIXELS_PER_TILE * -1 + Util.STAGE_HEIGHT
					} else {
						currentFloor.shiftTutorialY( -1 * Util.grid_to_real(Util.CAMERA_SHIFT));
					}
				}

				if (input == Util.RIGHT_KEY) {
					world.x -= Util.grid_to_real(Util.CAMERA_SHIFT);
					if (world.x < -1 * Util.PIXELS_PER_TILE * (currentFloor.gridWidth - 1)) {
						currentFloor.shiftTutorialX(Util.PIXELS_PER_TILE * (currentFloor.gridWidth -1 ) + world.x + Util.grid_to_real(Util.CAMERA_SHIFT));
						world.x = -1 * Util.PIXELS_PER_TILE * (currentFloor.gridWidth - 1);
					} else {
						currentFloor.shiftTutorialX(Util.grid_to_real(Util.CAMERA_SHIFT));
					}
				}

				if (input == Util.LEFT_KEY) {
					world.x += Util.grid_to_real(Util.CAMERA_SHIFT);
					if (world.x > Util.PIXELS_PER_TILE * -1 + Util.STAGE_WIDTH) {
						currentFloor.shiftTutorialX(-1 * Util.grid_to_real(Util.CAMERA_SHIFT) + world.x - Util.STAGE_WIDTH + Util.PIXELS_PER_TILE);
						world.x = Util.PIXELS_PER_TILE * -1 + Util.STAGE_WIDTH
					} else {
						currentFloor.shiftTutorialX( -1 * Util.grid_to_real(Util.CAMERA_SHIFT));
					}
				}
				if (currentTile) {
					currentTile.updateInfoPosition();
					currentTile.removeInfo();
				}
			}
		}
	}
}
