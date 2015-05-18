//Util.as
//Provides a set of utility functions for use throughout the code.

package {
	import flash.display3D.textures.Texture;
	public class Util {
		public static const STAGE_WIDTH:int = 640;
		public static const STAGE_HEIGHT:int = 480;

		public static const HUD_OFFSET:int = 8;
		public static const HUD_OFFSET_TILES:int = 56 + 17;
		public static const HUD_OFFSET_DEL:int = 366;
		public static const HUD_PAD_TOP:int = 8;
		public static const HUD_PAD_LEFT:int = 12;
		public static const HUD_PIXELS_PER_TILE:int = 40;
		public static const HUD_TAB_SIZE:int = 5;

		public static const REAL_TILE_SIZE:int = 256;
		public static const PIXELS_PER_TILE:int = 64; // 48
		public static const BORDER_PIXELS:Number = (1.0 / 16.0);
		public static const BUTTON_SPACING:int = (1.0 / 8.0);
		public static const CAMERA_SHIFT:int = 1; // in grid spaces
		// can update to pixels once tile movement is tied down
		public static const ANIM_FPS:int = 2;
		public static const VISITED_ALPHA:Number = 0.4;
		public static const COMBAT_ALPHA:Number = 0.7;

		public static const CURSOR_OFFSET_X:int = -24;
		public static const CURSOR_OFFSET_Y:int = -14;

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
		public static const DOOR:String = "door";

		public static const GRID_BACKGROUND:String = "grid_background";
		public static const STATIC_BACKGROUND:String = "static_background";
		public static const TUTORIAL_BACKGROUND:String = "tutorial_background";
		public static const TUTORIAL_PAN:String = "tutorial_pan";
		public static const TUTORIAL_TILE:String = "tutorial_tile_hud";
		public static const TUTORIAL_PAN_FLOOR:String = "floor8";
		public static const TUTORIAL_TILE_FLOOR:String = "floor2";
		public static const POPUP_BACKGROUND:String = "popup_background";

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
		public static const TILE_HL_G_NEW:String = "hl_g_new";
		public static const TILE_CHECK_B:String = "check_b";
		public static const TILE_CHECK_UB:String = "check_ub";

		public static const ICON_CURSOR:String = "icon_cursor";
		public static const ICON_CURSOR_2:String = "icon_cursor_2";
		public static const ICON_MUTE_BGM:String = "icon_mute_bgm";
		public static const ICON_MUTE_SFX:String = "icon_mute_sfx";
		public static const ICON_RESET:String = "icon_reset";
		public static const ICON_RUN:String = "icon_run";
		public static const ICON_ATK:String = "icon_attack";
		public static const ICON_HEALTH:String = "icon_health";
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

		public static const COMBAT_BG:String = "combat_bg";
		public static const COMBAT_SHADOW:String = "combat_shadow";

		// Keys to the dictionary of animations
		public static const CHARACTER:String = "character";
		public static const CHAR_IDLE:String = "character_idle";
		public static const CHAR_MOVE:String = "character_move";
		public static const CHAR_COMBAT_IDLE:String = "character_combat_idle";
		public static const CHAR_COMBAT_ATTACK:String = "character_combat_attack";
		public static const CHAR_COMBAT_FAINT:String = "character_combat_faint";
		public static const HEALING:String = "health";
		public static const KEY:String = "key";
		public static const ENEMY_COMBAT_IDLE:String = "enemy_combat_idle";
		public static const ENEMY_COMBAT_ATTACK:String = "enemy_combat_attack";
		public static const ENEMY_COMBAT_FAINT:String = "enemy_combat_faint";
		public static const MONSTER_1:String = "monster_1";
		public static const MONSTER_2:String = "monster_2";

		public static const GENERIC_ATTACK:String = "generic_attack";

		// Keys to the Dictionary of SFX
		public static const FLOOR_COMPLETE:String = "floor_complete";
		public static const TILE_MOVE:String = "tile_move";
		public static const TILE_FAILURE:String = "tile_failure";
		public static const FLOOR_BEGIN:String = "floor_begin";
		public static const BUTTON_PRESS:String = "button_press";
		public static const FLOOR_RESET:String = "floor_reset";
		public static const COMBAT_FAILURE:String = "combat_failure";
		public static const COMBAT_SUCCESS:String = "combat_success";
		public static const LEVEL_UP:String = "level_up";
		public static const SFX_ATTACK:String = "sfx_attack";

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

		// Returns a 2D array with the given dimensions.
		public static function initializeGrid(x:int, y:int):Array {
			var arr:Array = new Array(x);
			// Potential bug exists here when appending Tiles to
			// the end of the outside array (which should never occur)
			// Code elsewhere will treat an Array of 5 Arrays and a Tile
			// as 6 Arrays, which then bugs when we set properties of the
			// 6th "Array".
			for (var i:int = 0; i < x; i++) {
				arr[i] = new Array(y);
			}
			return arr;
		}

		// Returns a random int between the min and max, including max.
		public static function randomRange(min:int, max:int):int {
			return Math.floor(Math.random() * (max - min + 1)) + min;
			//return min + (max - min) * Math.random();
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

		public static function hashString(str:String):int {
			var hash:int = 0;
			if (str.length == 0) {
				return hash;
			}
			for (var i:int = 0; i < str.length; i++) {
				var char:int = str.charCodeAt(i);
				hash = ((hash<<5)-hash)+char;
				hash = hash & hash;
			}
			return hash;
		}
	}
}
