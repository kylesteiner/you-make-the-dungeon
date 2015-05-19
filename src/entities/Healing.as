package entities {
	import starling.textures.Texture;

	public class Healing extends Entity {
		public var health:int;

		public function Healing(g_x:int, g_y:int, texture:Texture, logger:Logger, health:int) {
			super(g_x, g_y, texture, logger);
		}

		override public function handleChar(c:Character):void {
			logger.logAction(6, {
				"characterHealth": c.hp,
				"characterMaxHealth": c.maxHp,
				"healthRestored": health
			});

			if (c.hp == c.maxHp) {
				return;
			}
			c.hp += health;
			if (c.hp > c.maxHp) {
				c.hp = c.maxHp;
			}
		}
	}
}
