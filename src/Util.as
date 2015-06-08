//Util.as
//Provides a set of utility functions for use throughout the code.

package {
	import flash.ui.Keyboard;
	import starling.display.Quad;
	import starling.text.TextField;

	public class Util {
		public static const STAGE_WIDTH:int = 640;
		public static const STAGE_HEIGHT:int = 480;
		public static const HUD_PAD_TOP:int = 4;
		public static const HUD_PAD_LEFT:int = 8;

		public static const REAL_TILE_SIZE:int = 256;
		public static const PIXELS_PER_TILE:int = 64; // 48
		public static const UI_PADDING:int = 8;
		public static const BORDER_PIXELS:Number = (1.0 / 16.0);
		public static const BUTTON_SPACING:int = (1.0 / 8.0);
		public static const CAMERA_SHIFT:int = 8; // in pixels
		// can update to pixels once tile movement is tied down
		public static const ANIM_FPS:int = 2;
		public static const VISITED_ALPHA:Number = 0.4;
		public static const COMBAT_ALPHA:Number = 0.7;

		public static const CURSOR_OFFSET_X:int = -24;
		public static const CURSOR_OFFSET_Y:int = -14;

		public static const DEFAULT_FONT:String = "Bebas";
		public static const SECONDARY_FONT:String = "Fertigo";
		public static const LARGE_FONT_SIZE:int = 48;
		public static const MEDIUM_FONT_SIZE:int = 32;
		public static const SMALL_FONT_SIZE:int = 24;

		public static const NORTH:int = 0;
		public static const SOUTH:int = 1;
		public static const EAST:int = 2;
		public static const WEST:int = 3;
		public static const DIRECTIONS:Array = new Array(NORTH, SOUTH, EAST, WEST);

		// Movement speed in pixels per frame
		public static const SPEED_SLOW:int = 4;
		public static const SPEED_FAST:int = 8;

		// Keys to the dictionary of textures.
		public static const DOOR:String = "door";
		public static const KEY_STRING:String = "key";

		public static const GRID_BACKGROUND:String = "grid_background";
		public static const STATIC_BACKGROUND:String = "static_background";
		public static const TUTORIAL_BACKGROUND:String = "tutorial_background";
		//public static const TUTORIAL_PAN:String = "tutorial_pan";
		public static const TUTORIAL_TILE:String = "tutorial_tile_hud";
		public static const TUTORIAL_PAN_FLOOR:String = "floor8";
		public static const TUTORIAL_TILE_FLOOR:String = "floor2";
		public static const POPUP_BACKGROUND:String = "popup_background";
		public static const SUMMARY_BACKGROUND:String = "summary_background";
		public static const SHOP_BACKGROUND:String = "shop_background";
		public static const SHOP_ITEM:String = "shop_item";
		public static const RUN_BANNER:String = "run_banner";
		public static const BUILD_BANNER:String = "build_banner";
		public static const RUN_HELP:String = "run_help";
		public static const BUILD_HELP:String = "build_help";

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

		//public static const TILE_FOG:String = "fog";
		public static const TILE_HL_Y:String = "hl_y";
		public static const TILE_HL_B:String = "hl_b";
		public static const TILE_HL_G:String = "hl_g";
		public static const TILE_HL_R:String = "hl_r";
		public static const TILE_HL_TILE:String = "hl_tile";
		public static const TILE_HL_DEL:String = "hl_delete";
		public static const TILE_HL_ENTITY:String = "hl_entity";

		public static const ICON_CURSOR:String = "icon_cursor";
		public static const ICON_CURSOR_2:String = "icon_cursor_2";
		public static const ICON_MUTE_BGM:String = "icon_mute_bgm";
		public static const ICON_MUTE_SFX:String = "icon_mute_sfx";
		public static const ICON_RESET:String = "icon_reset";
		public static const ICON_RUN:String = "icon_run";
		public static const ICON_END:String = "icon_end";
		public static const ICON_ATK:String = "icon_attack";
		public static const ICON_ATK_MED:String = "icon_attack_med";
		public static const ICON_HEALTH:String = "icon_health";
		public static const ICON_HEALTH_MED:String = "icon_health_med";
		public static const ICON_STAMINA:String = "icon_stamina";
		public static const ICON_STAMINA_MED:String = "icon_stamina_med";
		public static const ICON_LOS:String = "icon_los";
		public static const ICON_LOS_MED:String = "icon_los_med";
		public static const ICON_GOLD:String = "icon_gold";
		public static const ICON_DELETE:String = "icon_delete";
		public static const CURSOR_RETICLE:String = "cursor_reticle";
		public static const ICON_SFX_PLAY:String = "sfx_play";
		public static const ICON_SFX_MUTE:String = "sfx_mute";
		public static const ICON_BGM_PLAY:String = "bgm_play";
		public static const ICON_BGM_MUTE:String = "bgm_mute";
		public static const ICON_FAST_COMBAT:String = "icon_fast_combat";
		public static const ICON_SLOW_COMBAT:String = "icon_slow_combat";
		public static const ICON_FAST_RUN:String = "icon_fast_run";
		public static const ICON_SLOW_RUN:String = "icon_slow_run";
		public static const ICON_HELP:String = "icon_help";

		public static const HEALTH_PURCHASE:String = "health_purchase";
		public static const ATTACK_PURCHASE:String = "attack_purchase";
		public static const STAMINA_PURCHASE:String = "stamina_purchase";
		public static const LOS_PURCHASE:String = "los_purchase";

		public static const ENEMY_MENU:String = "enemy_menu";
		public static const HEALING_MENU:String = "healing_menu";
		public static const TRAP_MENU:String = "trap_menu";

		public static const BGM_MUTE_KEY:int = Keyboard.M;
		public static const SFX_MUTE_KEY:int = Keyboard.COMMA;
		public static const COMBAT_SKIP_KEY:int = Keyboard.K;
		public static const SPEED_TOGGLE_KEY:int = Keyboard.J;
		public static const UP_KEY:int = Keyboard.W;
		public static const LEFT_KEY:int = Keyboard.A;
		public static const RIGHT_KEY:int = Keyboard.D;
		public static const DOWN_KEY:int = Keyboard.S;
		public static const TUTORIAL_SKIP_KEY:int = Keyboard.G;
		public static const CHANGE_PHASE_KEY:int = Keyboard.SPACE;

		// if we want to use arrow keys, here are the relevant char codes:
		// up: 38		left: 37
		// down: 40		right: 39

		public static const MAIN_FLOOR:String = "main_floor";

		// Room callbacks
		public static const ROOMCB_NONE:String = "roomcb_none";

		public static const TUTORIAL_NEA:String = "tutorial_nea";
		public static const TUTORIAL_EXIT:String = "tutorial_exit";
		public static const TUTORIAL_MOVE:String = "tutorial_move";
		public static const TUTORIAL_PAN:String = "tutorial_pan";
		public static const TUTORIAL_BUILD_HUD:String = "tutorial_build_hud";
		public static const TUTORIAL_PLACE:String = "tutorial_place";
		public static const TUTORIAL_START_RUN:String = "tutorial_start_run";
		public static const TUTORIAL_SECONDARY_BUILD:String = "tutorial_secondary_build";
		public static const TUTORIAL_HELP:String = "tutorial_help";
		public static const TUTORIAL_ENEMY:String = "tutorial_enemy";
		public static const TUTORIAL_TRAP:String = "tutorial_trap";
		public static const TUTORIAL_UNLOCK:String = "tutorial_unlock";
		public static const TUTORIAL_END_RUN:String = "tutorial_end_run";
		public static const TUTORIAL_SPEED:String = "tutorial_speed";

		public static const TUTORIAL_GOLD:String = "tutorial_gold"
		public static const TUTORIAL_ADVENTURERS:String = "tutorial_adventurers"
		public static const TUTORIAL_SPEND:String = "tutorial_spend"
		public static const TUTORIAL_KEYS:String = "tutorial_keys"

		// Tutorial backgrounds that reveal certain UI features.
		public static const TUTORIAL_BUILDHUD_SHADOW:String = "tutorial_buildhud_shadow";
		public static const TUTORIAL_PLACE_SHADOW:String = "tutorial_place_shadow";
		public static const TUTORIAL_SHOP_SHADOW:String = "tutorial_shop_shadow";
		public static const TUTORIAL_HEALTH_STAMINA_SHADOW:String = "tutorial_health_stamina_shadow";
		public static const TUTORIAL_ENTITY_SHADOW:String = "tutorial_entity_shadow";
		public static const TUTORIAL_DELETE_SHADOW:String = "tutorial_delete_shadow";
		public static const TUTORIAL_SPEED_SHADOW:String = "tutorial_speed_shadow";

		public static const TILE_UP_ACTIVE:String = "tile_up_active";
		public static const TILE_UP_INACTIVE:String = "tile_up_inactive";
		public static const TILE_DOWN_ACTIVE:String = "tile_down_active";
		public static const TILE_DOWN_INACTIVE:String = "tile_down_inactive";
		public static const TILE_RIGHT_ACTIVE:String = "tile_right_active";
		public static const TILE_RIGHT_INACTIVE:String = "tile_right_inactive";
		public static const TILE_LEFT_ACTIVE:String = "tile_left_active";
		public static const TILE_LEFT_INACTIVE:String = "tile_left_inactive";

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
		public static const STAMINA_HEAL:String = "stamina_heal";
		public static const REWARD:String = "reward";
		public static const KEY:String = "key";
		public static const ENEMY_COMBAT_IDLE:String = "enemy_combat_idle";
		public static const ENEMY_COMBAT_ATTACK:String = "enemy_combat_attack";
		public static const ENEMY_COMBAT_FAINT:String = "enemy_combat_faint";
		public static const ENEMY_FIGHTER:String = "enemy_fighter";
		public static const ENEMY_MAGE:String = "enemy_mage";
		public static const ENEMY_ARCHER:String = "enemy_archer";
		public static const ENEMY_NINJA:String = "enemy_ninja";
		public static const ENEMY_KNIGHT:String = "enemy_knight";
		public static const TRAPS:String = "traps"
		public static const BASIC_TRAP:String = "basic_trap";
		public static const FLAME_TRAP:String = "flame_trap";
		public static const FLAME_TRAP_BLUE:String = "flame_trap_blue";
		public static const SHOCK_TRAP:String = "shock_trap";

		public static const GENERIC_ATTACK:String = "generic_attack";

		// Keys to the Dictionary of SFX
		public static const FLOOR_COMPLETE:String = "floor_complete";
		public static const TILE_MOVE:String = "tile_move";
		public static const TILE_FAILURE:String = "tile_failure";
		public static const FLOOR_BEGIN:String = "floor_begin";
		public static const BUTTON_PRESS:String = "button_press";
		public static const COMBAT_FAILURE:String = "combat_failure";
		public static const COMBAT_SUCCESS:String = "combat_success";
		public static const LEVEL_UP:String = "level_up";
		public static const SFX_ATTACK:String = "sfx_attack";
		public static const TILE_REMOVE:String = "tile_remove";
		public static const COIN_COLLECT:String = "coin_collect";
		public static const GOLD_SPEND:String = "gold_spend";
		public static const GOLD_DEFICIT:String = "gold_deficit";
		public static const REWARD_COLLECT:String = "reward_collect";
		public static const DOOR_OPEN:String = "door_open";
		public static const SFX_BASIC_TRAP:String = "sfx_basic_trap";
		public static const SFX_FLAME_TRAP:String = "sfx_flame_trap";
		public static const SFX_SHOCK_TRAP:String = "sfx_shock_trap";
		public static const SFX_STAMINA_HEAL:String = "sfx_stamina_heal";
		public static const SFX_HEAL:String = "sfx_heal";
		public static const SFX_KEY:String = "sfx_key";

		public static const DICT_FLOOR_INDEX:int = 0;
		public static const DICT_TILES_INDEX:int = 1;
		public static const DICT_TRANSITION_INDEX:int = 2;

		public static const STARTING_ATTACK:int = 1;
		public static const STARTING_HEALTH:int = 5;
		public static const STARTING_STAMINA:int = 5;
		public static const STARTING_GOLD:int = 20;
		public static const STARTING_LOS:int = 2;

		// Build costs
		public static const BASE_TILE_COST:int = 1;
		public static const REFUND_PERCENT:int = 50;
		public static const ENEMY_FIGHTER_COST:int = 20;
		public static const ENEMY_MAGE_COST:int = 30;
		public static const ENEMY_ARCHER_COST:int = 40;
		public static const ENEMY_NINJA_COST:int = 50;
		public static const LIGHT_HEALING_COST:int = 8;
		public static const MODERATE_HEALING_COST:int = 35;
		public static const LIGHT_STAMINA_HEAL_COST:int = 8;
		public static const MODERATE_STAMINA_HEAL_COST:int = 20;
		public static const BASIC_TRAP_COST:int = 15;
		public static const FLAME_TRAP_COST:int = 55;
		public static const BLUE_FLAME_TRAP_COST:int = 60;
		public static const SHOCK_TRAP_COST:int = 40;

		// Upgrade costs
		public static const BASE_HP_UPGRADE_COST:int = 6;
		public static const BASE_STAMINA_UPGRADE_COST:int = 6;
		public static const BASE_ATTACK_UPGRADE_COST:int = 10;
		public static const BASE_LOS_UPGRADE_COST:int = 10;

		public static var logger:Logger;
		public static var speed:int;

		public static function grid_to_real(coordinate:int):int {
			return coordinate * PIXELS_PER_TILE;
		}

		public static function real_to_grid(coordinate:int):int {
			return coordinate / PIXELS_PER_TILE;
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

		public static function defaultTextField(width:int, height:int, initialText:String, size:int = Util.MEDIUM_FONT_SIZE):TextField {
			return new TextField(width, height, initialText, Util.DEFAULT_FONT, size);
		}

		public static function getTransparentQuad():Quad {
			var q:Quad = new Quad(Util.STAGE_WIDTH, Util.STAGE_HEIGHT, 0xffffff);
			q.alpha = 0.7;
			return q;
		}
	}
}
