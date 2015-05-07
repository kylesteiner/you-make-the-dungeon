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
		[Embed(source='assets/backgrounds/char_hud.png')] private static const char_hud:Class;
		[Embed(source='assets/backgrounds/static_bg.png')] private var static_background:Class; //Credit to STU_WilliamHewitt for placeholder
		[Embed(source='assets/backgrounds/tile_hud.png')] private static const tile_hud:Class;
		[Embed(source='assets/bgm/ludum32.mp3')] private var bgm_ludum:Class;
		[Embed(source='assets/bgm/gaur.mp3')] private var bgm_gaur:Class;
		[Embed(source='assets/effects/large/fog.png')] private static var fog:Class;
		[Embed(source='assets/effects/large/hl_blue.png')] private static var hl_blue:Class;
		[Embed(source='assets/effects/large/hl_green.png')] private static var hl_green:Class;
		[Embed(source='assets/effects/large/hl_red.png')] private static var hl_red:Class;
		[Embed(source='assets/effects/large/hl_yellow.png')] private static var hl_yellow:Class;
		[Embed(source='assets/entities/large/healing.png')] private static var entity_healing:Class;
		[Embed(source='assets/entities/large/hero.png')] private static var entity_hero:Class;
		[Embed(source='assets/entities/large/key.png')] private static var entity_key:Class;
		[Embed(source='assets/entities/large/monster_1.png')] private static var entity_mon1:Class;
		[Embed(source='assets/fonts/BebasNeueRegular.otf', embedAsCFF="false", fontFamily="Bebas")] private static const bebas_font:Class;
		[Embed(source='assets/fonts/LeagueGothicRegular.otf', embedAsCFF="false", fontFamily="League")] private static const league_font:Class;
		[Embed(source='assets/icons/large/cursor.png')] private static var icon_cursor:Class;
		[Embed(source='assets/icons/large/mute.png')] private static var icon_mute:Class;
		[Embed(source='assets/icons/large/reset.png')] private static var icon_reset:Class;
		[Embed(source='assets/icons/large/run.png')] private static var icon_run:Class;
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
		[Embed(source='floordata/floor0.txt', mimeType="application/octet-stream")] public var floor0:Class;
		[Embed(source='floordata/floor1.txt', mimeType="application/octet-stream")] public var floor1:Class;
		[Embed(source='floordata/floor2.txt', mimeType="application/octet-stream")] public var floor2:Class;
		[Embed(source='floordata/floor3.txt', mimeType="application/octet-stream")] public var floor3:Class;
		[Embed(source='floordata/floor4.txt', mimeType="application/octet-stream")] public var floor4:Class;
		[Embed(source='floordata/floor5.txt', mimeType="application/octet-stream")] public var floor5:Class;
		[Embed(source='floordata/floor6.txt', mimeType="application/octet-stream")] public var floor6:Class;
		[Embed(source='floordata/floor7.txt', mimeType="application/octet-stream")] public var floor7:Class;
		[Embed(source='floordata/floor8.txt', mimeType="application/octet-stream")] public var floor8:Class;
		[Embed(source='floordata/floor9.txt', mimeType="application/octet-stream")] public var floor9:Class;
		[Embed(source='floordata/floor10.txt', mimeType="application/octet-stream")] public var floor10:Class;
		[Embed(source='floordata/floor11.txt', mimeType="application/octet-stream")] public var floor11:Class;
		[Embed(source='tilerates/floor0.txt', mimeType="application/octet-stream")] public var tiles0:Class;
		[Embed(source='tilerates/floor1.txt', mimeType="application/octet-stream")] public var tiles1:Class;
		[Embed(source='tilerates/floor2.txt', mimeType="application/octet-stream")] public var tiles2:Class;
		[Embed(source='tilerates/floor3.txt', mimeType="application/octet-stream")] public var tiles3:Class;
		[Embed(source='tilerates/floor4.txt', mimeType="application/octet-stream")] public var tiles4:Class;
		[Embed(source='tilerates/floor5.txt', mimeType="application/octet-stream")] public var tiles5:Class;
		[Embed(source='tilerates/floor6.txt', mimeType="application/octet-stream")] public var tiles6:Class;
		[Embed(source='tilerates/floor7.txt', mimeType="application/octet-stream")] public var tiles7:Class;
		[Embed(source='tilerates/floor8.txt', mimeType="application/octet-stream")] public var tiles8:Class;
		[Embed(source='tilerates/floor9.txt', mimeType="application/octet-stream")] public var tiles9:Class;
		[Embed(source='tilerates/floor10.txt', mimeType="application/octet-stream")] public var tiles10:Class;
		[Embed(source='tilerates/floor11.txt', mimeType="application/octet-stream")] public var tiles11:Class;

		private var cursorImage:Image;
		private var cursorHighlight:Image;
		private var muteButton:Clickable;
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
		private var currentMenu:Menu;
		private var isMenu:Boolean;

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
			muteButton = new Clickable(0, 480 - Util.PIXELS_PER_TILE, toggleMute, null, textures[Util.ICON_MUTE]);
			resetButton = new Clickable(Util.PIXELS_PER_TILE, 480- Util.PIXELS_PER_TILE, resetFloor, null, textures[Util.ICON_RESET]);
			runButton = new Clickable(2 * Util.PIXELS_PER_TILE, 480 - Util.PIXELS_PER_TILE, runFloor, null, textures[Util.ICON_RUN]);

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
			addChild(muteButton);
		}

		public function switchToFloor(newFloorData:Array):void {
			prepareSwap();

			isMenu = false;

			var nextFloorData:Array = new Array();

			currentFloor = new Floor(newFloorData[0], textures, newFloorData[2], newFloorData[3], floors, switchToFloor);
			world.addChild(currentFloor);
			world.addChild(cursorHighlight);
			addChild(world);
			// mute button should always be on top
			addChild(muteButton);
			addChild(resetButton);
			addChild(runButton);
			charHud = new CharHud(currentFloor.char, textures);
			addChild(charHud);
			tileHud = new TileHud(newFloorData[1], textures); // TODO: Allow multiple levels
			addChild(tileHud);
		}

		public function createMainMenu():void {
			var startButton:Clickable = new Clickable(256, 192, createFloorSelect, new TextField(128, 40, "START", "Bebas", Util.MEDIUM_FONT_SIZE));
			var creditsButton:Clickable = new Clickable(256, 256, createCredits, new TextField(128, 40, "CREDITS", "Bebas", Util.MEDIUM_FONT_SIZE));
			switchToMenu(new Menu(new Array(startButton, creditsButton)));
		}

		public function createFloorSelect():void {
			var floor1Button:Clickable = new Clickable(256, 192, switchToFloor, new TextField(128, 40, "Floor 1", "Bebas", Util.MEDIUM_FONT_SIZE));
			floor1Button.addParameter(new floor1());
			floor1Button.addParameter(new tiles1());
			floor1Button.addParameter(1);  // Char level
			floor1Button.addParameter(0);  // Char xp
			var floor4Button:Clickable = new Clickable(256, 256, switchToFloor, new TextField(128, 40, "Floor 4", "Bebas", Util.MEDIUM_FONT_SIZE));
			floor4Button.addParameter(new floor4());
			floor4Button.addParameter(new tiles4());
			floor4Button.addParameter(1);  // Char level
			floor4Button.addParameter(0);  // Char xp
			switchToMenu(new Menu(new Array(floor1Button, floor4Button)));
		}

		public function createCredits():void {
			var startButton:Clickable = new Clickable(256, 192, createMainMenu, new TextField(128, 40, "BACK", "Bebas", Util.MEDIUM_FONT_SIZE));
			var creditsLine:TextField = new TextField(256, 256, "THANKS", "Bebas", Util.LARGE_FONT_SIZE);
			switchToMenu(new Menu(new Array(startButton)));
		}

		public function toggleMute():void {
			mixer.togglePlay();
		}

		public function resetFloor():void {
			currentFloor.resetFloor();
			tileHud.resetTileHud();
			charHud.char = currentFloor.char
		}

		public function runFloor():void {
			// TODO: complete this function
			var floorAStar:AStar = new AStar(currentFloor.grid);
			addChild(floorAStar);
			var floorEntryTile:Tile = currentFloor.getEntry();
			var floorExitTile:Tile = currentFloor.getExit();

			if(!floorEntryTile || !floorExitTile) {
				removeChild(floorAStar);
				return;
			}

			var charPath:Array = floorAStar.findPath(floorEntryTile.grid_x,
													 floorEntryTile.grid_y,
													 floorExitTile.grid_x,
													 floorExitTile.grid_y);
			if(!charPath) {
				removeChild(floorAStar);
				return;
			}

			//floorAStar.screenState.text = charPath.length.toString();

			currentFloor.char.moveThroughFloor(charPath);
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
			var scale:int = Util.REAL_TILE_SIZE / Util.PIXELS_PER_TILE;
			textures[Util.GRID_BACKGROUND] = Texture.fromEmbeddedAsset(grid_background);
			textures[Util.STATIC_BACKGROUND] = Texture.fromEmbeddedAsset(static_background);

			textures[Util.HERO] = Texture.fromBitmap(new entity_hero(), true, false, scale);
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

			textures[Util.ICON_CURSOR] = Texture.fromBitmap(new icon_cursor(), true, false, 1);
			textures[Util.ICON_MUTE] = Texture.fromBitmap(new icon_mute(), true, false, scale);
			textures[Util.ICON_RESET] = Texture.fromBitmap(new icon_reset(), true, false, scale);
			textures[Util.ICON_RUN] = Texture.fromBitmap(new icon_run(), true, false, scale);

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
			tFloors[Util.FLOOR_0] = new Array(new floor0(), new tiles0());
			tFloors[Util.FLOOR_1] = new Array(new floor1(), new tiles1());
			tFloors[Util.FLOOR_2] = new Array(new floor2(), new tiles2());
			tFloors[Util.FLOOR_3] = new Array(new floor3(), new tiles3());
			tFloors[Util.FLOOR_4] = new Array(new floor4(), new tiles4());
			tFloors[Util.FLOOR_5] = new Array(new floor5(), new tiles5());
			tFloors[Util.FLOOR_6] = new Array(new floor6(), new tiles6());
			tFloors[Util.FLOOR_7] = new Array(new floor7(), new tiles7());
			tFloors[Util.FLOOR_8] = new Array(new floor8(), new tiles8());
			tFloors[Util.FLOOR_9] = new Array(new floor9(), new tiles9());
			tFloors[Util.FLOOR_10] = new Array(new floor10(), new tiles10());
			tFloors[Util.FLOOR_11] = new Array(new floor11(), new tiles11());

			return tFloors;
		}

		//private function setupSFX():Dictionary {
			// TODO: make an sfx dictionary
		//}
	}
}
