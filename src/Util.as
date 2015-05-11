//Util.as
//Provides a set of utility functions for use throughout the code.

package {
	import flash.display3D.textures.Texture;
	public class Util {
		public static const STAGE_WIDTH:int = 640;
		public static const STAGE_HEIGHT:int = 480;

		public static const HUD_PAD_TOP:int = 4;
		public static const HUD_PAD_LEFT:int = 8;

		public static const NUM_AVAILABLE_TILES:int = 5;
		public static const PIXELS_PER_TILE:int = 32;
		public static const CAMERA_SHIFT:int = 1; // in grid spaces
		// can update to pixels once tile movement is tied down
		public static const ANIM_FPS:int = 2;

		public static const DEFAULT_FONT:String = "Bebas";
		public static const LARGE_FONT_SIZE:int = 48;
		public static const MEDIUM_FONT_SIZE:int = 32;
		public static const SMALL_FONT_SIZE:int = 24;

		public static const NORTH:int = 0;
		public static const SOUTH:int = 1;
		public static const EAST:int = 2;
		public static const WEST:int = 3;
		public static const DIRECTIONS:Array = new Array(NORTH, SOUTH, EAST, WEST);

		// Keys to the dictionary of textures.
		public static const GRID_BACKGROUND:String = "grid_background";
		public static const STATIC_BACKGROUND:String = "static_background";

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

		public static const TILE_FOG:String = "fog";
		public static const TILE_HL_Y:String = "hl_y";
		public static const TILE_HL_B:String = "hl_b";
		public static const TILE_HL_G:String = "hl_g";
		public static const TILE_HL_R:String = "hl_r";

		public static const ICON_CURSOR:String = "icon_cursor";
		public static const ICON_MUTE:String = "icon_mute";
		public static const ICON_RESET:String = "icon_reset";
		public static const ICON_RUN:String = "icon_run";
		public static const TILE_HUD:String = "tile_hud";
		public static const CHAR_HUD:String = "char_hud";

		public static const MUTE_KEY:String = "m";
		public static const UP_KEY:String = "w";
		public static const LEFT_KEY:String = "a";
		public static const RIGHT_KEY:String = "d";
		public static const DOWN_KEY:String = "s";

		// if we want to use arrow keys, here are the relevant char codes:
		// up: 38		left: 37
		// down: 40		right: 39

		public static const FLOOR_0:String = "floor0";
		public static const FLOOR_1:String = "floor1";
		public static const FLOOR_2:String = "floor2";
		public static const FLOOR_3:String = "floor3";
		public static const FLOOR_4:String = "floor4";
		public static const FLOOR_5:String = "floor5";
		public static const FLOOR_6:String = "floor6";
		public static const FLOOR_7:String = "floor7";
		public static const FLOOR_8:String = "floor8";
		public static const FLOOR_9:String = "floor9";
		public static const FLOOR_10:String = "floor10";
		public static const FLOOR_11:String = "floor11";

		// Keys to the dictionary of animations
		public static const CHARACTER:String = "character";
		public static const CHAR_IDLE:String = "character_idle";
		public static const HEALING:String = "health";
		public static const KEY:String = "key";
		public static const MONSTER_1:String = "monster_1";

		public static const DICT_FLOOR_INDEX:int = 0;
		public static const DICT_TILES_INDEX:int = 1;
		public static const DICT_TRANSITION_INDEX:int = 2;

		public static const STARTING_LEVEL:int = 1;
		public static const STARTING_XP:int = 0;

		public static function grid_to_real(coordinate:int):int {
			return coordinate * PIXELS_PER_TILE;
		}

		public static function real_to_grid(coordinate:int):int {
			return coordinate / PIXELS_PER_TILE;
		}

		// Returns a random int between the min and max.
		public static function randomRange(min:int, max:int):int {
			return min + (max - min) * Math.random();
		}

		// Returns a string thats maps into the global texture dictionary given which sides of the tile are open.
		public static function getTextureString(tN:Boolean, tS:Boolean, tE:Boolean, tW:Boolean):String {
			var textureString:String = "tile_" + (tN ? "n" : "") + (tS ? "s" : "") + (tE ? "e" : "") + (tW ? "w" : "");
			textureString += (!tN && !tS && !tE && !tW) ? "none" : "";
			return textureString;
		}

		// Removes all non [A-Z][a-z][0-9] characters from the String
		// Also makes the string lowercase. oops.
		// Well, the documentation says it should. but it doesn't?
		// spooky.
		public static function stripString(target:String):String {
			var validCharCodes:Array = new Array();
			var rtn:String = "";

			var i:int;
			for(i = "A".charCodeAt(0); i <= "Z".charCodeAt(0); i++) {
				validCharCodes.push(i);
			}

			for(i = "a".charCodeAt(0); i <= "z".charCodeAt(0); i++) {
				validCharCodes.push(i);
			}

			for(i = "0".charCodeAt(0); i <= "9".charCodeAt(0); i++) {
				validCharCodes.push(i);
			}

			for(i = 0; i < target.length; i++) {
				if(validCharCodes.indexOf(target.charCodeAt(i)) != -1) {
					rtn += target.charAt(i);
				}
			}

			return rtn;
		}
	}
}
