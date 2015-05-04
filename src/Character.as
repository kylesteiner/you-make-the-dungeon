//Character.as
//In-game representation of the character.

package {
	import flash.display.Sprite;
	import starling.core.Starling;
	import Util;

	public class Character extends Sprite {
		public static const BASE_HP:int = 5;

		public var level:int;
		public var xp:int;
		public var max_hp:int;
		public var current_hp:int;
		public var attack:int;
		//No item functionality built in yet

		//Constructs the character at the provided
		//grid position and with the correct stats
		//
		//Requires experience is >= 0
		public function Character(g_x:int, g_y:int, experience:int) {
			//assert(experience >= 0);
			super();
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);
			xp = experience;
			xp_to_level();
			attack = level;
			max_hp = calc_max_hp();
			current_hp = max_hp;
		}

		//Move the character from one tile to the next.
		//Executes the relevant on_entry function when
		//the movement is completed.
		//
		//Requires that the callback is non-null and that
		//the direction exists among the accepted directions.
		public function move(direction:int, callback:Function):void {
			//assert(callback != null);
			//assert(Util.DIRECTIONS.indexOf(direction) != -1);
			return;
		}

		//Determine the character's max hp
		//from their level
		//
		//Requires that the level is > 0
		private function calc_max_hp():int {
			//assert(level > 0);
			return ((level * (level + 1)) / 2) + BASE_HP - 1;
		}

		//Checks current exp and sets the characters
		//xp and level accordingly.
		//
		//Requires that the current xp is >= 0
		private function xp_to_level():void {
			//assert(xp >= 0);
			var t_level:int = 1;
			var t_xp:int = xp;
			while(t_xp >= t_level) {
				t_xp -= t_level;
				t_level++;
			}
			level = t_level;
			xp = t_xp;
		}

	}
}
