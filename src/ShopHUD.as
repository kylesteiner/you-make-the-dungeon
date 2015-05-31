package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;
	import starling.utils.HAlign;

	import Util;

	public class ShopHUD extends Sprite {
		private static const SHOP_OUTER_PADDING:int = 12;
		private static const STAT_OFFSET:int = 75;

		private var char:Character;
		
		private var bg:Image;
		private var hpVal:TextField;
		private var atkVal:TextField;
		private var staminaVal:TextField;
		private var losVal:TextField;

		private var shopItems:Array;
		private var itemCosts:Array;

		// for help with determining gold spent
		// per phase
		private var spentGold:int;

		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/

		public function ShopHUD() {
			super();

			bg = new Image(Assets.textures[Util.SHOP_BACKGROUND]);
			addChild(bg);

			x = Util.STAGE_WIDTH - width;
			y = (Util.STAGE_HEIGHT - height) / 2;

			shopItems = new Array();
			itemCosts = new Array();

			displayCharStats();
			displayShopItems();

			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}

		private function displayCharStats():void {
			hpVal = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			hpVal.y = 0;
			var hpImg:Image = new Image(Assets.textures[Util.ICON_HEALTH]);
			setupStat(hpVal, hpImg);

			atkVal = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			atkVal.y = height / 4;
			var atkImg:Image = new Image(Assets.textures[Util.ICON_ATK]);
			setupStat(atkVal, atkImg);

			staminaVal = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			staminaVal.y = height / 2;
			var staminaImg:Image = new Image(Assets.textures[Util.ICON_STAMINA]);
			setupStat(staminaVal, staminaImg);

			losVal = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			losVal.y = height * 3 / 4;
			var losImg:Image = new Image(Assets.textures[Util.ICON_LOS]);
			setupStat(losVal, losImg);
		}

		private function setupStat(tf:TextField, i:Image):void {
			tf.height = tf.textBounds.height;
			tf.hAlign = HAlign.LEFT;
			tf.x = STAT_OFFSET;
			i.x = tf.x - i.width;
			i.y = tf.y + tf.height / 2 - i.height / 2;
			addChild(tf);
			addChild(i);
		}

		private function displayShopItems():void {
			var i:int;
			for(i = 0; i < shopItems.length; i++) {
				removeChild(shopItems[i]);
			}

			shopItems = new Array();
			itemCosts = new Array();
			shopItems.push(displayShopItem(0, getHpCost(), incHP));
			shopItems.push(displayShopItem(1, getAttackCost(), incAtk));
			shopItems.push(displayShopItem(2, getStaminaCost(), incStamina));
			shopItems.push(displayShopItem(3, getLOSCost(), incLos));

			for(i = 0; i < shopItems.length; i++) {
				addChild(shopItems[i]);
			}
		}

		private function getHpCost():int {
			var upgrades:int = 0;
			if (char) {
				upgrades = char.maxHp - Util.STARTING_HEALTH;
			}
			return Util.BASE_HP_UPGRADE_COST + upgrades;
		}

		private function getStaminaCost():int {
			var upgrades:int = 0;
			if (char) {
				upgrades = char.maxStamina - Util.STARTING_STAMINA;
			}
			return Util.BASE_STAMINA_UPGRADE_COST + upgrades;
		}

		private function getAttackCost():int {
			var upgrades:int = 0;
			if (char) {
				upgrades = char.attack - Util.STARTING_ATTACK;
			}
			return Util.BASE_ATTACK_UPGRADE_COST * (upgrades + 1);
		}

		private function getLOSCost():int {
			var upgrades:int = 0;
			if (char) {
				upgrades = char.los - Util.STARTING_LOS;
			}
			return Util.BASE_LOS_UPGRADE_COST * (upgrades + 1);
		}

		private function displayShopItem(position:int, cost:int, callback:Function):Clickable {
			var item:Clickable = new Clickable(300, 300, callback, null, Assets.textures[Util.SHOP_ITEM]);
			item.addParameter("cost", cost);

			item.x = 5;
			item.y = position * 50;

			var coin:Image = new Image(Assets.textures[Util.ICON_GOLD]);
			coin.y = item.height - coin.height - 2;
			item.addChild(coin);

			var itemCost:TextField = new TextField(item.width, coin.height, String(cost), Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE);
			itemCost.y = coin.y;
			item.addChild(itemCost);
			itemCosts.push(itemCost);

			return item;
		}

		/**********************************************************************************
		 * Shop item callbacks
		 **********************************************************************************/

		public function incHP(params:Dictionary):void {
			params["type"] = "hp";
			dispatchEvent(new GameEvent(GameEvent.SHOP_SPEND, 0, 0, params));
		}

		public function incAtk(params:Dictionary):void {
			params["type"] = "atk";
			dispatchEvent(new GameEvent(GameEvent.SHOP_SPEND, 0, 0, params));
		}

		public function incStamina(params:Dictionary):void {
			params["type"] = "stamina";
			dispatchEvent(new GameEvent(GameEvent.SHOP_SPEND, 0, 0, params));
		}

		public function incLos(params:Dictionary):void {
			params["type"] = "los";
			dispatchEvent(new GameEvent(GameEvent.SHOP_SPEND, 0, 0, params));
		}

		/**********************************************************************************
		 * Stat & Gold management
		 **********************************************************************************/

		public function update(char:Character):void {
			this.char = char;
		}

		public function setHP(val:int):void {
			char.maxHp = val;
			char.hp = char.maxHp;
			hpVal.text = String(char.maxHp);
		}

		public function setAtk(val:int):void {
			char.attack = val;
			atkVal.text = String(char.attack);
		}

		public function setStamina(val:int):void {
			char.maxStamina = val;
			char.stamina = char.maxStamina;
			staminaVal.text = String(char.maxStamina);
		}

		public function setLos(val:int):void {
			char.los = val;
			losVal.text = String(char.los);
			dispatchEvent(new GameEvent(GameEvent.CHARACTER_LOS_CHANGE, 0, 0));
		}

		private function onEnterFrame(event:EnterFrameEvent):void {
			var i:int;
			var newCost:int;
			var shopButton:Clickable;
			for (i = 0; i < shopItems.length; i++) {
				newCost = getHpCost();
				newCost = i == 1 ? getAttackCost() : newCost;
				newCost = i == 2 ? getStaminaCost() : newCost;
				newCost = i == 3 ? getLOSCost() : newCost;

				shopButton = shopItems[i];
				shopButton.parameters["cost"] = newCost;

				itemCosts[i].text = newCost.toString();
			}
			if (char) {
				setHP(char.maxHp);
				setAtk(char.attack);
				setStamina(char.maxStamina);
				setLos(char.los);
			}
		}
	}
}
