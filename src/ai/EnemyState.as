package ai {
	public class EnemyState {
		public var hp:int;
		public var attack:int;
		public var xpReward:int;

		public function EnemyState(hp:int, attack:int, xpReward:int) {
			this.hp = hp;
			this.attack = attack;
			this.xpReward = xpReward;
		}
	}
}
