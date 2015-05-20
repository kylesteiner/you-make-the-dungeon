package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.events.FocusEvent;
	import starling.events.*;
	import starling.textures.*;

	import Util;
	
	public class ShopHUD extends Sprite {
		private var textures:Dictionary;
		private var bg:Image;
		
		public function ShopHUD(textureDict:Dictionary) {
			super();
			textures = textureDict;
			
			bg = new Image(textures[Util.SHOP_BACKGROUND]);
			bg.x = (Util.STAGE_WIDTH - bg.width) / 2;
			bg.y = (Util.STAGE_HEIGHT - bg.height) / 2;
			addChild(bg);
			
			addEventListener(FocusEvent.FOCUS_OUT, onBlur);
		}
	
		private function close():void {
			this.parent.removeChild(this);
		}
		
		private function reset():void {
			
		}
	}
}