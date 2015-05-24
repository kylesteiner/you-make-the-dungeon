package entities {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	public class Coin extends Entity {
		public var gold:int;

		public function Coin(g_x:int, g_y:int, texture:Texture, gold:int) {
			super(g_x, g_y, texture);
			this.gold = gold;
			//addOverlay();
		}

		override public function generateOverlay():Sprite {
			var base:Sprite = new Sprite();
			// Ideally would have access to textures to put here
			var goldAmount:TextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2,
						 									 Util.SMALL_FONT_SIZE,
						 									 this.gold.toString(),
															 Util.SMALL_FONT_SIZE);
			// Center align
			goldAmount.x = (img.width - goldAmount.width) / 2;
			goldAmount.y = (img.height - goldAmount.height) / 2;
			base.addChild(goldAmount);

			return base;
		}
	}
}
