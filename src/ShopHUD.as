package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;

	import Util;
	
	public class ShopHUD extends Sprite {
		private var textures:Dictionary;
		private var bg:Image;
		
		public function ShopHUD(textureDict:Dictionary) {
			super();
			textures = textureDict;
			
			bg = new Image(textures[Util.POPUP_BACKGROUND]);
			bg.x = (Util.STAGE_WIDTH - bg.width) / 2;
			bg.y = (Util.STAGE_HEIGHT - bg.height) / 2;
			addChild(bg);
		}
		
	}

}