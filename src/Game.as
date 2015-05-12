package {
	import flash.utils.Dictionary;

	import starling.display.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;

	import flash.utils.ByteArray;
	import flash.media.*;
	import flash.ui.Mouse;

	import Character;
	import tiles.*;
	import TileHud;
	import CharHud;
	import Util;
	import Menu;
	//import cgs.logger.Logger;
	import Logger;
	import ai.*;

	public class Game extends Sprite {
		[Embed(source='assets/backgrounds/background.png')] private var grid_background:Class;
		[Embed(source='assets/backgrounds/char_hud.png')] private static const char_hud:Class;
		[Embed(source='assets/backgrounds/static_bg.png')] private var static_background:Class; //Credit to STU_WilliamHewitt for placeholder
		[Embed(source='assets/backgrounds/tile_hud_large.png')] private static const tile_hud:Class;
		[Embed(source='assets/backgrounds/tutorial.png')] private static const tutorial_hud:Class;

		[Embed(source='assets/effects/large/fog.png')] private static var fog:Class;
		[Embed(source='assets/effects/large/hl_blue.png')] private static var hl_blue:Class;
		[Embed(source='assets/effects/large/hl_green.png')] private static var hl_green:Class;
		[Embed(source='assets/effects/large/hl_red.png')] private static var hl_red:Class;
		[Embed(source='assets/effects/large/hl_yellow.png')] private static var hl_yellow:Class;

		[Embed(source='assets/entities/large/door.png')] private static var entity_door:Class;
		[Embed(source='assets/entities/large/healing.png')] private static var entity_healing:Class;
		[Embed(source='assets/entities/large/hero.png')] private static var entity_hero:Class;
		[Embed(source='assets/entities/large/key.png')] private static var entity_key:Class;
		[Embed(source='assets/entities/large/monster_1.png')] private static var entity_mon1:Class;

		[Embed(source='assets/fonts/BebasNeueRegular.otf', embedAsCFF="false", fontFamily="Bebas")] private static const bebas_font:Class;
		[Embed(source='assets/fonts/LeagueGothicRegular.otf', embedAsCFF="false", fontFamily="League")] private static const league_font:Class;

		[Embed(source='assets/icons/cursor.png')] private static const icon_cursor:Class;

		[Embed(source='assets/icons/medium/mute_bgm.png')] private static const icon_mute_bgm:Class;
		[Embed(source='assets/icons/medium/mute_sfx.png')] private static const icon_mute_sfx:Class;
		[Embed(source='assets/icons/medium/reset.png')] private static const icon_reset:Class;
		[Embed(source='assets/icons/medium/run.png')] private static const icon_run:Class;
		[Embed(source='assets/tiles/large/tile_e.png')] private static var tile_e:Class;
		[Embed(source='assets/tiles/large/tile_ew.png')] private static var tile_ew:Class;
		[Embed(source='assets/tiles/large/tile_n.png')] private static var tile_n:Class;
		[Embed(source='assets/tiles/large/tile_ne.png')] private static var tile_ne:Class;
		[Embed(source='assets/tiles/large/tile_new.png')] private static var tile_new:Class;
		[Embed(source='assets/tiles/large/tile_none.png')] private static var tile_none:Class;
		[Embed(source='assets/tiles/large/tile_ns.png')] private static var tile_ns:Class;
		[Embed(source='assets/tiles/large/tile_nse.png')] private static var tile_nse:Class;
		[Embed(source='assets/tiles/large/tile_nsew.png')] private static var tile_nsew:Class;
		[Embed(source='assets/tiles/large/tile_nsw.png')] private static var tile_nsw:Class;
		[Embed(source='assets/tiles/large/tile_nw.png')] private static var tile_nw:Class;
		[Embed(source='assets/tiles/large/tile_s.png')] private static var tile_s:Class;
		[Embed(source='assets/tiles/large/tile_se.png')] private static var tile_se:Class;
		[Embed(source='assets/tiles/large/tile_sew.png')] private static var tile_sew:Class;
		[Embed(source='assets/tiles/large/tile_sw.png')] private static var tile_sw:Class;
		[Embed(source='assets/tiles/large/tile_w.png')] private static var tile_w:Class;

		[Embed(source='floordata/floor0.txt', mimeType="application/octet-stream")] public static const floor0:Class;
		[Embed(source='floordata/floor1.txt', mimeType="application/octet-stream")] public static const floor1:Class;
		[Embed(source='floordata/floor2.txt', mimeType="application/octet-stream")] public static const floor2:Class;
		[Embed(source='floordata/floor3.txt', mimeType="application/octet-stream")] public static const floor3:Class;
		[Embed(source='floordata/floor4.txt', mimeType="application/octet-stream")] public static const floor4:Class;
		[Embed(source='floordata/floor5.txt', mimeType="application/octet-stream")] public static const floor5:Class;
		[Embed(source='floordata/floor6.txt', mimeType="application/octet-stream")] public static const floor6:Class;
		[Embed(source='floordata/floor7.txt', mimeType="application/octet-stream")] public static const floor7:Class;
		[Embed(source='floordata/floor8.txt', mimeType="application/octet-stream")] public static const floor8:Class;
		[Embed(source='floordata/floor9.txt', mimeType="application/octet-stream")] public static const floor9:Class;
		[Embed(source='floordata/floor10.txt', mimeType="application/octet-stream")] public static const floor10:Class;
		[Embed(source='floordata/floor11.txt', mimeType="application/octet-stream")] public static const floor11:Class;
		[Embed(source='tilerates/floor0.txt', mimeType="application/octet-stream")] public static const tiles0:Class;
		[Embed(source='tilerates/floor1.txt', mimeType="application/octet-stream")] public static const tiles1:Class;
		[Embed(source='tilerates/floor2.txt', mimeType="application/octet-stream")] public static const tiles2:Class;
		[Embed(source='tilerates/floor3.txt', mimeType="application/octet-stream")] public static const tiles3:Class;
		[Embed(source='tilerates/floor4.txt', mimeType="application/octet-stream")] public static const tiles4:Class;
		[Embed(source='tilerates/floor5.txt', mimeType="application/octet-stream")] public static const tiles5:Class;
		[Embed(source='tilerates/floor6.txt', mimeType="application/octet-stream")] public static const tiles6:Class;
		[Embed(source='tilerates/floor7.txt', mimeType="application/octet-stream")] public static const tiles7:Class;
		[Embed(source='tilerates/floor8.txt', mimeType="application/octet-stream")] public static const tiles8:Class;
		[Embed(source='tilerates/floor9.txt', mimeType="application/octet-stream")] public static const tiles9:Class;
		[Embed(source='tilerates/floor10.txt', mimeType="application/octet-stream")] public static const tiles10:Class;
		[Embed(source='tilerates/floor11.txt', mimeType="application/octet-stream")] public static const tiles11:Class;
		[Embed(source='assets/transitions/floor0.png')] private static const transitions0:Class;

		[Embed(source='assets/animations/character/idle/character_0.png')] private static const characterIdleAnim0:Class;
		[Embed(source='assets/animations/character/idle/character_1.png')] private static const characterIdleAnim1:Class;
		[Embed(source='assets/animations/character/idle/character_2.png')] private static const characterIdleAnim2:Class;
		[Embed(source='assets/animations/character/idle/character_3.png')] private static const characterIdleAnim3:Class;

		[Embed(source='assets/backgrounds/combat_background.png')] private static const combatBackground:Class;
		[Embed(source='assets/backgrounds/combat_shadow.png')] private static const combatShadow:Class;

		[Embed(source='assets/animations/character/combat_idle/char_ci_0.png')] private static const charCombatIdleAnim0:Class;
		[Embed(source='assets/animations/character/combat_idle/char_ci_1.png')] private static const charCombatIdleAnim1:Class;
		[Embed(source='assets/animations/character/combat_idle/char_ci_2.png')] private static const charCombatIdleAnim2:Class;

		[Embed(source='assets/animations/character/combat_attack/char_ca_0.png')] private static const charCombatAtkAnim0:Class;
		[Embed(source='assets/animations/character/combat_attack/char_ca_1.png')] private static const charCombatAtkAnim1:Class;
		[Embed(source='assets/animations/character/combat_attack/char_ca_2.png')] private static const charCombatAtkAnim2:Class;
		[Embed(source='assets/animations/character/combat_attack/char_ca_3.png')] private static const charCombatAtkAnim3:Class;

		[Embed(source='assets/animations/character/combat_faint/char_cf_0.png')] private static const charCombatFaintAnim0:Class;
		[Embed(source='assets/animations/character/combat_faint/char_cf_1.png')] private static const charCombatFaintAnim1:Class;

		[Embed(source='assets/sfx/floor_complete.mp3')] private static const sfxFloorComplete:Class;
		[Embed(source='assets/sfx/tile_move.mp3')] private static const sfxTileMove:Class;
		[Embed(source='assets/sfx/floor_begin.mp3')] private static const sfxFloorBegin:Class;
		[Embed(source='assets/sfx/button_press.mp3')] private static const sfxButtonPress:Class;
		[Embed(source='assets/sfx/floor_reset.mp3')] private static const sfxFloorReset:Class;

		[Embed(source='assets/bgm/diving-turtle.mp3')] private static const bgmDivingTurtle:Class;
		[Embed(source='assets/bgm/gentle-thoughts-2.mp3')] private static const bgmGentleThoughts:Class;
		[Embed(source='assets/bgm/glow-in-the-dark.mp3')] private static const bgmGlowInTheDark:Class;
		[Embed(source='assets/bgm/lovers-walk.mp3')] private static const bgmLoversWalk:Class;
		[Embed(source='assets/bgm/oriental-drift.mp3')] private static const bgmOrientalDrift:Class;

		// Currently unused
		[Embed(source='assets/bgm/warm-interlude.mp3')] private static const bgmWarmInterlude:Class;

		private var cursorImage:Image;
		private var cursorHighlight:Image;
		private var bgmMuteButton:Clickable;
		private var sfxMuteButton:Clickable;
		private var resetButton:Clickable;
		private var runButton:Clickable;
		private var tileHud:TileHud;
		private var charHud:CharHud;
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

		private var logger:Logger;
		private var numberOfTilesPlaced:int;
		private var emptyTiles:int;
		private var enemyTiles:int;
		private var healingTiles:int;

		private var currentCombat:CombatHUD;

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

			textures = setupTextures();
			floors = setupFloors();
			animations = setupAnimations();

			sfx = setupSFX();
			bgm = setupBGM();

			mixer = new Mixer(bgm, sfx);
			addChild(mixer);

			var staticBg:Texture = Texture.fromBitmap(new static_background());
			staticBackgroundImage = new Image(staticBg);
			addChild(staticBackgroundImage);

			initializeFloorWorld();
			initializeMenuWorld();

			cursorImage = new Image(textures[Util.ICON_CURSOR]);
			cursorImage.touchable = false;
			addChild(cursorImage);

			isMenu = false;
			createMainMenu();

			// Make sure the cursor stays on the top level of the drawtree.
			addEventListener(EnterFrameEvent.ENTER_FRAME, onFrameBegin);

			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
			addEventListener(TileEvent.COMBAT, startCombat);

			addEventListener(AnimationEvent.CHAR_DIED, onCombatFailure);
			addEventListener(AnimationEvent.ENEMY_DIED, onCombatSuccess);
		}

		private function initializeFloorWorld():void {
			world = new Sprite();
			world.addChild(new Image(Texture.fromBitmap(new grid_background())));

			bgmMuteButton = new Clickable(0, Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE, toggleBgmMute, null, textures[Util.ICON_MUTE_BGM]);
			sfxMuteButton = new Clickable(Util.PIXELS_PER_TILE, Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE, toggleSFXMute, null, textures[Util.ICON_MUTE_SFX]);
			resetButton = new Clickable(2 * Util.PIXELS_PER_TILE, Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE, resetFloor, null, textures[Util.ICON_RESET]);
			runButton = new Clickable(3 *  Util.PIXELS_PER_TILE, Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE, runFloor, null, textures[Util.ICON_RUN]);


			cursorHighlight = new Image(textures[Util.TILE_HL_B]);
			cursorHighlight.touchable = false;
			world.addChild(cursorHighlight);
		}

		private function initializeMenuWorld():void {
			menuWorld = new Sprite();
			menuWorld.addChild(new Image(Texture.fromBitmap(new grid_background())));
		}

		private function startCombat(event:TileEvent):void {
			currentCombat = new CombatHUD(textures, animations, currentFloor.char, currentFloor.grid[event.grid_x][event.grid_y], logger);
			addChild(currentCombat);
		}

		private function onCombatSuccess(event:AnimationEvent):void {
			removeChild(currentCombat);
			event.enemy.removeImage();

			var tLevel:int = event.character.state.level;

			event.character.state.xp += event.enemy.state.xpReward;
			event.character.state.tryLevelUp();

			if(event.character.state.level != tLevel) {
				// Play any relevant level-up code / sounds / events here
				logger.logAction(10, {"previousLevel":tLevel, "newLevel":event.character.state.level});
			}

			currentFloor.onCharHandled(new TileEvent(TileEvent.CHAR_HANDLED,
										Util.real_to_grid(currentFloor.x),
										Util.real_to_grid(currentFloor.y)));
		}

		private function onCombatFailure(event:AnimationEvent):void {
			removeChild(currentCombat);
			// Prompt clickable into either floor reset or continue modifying floor
			logger.logAction(4, { "characterLevel":event.character.state.level, "characterAttack":event.character.state.attack, "enemyName":event.enemy.enemyName,
								"enemyLevel":event.enemy.level, "enemyAttack":event.enemy.state.attack, "enemyHealthLeft":event.enemy.state.hp, "initialEnemyHealth":event.enemy.initialHp} );
		}

		private function prepareSwap():void {
			if(isMenu) {
				removeChild(menuWorld);
				removeChild(currentMenu);
			} else {
				world.removeChild(currentFloor);
				removeChild(world);
				// mute button should always be present
				// removeChild(muteButton);
				removeChild(currentTransition);
				removeChild(resetButton);
				removeChild(runButton);
				removeChild(charHud);
				removeChild(tileHud);
			}
		}

		public function switchToMenu(newMenu:Menu):void {
			prepareSwap();

			isMenu = true;
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
			// TODO: find out how to pass in xp
			//currentFloor = new Floor(newFloorData[0], textures, newFloorData[2], logger);
			var nextFloorData:Array = new Array();
			currentFloor = new Floor(newFloorData[0], textures, animations, newFloorData[2], newFloorData[3], floors, switchToTransition, mixer, logger, newFloorData[4]);

			// the logger doesn't like 0 based indexing.
			logger.logLevelStart(parseInt(currentFloor.floorName.substring(5)) + 1, { "characterLevel":currentFloor.char.state.level } );

			world.addChild(currentFloor);
			world.addChild(cursorHighlight);
			addChild(world);
			// mute button should always be on top
			addChild(bgmMuteButton);
			addChild(sfxMuteButton);
			addChild(resetButton);
			addChild(runButton);
			charHud = new CharHud(currentFloor.char, textures);
			addChild(charHud);
			tileHud = new TileHud(newFloorData[1], textures); // TODO: Allow multiple levels
			addChild(tileHud);
		}

		public function createMainMenu():void {
			var startButton:Clickable = new Clickable(256, 192, createFloorSelect, new TextField(128, 40, "START", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			var creditsButton:Clickable = new Clickable(256, 256, createCredits, new TextField(128, 40, "CREDITS", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			switchToMenu(new Menu(new Array(startButton, creditsButton)));
		}

		public function createFloorSelect():void {
			var floor1Button:Clickable = new Clickable(256, 192, switchToTransition, new TextField(128, 40, "Floor 1", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			floor1Button.addParameter(switchToFloor);
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_TRANSITION_INDEX]);
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_FLOOR_INDEX]);
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_TILES_INDEX]);
			floor1Button.addParameter(Util.STARTING_LEVEL);  // Char level
			floor1Button.addParameter(Util.STARTING_XP);  // Char xp
			floor1Button.addParameter(true);

			var floor5button:Clickable = new Clickable(256, 256, switchToTransition, new TextField(128, 40, "Floor 5", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			floor5button.addParameter(switchToFloor);
			floor5button.addParameter(floors[Util.FLOOR_5][Util.DICT_TRANSITION_INDEX]);
			floor5button.addParameter(floors[Util.FLOOR_5][Util.DICT_FLOOR_INDEX]);
			floor5button.addParameter(floors[Util.FLOOR_5][Util.DICT_TILES_INDEX]);
			floor5button.addParameter(1);  // Char level
			floor5button.addParameter(0);  // Char xp
			floor5button.addParameter(false);

			var floor8button:Clickable = new Clickable(256, 320, switchToTransition, new TextField(128, 40, "Floor 8", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			floor8button.addParameter(switchToFloor);
			floor8button.addParameter(floors[Util.FLOOR_8][Util.DICT_TRANSITION_INDEX]);
			floor8button.addParameter(floors[Util.FLOOR_8][Util.DICT_FLOOR_INDEX]);
			floor8button.addParameter(floors[Util.FLOOR_8][Util.DICT_TILES_INDEX]);
			floor8button.addParameter(3);  // Char level
			floor8button.addParameter(0);  // Char xp
			floor8button.addParameter(false);

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
			logger.logAction(8, { "numberOfTiles":numberOfTilesPlaced, "AvaliableTileSpots":(currentFloor.gridHeight * currentFloor.gridWidth - currentFloor.preplacedTiles),
						     "EmptyTilesPlaced":emptyTiles, "MonsterTilesPlaced":enemyTiles, "HealthTilesPlaced":healingTiles} );
			//reset counters
			numberOfTilesPlaced = 0;
			emptyTiles = 0;
			enemyTiles = 0;
			healingTiles = 0;
			currentFloor.resetFloor();
			tileHud.resetTileHud();
			charHud.char = currentFloor.char
		}

		public function runFloor():void {
			logger.logAction(3, { "numberOfTiles":numberOfTilesPlaced, "AvaliableTileSpots":(currentFloor.gridHeight * currentFloor.gridWidth - currentFloor.preplacedTiles),
								   "EmptyTilesPlaced":emptyTiles, "MonsterTilesPlaced":enemyTiles, "HealthTilesPlaced":healingTiles} );

			currentFloor.removeTutorial();
			currentFloor.runFloor();
		}

		private function onFrameBegin(event:EnterFrameEvent):void {
			removeChild(cursorImage);
			addChild(cursorImage);
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

			// TODO: make it so cursorImage can move outside of the world
			cursorImage.x = touch.globalX;
			cursorImage.y = touch.globalY;

			// Tile placement
			if (tileHud) {
				var selectedTileIndex:int = tileHud.indexOfSelectedTile();
				if (selectedTileIndex == -1) {
					return;
				}
				var selectedTile:Tile = tileHud.getTileByIndex(selectedTileIndex);
				tileHud.lockTiles();
				selectedTile.moveToTouch(touch, world.x, world.y);
				currentFloor.highlightAllowedLocations(selectedTile);
				// Trigger tile placement if they click outside the tile HUD
				if (touch.phase == TouchPhase.ENDED && (touch.globalX < tileHud.HUD.x || touch.globalX > tileHud.HUD.x + tileHud.width ||
					touch.globalY < tileHud.HUD.y || touch.globalY > tileHud.HUD.y + tileHud.HUD.height)) {
					trace(world.x, world.y, selectedTile.grid_x, selectedTile.grid_y);
					if (selectedTile.grid_x < currentFloor.gridWidth && selectedTile.grid_y < currentFloor.gridHeight &&
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
						if (selectedTile is Tile) {
							emptyTiles++;
						} else if (selectedTile is EnemyTile) {
							enemyTiles++;
						} else if (selectedTile is HealingTile) {
							healingTiles++;
						}
					} else {
						// Tile wasn't placed correctly. Return tile to HUD.
						tileHud.returnSelectedTile();
					}
					tileHud.unlockTiles();
					currentFloor.clearHighlightedLocations();
				}
			}
		}

		private function onKeyDown(event:KeyboardEvent):void {
			// TODO: set up dictionary of charCode -> callback?
			var input:String = String.fromCharCode(event.charCode);
			if(input == Util.MUTE_KEY) {
				mixer.togglePlay();
			}

			// TODO: add bounds that the camera cannot go beyond,
			//		 and limit what contexts the camera movement
			//		 can be used in.
			if(input == Util.UP_KEY) {
				world.y -= Util.grid_to_real(Util.CAMERA_SHIFT);
			}

			if(input == Util.DOWN_KEY) {
				world.y += Util.grid_to_real(Util.CAMERA_SHIFT);
			}

			if(input == Util.LEFT_KEY) {
				world.x -= Util.grid_to_real(Util.CAMERA_SHIFT);
			}

			if(input == Util.RIGHT_KEY) {
				world.x += Util.grid_to_real(Util.CAMERA_SHIFT);
			}
		}

		private function setupTextures():Dictionary {
			var textures:Dictionary = new Dictionary();
			var scale:int = Util.REAL_TILE_SIZE / Util.PIXELS_PER_TILE;
			textures[Util.GRID_BACKGROUND] = Texture.fromEmbeddedAsset(grid_background);
			textures[Util.STATIC_BACKGROUND] = Texture.fromEmbeddedAsset(static_background);
			textures[Util.TUTORIAL_BACKGROUND] = Texture.fromEmbeddedAsset(tutorial_hud);

			textures[Util.CHARACTER] = Texture.fromBitmap(new entity_hero(), true, false, scale);
			textures[Util.DOOR] = Texture.fromBitmap(new entity_door(), true, false, scale);
			textures[Util.HEALING] = Texture.fromBitmap(new entity_healing(), true, false, scale);
			textures[Util.KEY] = Texture.fromBitmap(new entity_key(), true, false, scale);
			textures[Util.MONSTER_1] = Texture.fromBitmap(new entity_mon1(), true, false, scale);

			textures[Util.TILE_E] = Texture.fromBitmap(new tile_e(), true, false, scale);
			textures[Util.TILE_EW] = Texture.fromBitmap(new tile_ew(), true, false, scale);
			textures[Util.TILE_N] = Texture.fromBitmap(new tile_n(), true, false, scale);
			textures[Util.TILE_NE] = Texture.fromBitmap(new tile_ne(), true, false, scale);
			textures[Util.TILE_NEW] = Texture.fromBitmap(new tile_new(), true, false, scale);
			textures[Util.TILE_NONE] = Texture.fromBitmap(new tile_none(), true, false, scale);
			textures[Util.TILE_NS] = Texture.fromBitmap(new tile_ns(), true, false, scale);
			textures[Util.TILE_NSE] = Texture.fromBitmap(new tile_nse(), true, false, scale);
			textures[Util.TILE_NSEW] = Texture.fromBitmap(new tile_nsew(), true, false, scale);
			textures[Util.TILE_NSW] = Texture.fromBitmap(new tile_nsw(), true, false, scale);
			textures[Util.TILE_NW] = Texture.fromBitmap(new tile_nw(), true, false, scale);
			textures[Util.TILE_S] = Texture.fromBitmap(new tile_s(), true, false, scale);
			textures[Util.TILE_SE] = Texture.fromBitmap(new tile_se(), true, false, scale);
			textures[Util.TILE_SEW] = Texture.fromBitmap(new tile_sew(), true, false, scale);
			textures[Util.TILE_SW] = Texture.fromBitmap(new tile_sw(), true, false, scale);
			textures[Util.TILE_W] = Texture.fromBitmap(new tile_w(), true, false, scale);

			textures[Util.TILE_FOG] = Texture.fromBitmap(new fog(), true, false, scale);
			textures[Util.TILE_HL_Y] = Texture.fromBitmap(new hl_yellow(), true, false, scale);
			textures[Util.TILE_HL_R] = Texture.fromBitmap(new hl_red(), true, false, scale);
			textures[Util.TILE_HL_G] = Texture.fromBitmap(new hl_green(), true, false, scale);
			textures[Util.TILE_HL_B] = Texture.fromBitmap(new hl_blue(), true, false, scale);

			// WARNING: ICONS ARE NOT SCALED LIKE THE TILES
			textures[Util.ICON_CURSOR] = Texture.fromBitmap(new icon_cursor(), true, false, 1);
			textures[Util.ICON_MUTE_BGM] =  Texture.fromBitmap(new icon_mute_bgm(), true, false, 1);
			textures[Util.ICON_MUTE_SFX] = Texture.fromBitmap(new icon_mute_sfx(), true, false, 1);
			textures[Util.ICON_RESET] = Texture.fromBitmap(new icon_reset(), true, false, 1);
			textures[Util.ICON_RUN] = Texture.fromBitmap(new icon_run(), true, false, 1);

			textures[Util.TILE_HUD] = Texture.fromEmbeddedAsset(tile_hud);
			textures[Util.CHAR_HUD] = Texture.fromEmbeddedAsset(char_hud);

			textures[Util.COMBAT_BG] = Texture.fromEmbeddedAsset(combatBackground);
			textures[Util.COMBAT_SHADOW] = Texture.fromEmbeddedAsset(combatShadow);
			return textures;
		}

		private function setupAnimations():Dictionary {
			var tAnimations:Dictionary = new Dictionary();

			var charDict:Dictionary = new Dictionary();
			var charVector:Vector.<Texture> = new Vector.<Texture>();
			charVector.push(Texture.fromEmbeddedAsset(characterIdleAnim0));
			charVector.push(Texture.fromEmbeddedAsset(characterIdleAnim1));
			charVector.push(Texture.fromEmbeddedAsset(characterIdleAnim2));
			charVector.push(Texture.fromEmbeddedAsset(characterIdleAnim3));
			charDict[Util.CHAR_IDLE] = charVector;

			var charCombatIdleVector:Vector.<Texture> = new Vector.<Texture>();
			charCombatIdleVector.push(Texture.fromEmbeddedAsset(charCombatIdleAnim0));
			charCombatIdleVector.push(Texture.fromEmbeddedAsset(charCombatIdleAnim1));
			charCombatIdleVector.push(Texture.fromEmbeddedAsset(charCombatIdleAnim2));
			charDict[Util.CHAR_COMBAT_IDLE] = charCombatIdleVector;

			var charCombatAttackVector:Vector.<Texture> = new Vector.<Texture>();
			charCombatAttackVector.push(Texture.fromEmbeddedAsset(charCombatAtkAnim0));
			charCombatAttackVector.push(Texture.fromEmbeddedAsset(charCombatAtkAnim1));
			charCombatAttackVector.push(Texture.fromEmbeddedAsset(charCombatAtkAnim2));
			charCombatAttackVector.push(Texture.fromEmbeddedAsset(charCombatAtkAnim3));
			charDict[Util.CHAR_COMBAT_ATTACK] = charCombatAttackVector;

			var charCombatFaintVector:Vector.<Texture> = new Vector.<Texture>();
			charCombatFaintVector.push(Texture.fromEmbeddedAsset(charCombatFaintAnim0));
			charCombatFaintVector.push(Texture.fromEmbeddedAsset(charCombatFaintAnim1));
			charDict[Util.CHAR_COMBAT_FAINT] = charCombatFaintVector;
			tAnimations[Util.CHARACTER] = charDict;

			return tAnimations;
		}

		private function setupFloors():Dictionary {
			var tFloors:Dictionary = new Dictionary();

			// TODO: pass in unintialized vars
			//		 currently can only read a level once
			//		 and then crash if you try to reuse the dictionary
			//		 need to read in the text files each level load :(
			tFloors[Util.FLOOR_0] = new Array(new floor0(), new tiles0(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_1] = new Array(new floor1(), new tiles1(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_2] = new Array(new floor2(), new tiles2(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_3] = new Array(new floor3(), new tiles3(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_4] = new Array(new floor4(), new tiles4(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_5] = new Array(new floor5(), new tiles5(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_6] = new Array(new floor6(), new tiles6(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_7] = new Array(new floor7(), new tiles7(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_8] = new Array(new floor8(), new tiles8(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_9] = new Array(new floor9(), new tiles9(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_10] = new Array(new floor10(), new tiles10(), Texture.fromEmbeddedAsset(transitions0));
			tFloors[Util.FLOOR_11] = new Array(new floor11(), new tiles11(), Texture.fromEmbeddedAsset(transitions0));

			return tFloors;
		}

		private function setupBGM():Array {
			var tBgm:Array = new Array();

			tBgm.push(new bgmDivingTurtle());
			tBgm.push(new bgmGentleThoughts());
			tBgm.push(new bgmGlowInTheDark());
			tBgm.push(new bgmLoversWalk());
			tBgm.push(new bgmOrientalDrift());

			return tBgm;
		}

		private function setupSFX():Dictionary {
			var tSfx:Dictionary = new Dictionary();

			tSfx[Util.FLOOR_COMPLETE] = new sfxFloorComplete();
			tSfx[Util.TILE_MOVE] = new sfxTileMove();
			tSfx[Util.FLOOR_BEGIN] = new sfxFloorBegin();
			tSfx[Util.BUTTON_PRESS] = new sfxButtonPress();
			tSfx[Util.FLOOR_RESET] = new sfxFloorReset();

			return tSfx;
		}
	}
}
