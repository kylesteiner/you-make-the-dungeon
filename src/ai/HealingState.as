package ai {

	public class HealingState {
		public var health:int;

		public function HealingState(health:int) {
			this.health = health;
		}

		// Attempts to heal the character with the given state. Returns false
		// if the character doesn't require healing, true if the character
		// was healed.
		public function HealCharacter(c:CharState):Boolean {
			// TODO: refactor logic out of HealingTile sprite.
			return false;
		}
	}
}
