//Util.as
//Provides a set of utility functions for use throughout the code.

package {
	public class Util {
		public static const PIXELS_PER_TILE:int = 32;
		public static const NORTH:int = 0;
		public static const SOUTH:int = 1;
		public static const EAST:int = 2;
		public static const WEST:int = 3;
		public static const DIRECTIONS:Array = new Array(NORTH, SOUTH, EAST, WEST);

		// Keys to the dictionary of tile textures.
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

		public static function grid_to_real(coordinate:int):int {
			return coordinate * PIXELS_PER_TILE;
		}

		public static function real_to_grid(coordinate:int):int {
			return coordinate / PIXELS_PER_TILE;
		}
	}
}
