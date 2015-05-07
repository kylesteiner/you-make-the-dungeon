package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;
	
	import tiles.*;
	import Util;
	
	public class CharHud extends Sprite {
		private var textures:Dictionary;
		public var char:Character;
		private var level:TextField;
		private var hp:TextField;
		private var atk:TextField;
		private var xp:TextField;
		
		public function CharHud(currentChar:Character,
								textureDict:Dictionary) {
			super();
			char = currentChar;
			textures = textureDict;
			
			var image:Image = new Image(textures[Util.CHAR_HUD]);
			x = Util.STAGE_WIDTH - image.width - 2;
			y = Util.STAGE_HEIGHT - image.height - 2;
			addChild(image);
			
			level = new TextField(64, 20, "LVL: " + char.level, "Bebas", 20);
			addChild(level);
			
			hp = new TextField(64, 20, "HP: " + char.hp, "Bebas", 20);
			addChild(hp);
			hp.y = 22;
			
			atk = new TextField(64, 20, "Atk: " + char.attack, "Bebas", 20);
			atk.y = 44;
			addChild(atk);
			
			xp = new TextField(64, 20, "Exp: " + char.xp, "Bebas", 20);
			xp.y = 66;
			addChild(xp);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onFrameBegin);
		}
		
		private function onFrameBegin(event:EnterFrameEvent):void {
			level.text = "LVL: " + char.level;
			hp.text = "HP: " + char.hp;
			atk.text = "Atk: " + char.attack;
			xp.text = "EXP: " + char.xp;
		}
	}
}