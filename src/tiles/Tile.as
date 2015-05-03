// Tile.as
// Superclass for all tiles within the game.
// Should never be instantiated.

package tiles {
	import starling.core.Starling;
	import starling.display.*;
	import starling.textures.*;
	import Util;

	public class Tile extends Sprite {
		public var grid_x:int;
		public var grid_y:int;
		public var north:Boolean;
		public var south:Boolean;
		public var east:Boolean;
		public var west:Boolean;

		public var image:Image;

		// Create a new Tile object at position (g_x,g_y) of the grid.
		public function Tile(g_x:int, g_y:int) {
			super();
			grid_x = g_x;
			grid_y = g_y;
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);
		}

		// Called when the player moves into this tile.
		public function on_entry(c:Character):void {
			return;
		}
	}
}
