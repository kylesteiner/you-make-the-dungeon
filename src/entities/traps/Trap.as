package entities.traps {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import Util;
	import entities.*;

	public class Trap extends Entity {
		public var damage:int;
		public var reward:int;

		public function Trap(g_x:int,
							 g_y:int,
							 texture:Texture,
							 damage:int) {
			super(g_x, g_y, texture);
			this.damage = damage;

			addOverlay();
		}
		
		override public function handleChar(c:Character):void {
			// TODO
		}

		override public function generateOverlay():Sprite {
			var base:Sprite = new Sprite();
			// Ideally would have access to textures to put here
			var damageText:TextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2,
															 Util.SMALL_FONT_SIZE,
															 "-" + this.damage,
															 Util.SMALL_FONT_SIZE);
			// Right and bottom align
			damageText.x = img.width - damageText.width - Entity.INFO_MARGIN;
			damageText.y = img.height - damageText.height - Entity.INFO_MARGIN;
			base.addChild(damageText);

			return base;
		}
	}
}
