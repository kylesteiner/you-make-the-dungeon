package entities {
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;

	import tiles.TileEvent;
	import Util;

	// Base class for all Entities. Should not be instantiated.
	public class Entity extends Sprite {
		public var grid_x:int;
		public var grid_y:int;
		public var img:Image;

		public function Entity(g_x:int, g_y:int, texture:Texture) {
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);
			grid_x = g_x;
			grid_y = g_y;
			img = new Image(texture);
			addChild(img);
		}
	}
}
