package ai {
	public class EntityState {
		public static const ENEMY:String = "enemy";
		public static const HEALING:String = "healing";
		public static const OBJECTIVE:String = "objective";

		public var type:String;

		// Enemy Entity
		public var hp:int;
		public var attack:int;
		public var xpReward:int;

		// Healing Entity
		public var health:int;

		// Objective Entity
		public var key:String;

		public function EntityState(type:String,
									hp:int = 0,
									attack:int = 0,
									xpReward:int = 0,
									health:int = 0,
									key:String = "") {
			this.type = type;
			this.hp = hp;
			this.attack = attack;
			this.xpReward = xpReward;
			this.health = health;
		}
	}
}
