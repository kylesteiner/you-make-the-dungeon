package entities {
	import starling.textures.Texture;

	public class Healing extends Entity {
		public var health;

		public function Healing(g_x:int, g_y:int, texture:Texture, health:int) {
			super(g_x, g_y, texture);
		}

		// Attempts to heal the character with the given state. Returns false
		// if the character doesn't require healing, true if the character
		// was healed.
		private function healCharacter(c:Character):Boolean {
			if (c.hp == c.maxHp) {
				return false;
			}

			c.hp += health;
			if (c.hp > c.maxHp) {
				c.hp = c.maxHp;
			}
			return true;
		}
	}
}
