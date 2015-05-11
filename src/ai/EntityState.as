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
		public var health:int; // How much health is restored.
		public var healthUsed:Boolean; // Whether the character has used the tile.

		// Objective Entity
		// Identifies this tile in Floor.objectiveState, prereqs
		public var key:String;
		// Objectives that must be completed before passing through this tile. Pathfinding/
		// movement rules need to check this field and Floor.objectiveState to see if the
		// tile is passable.
		public var prereqs:Array;

		public function EntityState(type:String,
									hp:int = 0,
									attack:int = 0,
									xpReward:int = 0,
									health:int = 0,
									healthUsed:Boolean = false,
									key:String = "",
									prereqs:Array = null) {
			this.type = type;
			this.hp = hp;
			this.attack = attack;
			this.xpReward = xpReward;
			this.health = health;
			this.healthUsed = healthUsed;
			this.key = key;
			this.prereqs = prereqs;
		}
	}
}
