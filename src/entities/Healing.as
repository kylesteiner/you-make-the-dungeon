package entities {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	public class Healing extends Entity {
		public var health:int;

		public function Healing(g_x:int, g_y:int, texture:Texture, health:int) {
			super(g_x, g_y, texture);
			this.health = health;

			addOverlay();
		}

		override public function handleChar(c:Character):void {
			Util.logger.logAction(6, {
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

		override public function generateOverlay():Sprite {
			var base:Sprite = new Sprite();
			// Ideally would have access to textures to put here
			var healthPlus:TextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2,
															 Util.SMALL_FONT_SIZE,
															 "+" + this.health,
															 Util.SMALL_FONT_SIZE);
			// Right and bottom align
			healthPlus.x = img.width - healthPlus.width - Entity.INFO_MARGIN;
			healthPlus.y = img.height - healthPlus.height - Entity.INFO_MARGIN;
			base.addChild(healthPlus);

			return base;
		}
	}
}
