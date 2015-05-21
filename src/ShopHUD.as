package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;
	import starling.utils.HAlign;

	import clickable.*;
	import Util;
	
	public class ShopHUD extends Sprite {
		private static const SHOP_OUTER_PADDING:int = 12;
		
		public var gold:int;
		private var char:Character;
		private var textures:Dictionary;
		
		private var goldHud:GoldHUD;
		private var hpVal:TextField;
		private var atkVal:TextField;
		private var staminaVal:TextField;
		private var losVal:TextField;
		
		private var shopItems:Array;
		
		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/
		
		public function ShopHUD(goldHud:GoldHUD, closeFunction:Function, textureDict:Dictionary) {
			super();
			this.goldHud = goldHud;
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
			hpVal = new TextField(200, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			hpVal.x = Util.STAGE_WIDTH / 5;
			var hpImg:Image = new Image(textures[Util.ICON_HEALTH]);
			setupStat(hpVal, hpImg);
			
			atkVal = new TextField(200, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			atkVal.x = Util.STAGE_WIDTH / 5 * 2;
			var atkImg:Image = new Image(textures[Util.ICON_ATK]);
			setupStat(atkVal, atkImg);
			
			staminaVal = new TextField(200, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			staminaVal.x = Util.STAGE_WIDTH / 5 * 3;
			var staminaImg:Image = new Image(textures[Util.ICON_STAMINA]);
			setupStat(staminaVal, staminaImg);
			
			losVal = new TextField(200, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			losVal.x = Util.STAGE_WIDTH / 5 * 4;
			var losImg:Image = new Image(textures[Util.ICON_LOS]);
			setupStat(losVal, losImg);
		}
		
		private function setupStat(tf:TextField, i:Image):void {
			tf.height = tf.textBounds.height;
			tf.hAlign = HAlign.LEFT;
			tf.y = (Util.STAGE_HEIGHT - height) / 2 + SHOP_OUTER_PADDING;
			i.x = tf.x - i.width;
			i.y = tf.y + tf.height / 2 - i.height / 2;
			addChild(tf);
			addChild(i);
		}
		
		private function displayShopItems():void {
			displayShopItem(1, new Image(textures[Util.ICON_HEALTH]), 100, incHP);
			displayShopItem(2, new Image(textures[Util.ICON_ATK]), 200, incAtk);
			displayShopItem(3, new Image(textures[Util.ICON_STAMINA]), 300, incStamina);
			displayShopItem(4, new Image(textures[Util.ICON_LOS]), 400, incLos);
		}
		
		private function displayShopItem(position:int, image:Image, cost:int, callback:Function):void {
			var item:Clickable = new Clickable(300, 300, callback, null, textures[Util.SHOP_ITEM]);
			item.addParameter("cost", cost);
			item.x = x + 100 * position;
			item.y = y + 100 + 100 * (position / 3);
			item.addChild(image);
			addChild(item);
		}
		
		/**********************************************************************************
		 * Shop item callbacks
		 **********************************************************************************/
		
		public function incHP(params:Dictionary):void {
			spend(params["cost"]);
			setHP(char.maxHp + 5);
		}
		
		public function incAtk(params:Dictionary):void {
			spend(params["cost"]);
			setAtk(char.atk + 5);
		}
		
		public function incStamina(params:Dictionary):void {
			spend(params["cost"]);
			setStamina(char.maxStamina + 5);
		}
		
		public function incLos(params:Dictionary):void {
			spend(params["cost"]);
			setLos(char.los + 1);
		}
		
		/**********************************************************************************
		 * Stat & Gold management
		 **********************************************************************************/

		public function update(char:Character, gold:int):void {
			this.char = char;
			this.gold = gold;
			setHP(char.maxHp);
			setAtk(char.attack);
			setStamina(char.maxStamina);
			setLos(char.los);
		}

		private function spend(goldSpent:int):Boolean {
			if (gold - goldSpent < 0) {
				return false;
			} else {
				gold -= goldSpent;
				goldHud.update(gold);
				return true;
			}
		}
		
		private function setHP(val:int):void {
			char.maxHp = val;
			char.hp = char.maxHp;
			hpVal.text = String(char.maxHp);
		}
		
		private function setAtk(val:int):void {
			char.attack = val;
			atkVal.text = String(char.attack);
		}
		
		private function setStamina(val:int):void {
			char.maxStamina = val;
			char.stamina = char.stamina;
			staminaVal.text = String(char.maxStamina);
		}
		
		private function setLos(val:int):void {
			char.los = val;
			losVal.text = String(char.los);
		}
	}
}