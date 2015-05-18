package ai {

	public class HealingState extends EntityState {
		public var health:int;

		public function HealingState(health:int) {
			this.health = health;
		}

		// Attempts to heal the character with the given state. Returns false
		// if the character doesn't require healing, true if the character
		// was healed.
		public function healCharacter(c:Character):Boolean {
			if (c.hp == c.maxHp) {
				return false;
			}

			c.hp += health;
			if (c.hp > c.maxHp) {
				c.hp = c.maxHp;
			}
			return true;
		}

		override public function hash():int {
			return health;
		}
	}
}
