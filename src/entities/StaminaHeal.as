package entities {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	public class StaminaHeal extends Entity {
		public var stamina:int;

		public function StaminaHeal(g_x:int, g_y:int, texture:Texture, stamina:int) {
			super(g_x, g_y, texture);
			this.stamina = stamina;

			addOverlay();
		}

		override public function handleChar(c:Character):void {
			if (c.stamina == c.maxStamina) {
				return;  // Early return if no healing necessary
			}

			Assets.mixer.play(Util.SFX_STAMINA_HEAL);

			c.stamina += stamina;
			if (c.stamina > c.maxStamina) {
				c.stamina = c.maxStamina;
			}
			dispatchEvent(new GameEvent(GameEvent.STAMINA_HEALED, grid_x, grid_y));
		}

		override public function generateOverlay():Sprite {
			var base:Sprite = new Sprite();
			// Ideally would have access to textures to put here
			var staminaPlus:TextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2,
					 										  Util.SMALL_FONT_SIZE,
															  "+" + this.stamina,
															  Util.SMALL_FONT_SIZE);
			// Right and bottom align
            staminaPlus.x = img.width - staminaPlus.width - Entity.INFO_MARGIN;
            staminaPlus.y = img.height - staminaPlus.height - Entity.INFO_MARGIN;
			base.addChild(staminaPlus);

			return base;
		}

		override public function generateDescription():String {
			return "Restores " + stamina + " stamina.";
		}
	}
}
