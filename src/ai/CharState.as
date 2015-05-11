package ai {

	public class CharState {
		public static const BASE_HP:int = 5;
		// (x,y) are grid coordinates.
		public var x:int;
		public var y:int;
		public var xp:int;
		public var level:int;
		public var maxHp:int;
		public var hp:int;
		public var attack:int;

		// Class representing the character
		public function CharState(x:int,
								  y:int,
								  xp:int,
								  level:int,
								  maxHp:int,
								  hp:int,
								  attack:int) {
			this.x = x;
			this.y = y;
			this.xp = xp;
			this.level = level;
			this.maxHp = maxHp;
			this.hp = hp;
			this.attack = attack;
		}

		// Returns the maximum HP of the character based on its level.
		public static function getMaxHp(level:int):int {
			return ((level * (level + 1)) / 2) + BASE_HP - 1;
		}

		// Attempt to level up the character. This affects all stats.
		public function tryLevelUp():void {
			while (xp >= level) {
				xp -= level;
				level++;
				maxHp = getMaxHp(level);
				hp = maxHp;
				attack = level;
			}
		}

		public function hash():int {
			var sum:int = x * 99989 +
						  y * 100019 +
						  xp * 100069 +
						  level * 100673 +
						  maxHp * 101807 +
						  hp * 103583 +
						  attack * 103951;
			return (sum * 104729) % Math.pow(2, 30);
		}
	}
}
