package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;

	import clickable.*;
	import Util;
	
	public class ShopHUD extends Sprite {
		private static const SHOP_OUTER_PADDING:int = 12;
		
		public var gold:int;
		// 2-D array of shop items
		// array[n][0] is the name
		// array[n][1] is the cost
		public var shop:Array;
		
		private var char:Character;
		private var textures:Dictionary;
		
		private var goldHud:GoldHUD;
		private var hpVal:TextField;
		private var atkVal:TextField;
		private var staminaVal:TextField;
		
		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/
		
		public function ShopHUD(shop:Array, char:Character, goldHud:GoldHUD, gold:int, closeFunction:Function, textureDict:Dictionary) {
			super();
			this.shop = shop;
			this.char = char;
			this.goldHud = goldHud;
			this.gold = gold;
			textures = textureDict;
			
			var bg:Image = new Image(textures[Util.SHOP_BACKGROUND]);
			bg.x = (Util.STAGE_WIDTH - bg.width) / 2;
			bg.y = (Util.STAGE_HEIGHT - bg.height) / 2;
			addChild(bg);
			
			var closeShopButton:Clickable = new Clickable(0, 0, closeFunction, new TextField(250, 40, "CLOSE SHOP", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			closeShopButton.x = (Util.STAGE_WIDTH - closeShopButton.width) / 2;
			closeShopButton.y = Util.STAGE_HEIGHT - (Util.STAGE_HEIGHT - height) / 2 - closeShopButton.height - SHOP_OUTER_PADDING;
			addChild(closeShopButton);
			
			displayCharStats();
			displayShopItems();
		}
		
		private function displayCharStats():void {
			hpVal = new TextField(50, 50, String(char.maxHp), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			hpVal.x = Util.STAGE_WIDTH / 4;
			var hpImg:Image = new Image(textures[Util.ICON_HEALTH]);
			setupStat(hpVal, hpImg);
			
			atkVal = new TextField(50, 50, String(char.attack), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			atkVal.x = Util.STAGE_WIDTH / 2;
			var atkImg:Image = new Image(textures[Util.ICON_ATK]);
			setupStat(atkVal, atkImg);
			
			staminaVal = new TextField(50, 50, String(char.maxStamina), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			staminaVal.x = Util.STAGE_WIDTH / 4 * 3;
			var staminaImg:Image = new Image(textures[Util.ICON_STAMINA]);
			setupStat(staminaVal, staminaImg);
		}
		
		private function setupStat(tf:TextField, i:Image):void {
			tf.height = tf.textBounds.height;
			tf.y = (Util.STAGE_HEIGHT - height) / 2 + SHOP_OUTER_PADDING;
			i.x = tf.x - i.width;
			i.y = tf.y + tf.height / 2 - i.height / 2;
			trace(tf.height);
			addChild(tf);
			addChild(i);
		}
		
		private function displayShopItems():void {
			for (var i:int = 0; i < shop.length; i++) {
				// TODO: Build out
			}
		}
		
		/**********************************************************************************
		 * Stat & Gold management
		 **********************************************************************************/
		
		private function spend(goldPurchase:int):Boolean {
			if (gold - goldPurchase < 0) {
				return false;
			} else {
				gold -= goldPurchase;
				goldHud.update(gold);
				return true;
			}
		}
	}
}