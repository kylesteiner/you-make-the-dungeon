package entities.traps {
	import entities.traps.Trap;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import Util;
	import entities.*;

	public class ShockTrap extends Trap {

		public function ShockTrap(g_x:int, g_y:int, texture:Texture, damage:int) {
			super(g_x, g_y, texture, damage);
		}
	}
}
