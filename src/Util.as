//Util.as
//Provides a set of utility functions for use throughout the code.

package {
	public class Util {
		public static const PIXELS_PER_TILE:int = 32;
		public static const CAMERA_SHIFT:int = 1; // in grid spaces
		// can update to pixels once tile movement is tied down

		public static const NORTH:int = 0;
		public static const SOUTH:int = 1;
		public static const EAST:int = 2;
		public static const WEST:int = 3;
		public static const DIRECTIONS:Array = new Array(NORTH, SOUTH, EAST, WEST);

		// Keys to the dictionary of  textures.
		public static const HERO:String = "hero";
		public static const TILE_E:String = "tile_e";
		public static const TILE_EW:String = "tile_ew";
		public static const TILE_N:String = "tile_n";
		public static const TILE_NE:String = "tile_ne";
		public static const TILE_NEW:String = "tile_new";
		public static const TILE_NONE:String = "tile_none";
		public static const TILE_NS:String = "tile_ns";
		public static const TILE_NSE:String = "tile_nse";
		public static const TILE_NSEW:String = "tile_nsew";
		public static const TILE_NSW:String = "tile_nsw";
		public static const TILE_NW:String = "tile_nw";
		public static const TILE_S:String = "tile_s";
		public static const TILE_SE:String = "tile_se";
		public static const TILE_SEW:String = "tile_sew";
		public static const TILE_SW:String = "tile_sw";
		public static const TILE_W:String = "tile_w";

		public static const MUTE_KEY:String = "m";
		public static const UP_KEY:String = "w";
		public static const LEFT_KEY:String = "a";
		public static const RIGHT_KEY:String = "d";
		public static const DOWN_KEY:String = "s";

		// if we want to use arrow keys, here are the relevant char codes:
		// up: 38		left: 37
		// down: 40		right: 39

		public static function grid_to_real(coordinate:int):int {
			return coordinate * PIXELS_PER_TILE;
		}

		public static function real_to_grid(coordinate:int):int {
			return coordinate / PIXELS_PER_TILE;
		}
	}
}
