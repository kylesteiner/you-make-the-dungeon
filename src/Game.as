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
	import ai.*;

	public class Game extends Sprite {
		[Embed(source='assets/backgrounds/background.png')] private var grid_background:Class;
		[Embed(source='assets/backgrounds/static_bg.png')] private var static_background:Class; //Credit to STU_WilliamHewitt for placeholder
		[Embed(source='assets/bgm/ludum32.mp3')] private var bgm_ludum:Class;
		[Embed(source='assets/bgm/gaur.mp3')] private var bgm_gaur:Class;
		[Embed(source='assets/backgrounds/tile_hud.png')] private static const tile_hud:Class;
		[Embed(source='assets/backgrounds/char_hud.png')] private static const char_hud:Class;
		[Embed(source='assets/effects/fog.png')] private static const fog:Class;
		[Embed(source='assets/effects/hl_blue.png')] private static const hl_blue:Class;
		[Embed(source='assets/effects/hl_green.png')] private static const hl_green:Class;
		[Embed(source='assets/effects/hl_red.png')] private static const hl_red:Class;
		[Embed(source='assets/effects/hl_yellow.png')] private static const hl_yellow:Class;
		[Embed(source='assets/entities/healing.png')] private static const entity_healing:Class;
		[Embed(source='assets/entities/hero.png')] private static const entity_hero:Class;
		[Embed(source='assets/entities/key.png')] private static const entity_key:Class;
		[Embed(source='assets/entities/monster_1.png')] private static const entity_mon1:Class;
		[Embed(source='assets/fonts/BebasNeueRegular.otf', embedAsCFF="false", fontFamily="Bebas")] private static const bebas_font:Class;
		[Embed(source='assets/fonts/LeagueGothicRegular.otf', embedAsCFF="false", fontFamily="League")] private static const league_font:Class;
		[Embed(source='assets/icons/cursor.png')] private static const icon_cursor:Class;
		[Embed(source='assets/icons/mute.png')] private static const icon_mute:Class;
		[Embed(source='assets/icons/reset.png')] private static const icon_reset:Class;
		[Embed(source='assets/icons/run.png')] private static const icon_run:Class;
		[Embed(source='assets/tiles/tile_e.png')] private static const tile_e:Class;
		[Embed(source='assets/tiles/tile_ew.png')] private static const tile_ew:Class;
		[Embed(source='assets/tiles/tile_n.png')] private static const tile_n:Class;
		[Embed(source='assets/tiles/tile_ne.png')] private static const tile_ne:Class;
		[Embed(source='assets/tiles/tile_new.png')] private static const tile_new:Class;
		[Embed(source='assets/tiles/tile_none.png')] private static const tile_none:Class;
		[Embed(source='assets/tiles/tile_ns.png')] private static const tile_ns:Class;
		[Embed(source='assets/tiles/tile_nse.png')] private static const tile_nse:Class;
		[Embed(source='assets/tiles/tile_nsew.png')] private static const tile_nsew:Class;
		[Embed(source='assets/tiles/tile_nsw.png')] private static const tile_nsw:Class;
		[Embed(source='assets/tiles/tile_nw.png')] private static const tile_nw:Class;
		[Embed(source='assets/tiles/tile_s.png')] private static const tile_s:Class;
		[Embed(source='assets/tiles/tile_se.png')] private static const tile_se:Class;
		[Embed(source='assets/tiles/tile_sew.png')] private static const tile_sew:Class;
		[Embed(source='assets/tiles/tile_sw.png')] private static const tile_sw:Class;
		[Embed(source='assets/tiles/tile_w.png')] private static const tile_w:Class;

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
		private var staticBackgroundImage:Image;
		private var world:Sprite;
		private var menuWorld:Sprite;
		private var currentFloor:Floor;
		private var currentTransition:Clickable;
		private var currentMenu:Menu;
		private var isMenu:Boolean;
		private var sfxMuted:Boolean;

		public function Game() {
			Mouse.hide();

			textures = setupTextures();
			floors = setupFloors();

			mixer = new Mixer(new Array(new bgm_gaur(), new bgm_ludum()));

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
		}

		private function initializeFloorWorld():void {
			world = new Sprite();
			world.addChild(new Image(Texture.fromBitmap(new grid_background())));
			bgmMuteButton = new Clickable(0, 480-32, toggleBgmMute, null, textures[Util.ICON_MUTE]);
			sfxMuteButton = new Clickable(32, 480-32, toggleSfxMute, null, textures[Util.ICON_MUTE]);
			resetButton = new Clickable(64, 480-32, resetFloor, null, textures[Util.ICON_RESET]);
			runButton = new Clickable(96, 480-32, runFloor, null, textures[Util.ICON_RUN]);

			sfxMuted = false;

			cursorHighlight = new Image(textures[Util.TILE_HL_B]);
			cursorHighlight.touchable = false;
			world.addChild(cursorHighlight);
		}

		private function initializeMenuWorld():void {
			menuWorld = new Sprite();
			menuWorld.addChild(new Image(Texture.fromBitmap(new grid_background())));
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
			currentTransition = new Clickable(0, 0, switchToFloor, null, newTransitionData[0]);

			var i:int;
			for(i = 1; i < newTransitionData.length; i++) {
				currentTransition.addParameter(newTransitionData[i]);
			}

			addChild(currentTransition);
		}

		public function switchToFloor(newFloorData:Array):void {
			prepareSwap();

			isMenu = false;

			var nextFloorData:Array = new Array();

			currentFloor = new Floor(newFloorData[0], textures, newFloorData[2], newFloorData[3], floors, switchToTransition);
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
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_TRANSITION_INDEX]);
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_FLOOR_INDEX]);
			floor1Button.addParameter(floors[Util.FLOOR_1][Util.DICT_TILES_INDEX]);
			floor1Button.addParameter(Util.STARTING_LEVEL);  // Char level
			floor1Button.addParameter(Util.STARTING_XP);  // Char xp
			var floor4Button:Clickable = new Clickable(256, 256, switchToTransition, new TextField(128, 40, "Floor 4", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			floor4Button.addParameter(floors[Util.FLOOR_4][Util.DICT_TRANSITION_INDEX]);
			floor4Button.addParameter(floors[Util.FLOOR_4][Util.DICT_FLOOR_INDEX]);
			floor4Button.addParameter(floors[Util.FLOOR_4][Util.DICT_TILES_INDEX]);
			floor4Button.addParameter(Util.STARTING_LEVEL);  // Char level
			floor4Button.addParameter(Util.STARTING_XP);  // Char xp
			switchToMenu(new Menu(new Array(floor1Button, floor4Button)));
		}

		public function createCredits():void {
			var startButton:Clickable = new Clickable(256, 192, createMainMenu, new TextField(128, 40, "BACK", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			var creditsLine:TextField = new TextField(256, 256, "THANKS", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			switchToMenu(new Menu(new Array(startButton)));
		}

		public function toggleBgmMute():void {
			mixer.togglePlay();
		}

		public function toggleSfxMute():void {
			sfxMuted = !sfxMuted;
		}

		public function resetFloor():void {
			currentFloor.resetFloor();
			tileHud.resetTileHud();
			charHud.char = currentFloor.char
		}

		public function runFloor():void {
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
				var tileInUse:int = tileHud.indexOfTileInUse();
				if (tileInUse == -1) {
					return;
				}
				var selectedTile:Tile = tileHud.getTileByIndex(tileInUse);
				if (touch.phase == TouchPhase.ENDED) {
					// Player placed one of the available tiles
					currentFloor.clearHighlightedLocations();
					if (selectedTile.grid_x < currentFloor.gridWidth &&
						selectedTile.grid_y < currentFloor.gridHeight &&
						!currentFloor.grid[selectedTile.grid_x][selectedTile.grid_y] &&
						currentFloor.fitsInDungeon(selectedTile.grid_x, selectedTile.grid_y, selectedTile)) {
						// Move tile from HUD to grid. Add new tile to HUD.
						tileHud.removeAndReplaceTile(tileInUse);
						currentFloor.grid[selectedTile.grid_x][selectedTile.grid_y] = selectedTile;
						currentFloor.addChild(selectedTile);
						selectedTile.positionTileOnGrid();
					} else {
						// Tile wasn't placed correctly. Return tile to HUD.
						tileHud.returnTileInUse();
					}
				} else if (touch.phase == TouchPhase.BEGAN) {
					currentFloor.highlightAllowedLocations(selectedTile);
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
			textures[Util.GRID_BACKGROUND] = Texture.fromEmbeddedAsset(grid_background);
			textures[Util.STATIC_BACKGROUND] = Texture.fromEmbeddedAsset(static_background);

			textures[Util.HERO] = Texture.fromEmbeddedAsset(entity_hero);
			textures[Util.HEALING] = Texture.fromEmbeddedAsset(entity_healing);
			textures[Util.KEY] = Texture.fromEmbeddedAsset(entity_key);
			textures[Util.MONSTER_1] = Texture.fromEmbeddedAsset(entity_mon1);

			textures[Util.TILE_E] = Texture.fromEmbeddedAsset(tile_e);
			textures[Util.TILE_EW] = Texture.fromEmbeddedAsset(tile_ew);
			textures[Util.TILE_N] = Texture.fromEmbeddedAsset(tile_n);
			textures[Util.TILE_NE] = Texture.fromEmbeddedAsset(tile_ne);
			textures[Util.TILE_NEW] = Texture.fromEmbeddedAsset(tile_new);
			textures[Util.TILE_NONE] = Texture.fromEmbeddedAsset(tile_none);
			textures[Util.TILE_NS] = Texture.fromEmbeddedAsset(tile_ns);
			textures[Util.TILE_NSE] = Texture.fromEmbeddedAsset(tile_nse);
			textures[Util.TILE_NSEW] = Texture.fromEmbeddedAsset(tile_nsew);
			textures[Util.TILE_NSW] = Texture.fromEmbeddedAsset(tile_nsw);
			textures[Util.TILE_NW] = Texture.fromEmbeddedAsset(tile_nw);
			textures[Util.TILE_S] = Texture.fromEmbeddedAsset(tile_s);
			textures[Util.TILE_SE] = Texture.fromEmbeddedAsset(tile_se);
			textures[Util.TILE_SEW] = Texture.fromEmbeddedAsset(tile_sew);
			textures[Util.TILE_SW] = Texture.fromEmbeddedAsset(tile_sw);
			textures[Util.TILE_W] = Texture.fromEmbeddedAsset(tile_w);

			textures[Util.TILE_FOG] = Texture.fromEmbeddedAsset(fog);
			textures[Util.TILE_HL_Y] = Texture.fromEmbeddedAsset(hl_yellow);
			textures[Util.TILE_HL_R] = Texture.fromEmbeddedAsset(hl_red);
			textures[Util.TILE_HL_G] = Texture.fromEmbeddedAsset(hl_green);
			textures[Util.TILE_HL_B] = Texture.fromEmbeddedAsset(hl_blue);

			textures[Util.ICON_CURSOR] = Texture.fromEmbeddedAsset(icon_cursor);
			textures[Util.ICON_MUTE] = Texture.fromEmbeddedAsset(icon_mute);
			textures[Util.ICON_RESET] = Texture.fromEmbeddedAsset(icon_reset);
			textures[Util.ICON_RUN] = Texture.fromEmbeddedAsset(icon_run);
			textures[Util.TILE_HUD] = Texture.fromEmbeddedAsset(tile_hud);
			textures[Util.CHAR_HUD] = Texture.fromEmbeddedAsset(char_hud);
			return textures;
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

		//private function setupSFX():Dictionary {
			// TODO: make an sfx dictionary
		//}
	}
}
