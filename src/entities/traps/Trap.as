package entities.traps {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import Util;

	public class Trap extends Entity {
		public var damage:int;
		public var reward:int;

		public function Trap(g_x:int,
							 g_y:int,
							 texture:Texture,
							 damage:int,
							 reward:int) {
			super(g_x, g_y, texture);
			this.damage = damage;
			this.reward = reward;

			addOverlay();
		}
}
