package entities {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

	public class Coin extends Entity {
		public var gold:int;

		public function Coin(g_x:int, g_y:int, texture:Texture, health:int) {
			super(g_x, g_y, texture);
			this.health = health;

			addOverlay();
		}

		override public function handleChar(c:Character):void {
            dispatchEvent(new GameEvent(GameEvent.GAIN_GOLD, c.grid_x, c.grid_y));
		}
	}
}
