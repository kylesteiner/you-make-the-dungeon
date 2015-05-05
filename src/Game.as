package {
	import flash.utils.Dictionary;

	import starling.display.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;

	import flash.media.*;
	import flash.ui.Mouse;

	import Character;
	import tiles.*;
	import Util;

	public class Game extends Sprite {
		[Embed(source='assets/backgrounds/background.png')] private var bg:Class;
		[Embed(source='assets/backgrounds/static_bg.png')] private var static_bg:Class; //Credit to STU_WilliamHewitt for placeholder
		[Embed(source='assets/bgm/ludum32.mp3')] private var bgm:Class;
		[Embed(source='assets/effects/fog.png')] private static const fog:Class;
		[Embed(source='assets/effects/hl_blue.png')] private static const hl_blue:Class;
		[Embed(source='assets/effects/hl_green.png')] private static const hl_green:Class;
		[Embed(source='assets/effects/hl_red.png')] private static const hl_red:Class;
		[Embed(source='assets/effects/hl_yellow.png')] private static const hl_yellow:Class;
		[Embed(source='assets/entities/hero.png')] private static const hero:Class;
		[Embed(source='assets/icons/cursor.png')] private static const icon_cursor:Class;
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
		[Embed(source='floordata/floor0.txt', mimeType="application/octet-stream")] public var floor0:Class;

		private var cursorImage:Image;
		private var cursorHighlight:Image;
		private var mixer:Mixer;
		private var textures:Dictionary;  // Map String -> Texture. See util.as.
		private var world:Sprite;

		public function Game() {
			Mouse.hide();

			var staticBg:Texture = Texture.fromBitmap(new static_bg());
			var staticImage:Image =new Image(staticBg);
			addChild(staticImage);

			world = new Sprite();
			addChild(world);

			var texture:Texture = Texture.fromBitmap(new bg());
			var image:Image = new Image(texture);
			world.addChild(image);

			textures = setupTextures();

			cursorImage = new Image(textures[Util.ICON_CURSOR]);
			addChild(cursorImage);
			cursorHighlight = new Image(textures[Util.TILE_HL_B]);
			world.addChild(cursorHighlight);

			mixer = new Mixer(new Array(new bgm()));

			var f:Floor = new Floor(new floor0(), textures, 0);
			world.addChild(f);

			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
		}

		private function onMouseEvent(event:TouchEvent):void {
			var touch:Touch = event.getTouch(stage);
			var xOffset:int = touch.globalX < world.x ? Util.PIXELS_PER_TILE : 0;
			var yOffset:int = touch.globalY < world.y ? Util.PIXELS_PER_TILE : 0;
			cursorHighlight.x = Util.grid_to_real(Util.real_to_grid(touch.globalX - world.x - xOffset));
			cursorHighlight.y = Util.grid_to_real(Util.real_to_grid(touch.globalY - world.y - yOffset));

			// TODO: make it so cursorImage can move outside of the world
			cursorImage.x = touch.globalX;
			cursorImage.y = touch.globalY;
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
			textures[Util.HERO] = Texture.fromEmbeddedAsset(hero);
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
			return textures;
		}

		//private function setupSFX():Dictionary {
			// TODO: make an sfx dictionary
		//}
	}
}
