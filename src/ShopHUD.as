package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;

	import Util;
	
	public class ShopHUD extends Sprite {
		public var gold:int;
		
		private var char:Character;
		private var textures:Dictionary;
		
		private var goldHud:GoldHUD;
		private var hpVal:TextField;
		private var atkVal:TextField;
		private var staminaVal:TextField;
		
		public function ShopHUD(char:Character, gold:int, textureDict:Dictionary) {
			super();
			this.char = char;
			this.gold = gold;
			textures = textureDict;
			
			var bg:Image = new Image(textures[Util.SHOP_BACKGROUND]);
			bg.x = (Util.STAGE_WIDTH - bg.width) / 2;
			bg.y = (Util.STAGE_HEIGHT - bg.height) / 2;
			addChild(bg);
			
			goldHud = new GoldHUD(gold, textureDict);
			goldHud.x = Util.STAGE_WIDTH - goldHud.width;
			addChild(goldHud);
			
			var hpImg:Image = new Image(textures[Util.ICON_HEALTH]);
			hpImg.x = 100;
			addChild(hpImg);
			hpVal = new TextField(100, 50, String(char.maxHp), Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			hpVal.x = 120;
			addChild(hpVal);
			
			var atkImg:Image = new Image(textures[Util.ICON_ATK]);
			atkImg.x = 250;
			addChild(atkImg);
			atkVal = new TextField(100, 50, String(char.attack), Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			atkVal.x = 270;
			addChild(atkVal);
			
			var staminaImg:Image = new Image(textures[Util.ICON_STAMINA]);
			staminaImg.x = 400;
			addChild(staminaImg);
			staminaVal = new TextField(100, 50, String(char.maxStamina), Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			staminaVal.x = 420;
			addChild(staminaVal);
		}
	}
}