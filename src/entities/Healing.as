package entities {
	import starling.textures.Texture;

	public class Healing extends Entity {
		public var health:int;

		public function Healing(g_x:int, g_y:int, texture:Texture, health:int) {
			super(g_x, g_y, texture);
		}

		override public function handleChar(c:Character):void {
			if (c.hp == c.maxHp) {
				return;  // Early return if no healing necessary
			}

			Util.logger.logAction(6, {
				"characterHealth": c.hp,
				"characterMaxHealth": c.maxHp,
				"healthRestored": health
			});
			c.hp += health;
			if (c.hp > c.maxHp) {
				c.hp = c.maxHp;
			}
			dispatchEvent(new GameEvent(GameEvent.HEALED, grid_x, grid_y));
		}
	}
}
