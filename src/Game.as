package {
	import flash.utils.Dictionary;

	import starling.display.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;

	import Character;
	import Level;
	import tiles.*;
	import Util;

	public class Game extends Sprite {
		public var t:Tile;
		public var textField:TextField;

		[Embed(source='/assets/backgrounds/background.png')] public var bg:Class;

		// Tile textures
		[Embed(source='/assets/tiles/small/tile_e.png')] private static const tile_e:Class;
		[Embed(source='/assets/tiles/small/tile_ew.png')] private static const tile_ew:Class;
		[Embed(source='/assets/tiles/small/tile_n.png')] private static const tile_n:Class;
		[Embed(source='/assets/tiles/small/tile_ne.png')] private static const tile_ne:Class;
		[Embed(source='/assets/tiles/small/tile_new.png')] private static const tile_new:Class;
		[Embed(source='/assets/tiles/small/tile_none.png')] private static const tile_none:Class;
		[Embed(source='/assets/tiles/small/tile_ns.png')] private static const tile_ns:Class;
		[Embed(source='/assets/tiles/small/tile_nse.png')] private static const tile_nse:Class;
		[Embed(source='/assets/tiles/small/tile_nsew.png')] private static const tile_nsew:Class;
		[Embed(source='/assets/tiles/small/tile_nsw.png')] private static const tile_nsw:Class;
		[Embed(source='/assets/tiles/small/tile_nw.png')] private static const tile_nw:Class;
		[Embed(source='/assets/tiles/small/tile_s.png')] private static const tile_s:Class;
		[Embed(source='/assets/tiles/small/tile_se.png')] private static const tile_se:Class;
		[Embed(source='/assets/tiles/small/tile_sew.png')] private static const tile_sew:Class;
		[Embed(source='/assets/tiles/small/tile_sw.png')] private static const tile_sw:Class;
		[Embed(source='/assets/tiles/small/tile_w.png')] private static const tile_w:Class;

		// Map String -> Texture
		// See Util.as for keys to this dictionary.
		private var tileTextures:Dictionary;

		public function Game() {
			var texture:Texture = Texture.fromBitmap(new bg());
			var image:Image = new Image(texture);
			addChild(image);

			tileTextures = setupTextures();

			// Load an empty level for now.
			var level:Level = new Level(new Array(), 0);
			addChild(level);
		}

		private function setupTextures():Dictionary {
			var textures:Dictionary = new Dictionary();
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
			return textures;
		}
	}
}
