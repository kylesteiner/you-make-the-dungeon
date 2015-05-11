package ai {
	public class EnemyState extends EntityState{
		public var hp:int;
		public var attack:int;
		public var xpReward:int;

		public function EnemyState(hp:int, attack:int, xpReward:int) {
			this.hp = hp;
			this.attack = attack;
			this.xpReward = xpReward;
		}

		override public function hash():int {
			return ((hp * 92369 + attack * 93559 + xpReward * 102259) * 104677) % Math.pow(2, 30);
		}
	}
}
