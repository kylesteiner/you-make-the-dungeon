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

		public var gold:int;
		private var char:Character;

		private var bg:Image;
		private var goldHud:GoldHUD;
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

		public function ShopHUD(goldHud:GoldHUD, closeFunction:Function) {
			super();
			this.goldHud = goldHud;

			bg = new Image(Assets.textures[Util.SHOP_BACKGROUND]);
			addChild(bg);

			x = (Util.STAGE_WIDTH - bg.width) / 2;
			y = (Util.STAGE_HEIGHT - bg.height) / 2;

			var closeShopButton:Clickable = new Clickable(0, 0, closeFunction, new TextField(bg.width, 40, "CLOSE SHOP", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			closeShopButton.x = 0;
			closeShopButton.y = height - closeShopButton.height - SHOP_OUTER_PADDING;
			addChild(closeShopButton);

			shopItems = new Array();
			itemCosts = new Array();

			displayCharStats();
			displayShopItems();

			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}

		private function displayCharStats():void {
			hpVal = new TextField(100, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			hpVal.x = width / 5;
			var hpImg:Image = new Image(Assets.textures[Util.ICON_HEALTH]);
			setupStat(hpVal, hpImg);

			atkVal = new TextField(100, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			atkVal.x = width / 5 * 2;
			var atkImg:Image = new Image(Assets.textures[Util.ICON_ATK]);
			setupStat(atkVal, atkImg);

			staminaVal = new TextField(100, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			staminaVal.x = width / 5 * 3;
			var staminaImg:Image = new Image(Assets.textures[Util.ICON_STAMINA]);
			setupStat(staminaVal, staminaImg);

			losVal = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			losVal.x = width / 5 * 4;
			var losImg:Image = new Image(Assets.textures[Util.ICON_LOS]);
			setupStat(losVal, losImg);
		}

		private function setupStat(tf:TextField, i:Image):void {
			tf.height = tf.textBounds.height;
			tf.hAlign = HAlign.LEFT;
			tf.y = SHOP_OUTER_PADDING;
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
			shopItems.push(displayShopItem(0, new Image(Assets.textures[Util.ICON_HEALTH_MED]), "Health", getHpCost(), incHP));
			shopItems.push(displayShopItem(1, new Image(Assets.textures[Util.ICON_ATK_MED]), "Attack", getAttackCost(), incAtk));
			shopItems.push(displayShopItem(2, new Image(Assets.textures[Util.ICON_STAMINA_MED]), "Stamina", getStaminaCost(), incStamina));
			shopItems.push(displayShopItem(3, new Image(Assets.textures[Util.ICON_LOS_MED]), "Line of Sight", getLOSCost(), incLos));

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

		private function displayShopItem(position:int, image:Image, name:String, cost:int, callback:Function):Clickable {
			var item:Clickable = new Clickable(300, 300, callback, null, Assets.textures[Util.SHOP_ITEM]);
			item.addParameter("cost", cost);

			image.x = (item.width - image.width) / 2;
			image.y = 75;
			item.addChild(image);

			item.x = 25 + 130 * position;
			item.y = (height - item.height) / 2;

			var coin:Image = new Image(Assets.textures[Util.ICON_GOLD]);
			coin.y = item.height - coin.height - 2;
			item.addChild(coin);

			var upgrade:TextField = new TextField(item.width, 32, "Upgrade", Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE);
			item.addChild(upgrade);

			var upgradeName:TextField = new TextField(item.width, 32, name, Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE);
			upgradeName.y = 32;
			item.addChild(upgradeName);

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
			if (spend(params["cost"])) {
				setHP(char.maxHp + 1);
				Util.logger.logAction(10, {
					"itemBought":"hpIncrease",
					"newCharacterHP":char.maxHp,
					"upgradeAmount":1,
					"goldSpent":spentGold
				});
			}
		}

		public function incAtk(params:Dictionary):void {
			if (spend(params["cost"])) {
				setAtk(char.attack + 1);
				Util.logger.logAction(10, {
					"itemBought":"attackIncrease",
					"newCharacterAttack":char.attack,
					"upgradeAmount":1,
					"goldSpent":spentGold
				});
			}
		}

		public function incStamina(params:Dictionary):void {
			if (spend(params["cost"])) {
				setStamina(char.maxStamina + 1);
				Util.logger.logAction(10, {
					"itemBought":"staminaIncrease",
					"newCharacterStamina":char.maxStamina,
					"upgradeAmount":1,
					"goldSpent":spentGold
				});
			}
		}

		public function incLos(params:Dictionary):void {
			if (spend(params["cost"])) {
				setLos(char.los + 1);
				Util.logger.logAction(10, {
					"itemBought":"lineOfSight",
					"newCharacterLOS":char.los,
					"upgradeAmount":1,
					"goldSpent":spentGold
				});
			}

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
				spentGold = goldSpent;
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
			char.stamina = char.maxStamina;
			staminaVal.text = String(char.maxStamina);
		}

		private function setLos(val:int):void {
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
		}
	}
}
