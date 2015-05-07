package ai {

	public class CharState {
		public var x;
		public var y;

		public var xp:int;
		public var level:int;
		public var maxHp:int;
		public var hp:int;
		public var attack:int;

		public function CharState(x:int,
								  y:int,
								  xp:int,
								  level:int
								  maxHp:int,
								  hp:int
								  attack:int) {
			this.x = x;
			this.y = y;
			this.xp = xp;
			this.level = level;
			this.maxHp = maxHp;
			this.hp = hp;
			this.attack = attack;			
		}
	}
}
