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
		public static const HP:String = "hp";
		public static const ATTACK:String = "attack";
		public static const STAMINA:String = "stamina";
		public static const LOS:String = "los";
		public static const NUM_ITEMS:int = 4;

		private var charStats:Dictionary; // textfields
		private var shopItems:Dictionary; // clickables
		private var shopPrices:Dictionary; // textfields

		public var char:Character;

		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/

		public function ShopHUD() {
			super();

			var bg:Image = new Image(Assets.textures[Util.SHOP_BACKGROUND]);
			addChild(bg);

			x = Util.STAGE_WIDTH - width;
			y = (Util.STAGE_HEIGHT - height) / 2;

			charStats = new Dictionary();
			shopItems = new Dictionary();
			shopPrices = new Dictionary();

			displayCharStats();
			displayShopItems();

			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}

		private function displayCharStats():void {
			charStats[HP] = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			charStats[HP].y = Util.UI_PADDING / 2;
			var hpImg:Image = new Image(Assets.textures[Util.ICON_HEALTH]);
			setupStat(charStats[HP], hpImg);

			charStats[ATTACK] = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			charStats[ATTACK].y = Util.UI_PADDING / 2 + height / 4;
			var atkImg:Image = new Image(Assets.textures[Util.ICON_ATK]);
			setupStat(charStats[ATTACK], atkImg);

			charStats[STAMINA] = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			charStats[STAMINA].y = Util.UI_PADDING / 2 + height / 2;
			var staminaImg:Image = new Image(Assets.textures[Util.ICON_STAMINA]);
			setupStat(charStats[STAMINA], staminaImg);

			charStats[LOS] = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			charStats[LOS].y = Util.UI_PADDING / 2 + height * 3 / 4;
			var losImg:Image = new Image(Assets.textures[Util.ICON_LOS]);
			setupStat(charStats[LOS], losImg);
		}

		private function setupStat(tf:TextField, i:Image):void {
			tf.height = tf.textBounds.height;
			tf.hAlign = HAlign.LEFT;
			tf.x = 75;
			i.x = tf.x - i.width + Util.UI_PADDING / 2;
			i.y = tf.y + tf.height / 2 - i.height / 2;
			addChild(tf);
			addChild(i);
		}

		private function displayShopItems():void {
			shopItems[HP] = displayShopItem(0, HP, getHpCost());
			shopItems[ATTACK] = displayShopItem(1, ATTACK, getAttackCost());
			shopItems[STAMINA] = displayShopItem(2, STAMINA, getStaminaCost());
			shopItems[LOS] = displayShopItem(3, LOS, getLOSCost());

			for (var item:String in shopItems) {
				addChild(shopItems[item]);
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

		private function displayShopItem(position:int, type:String, cost:int):Clickable {
			var item:Clickable = new Clickable(32, 32, clickUpgrade, null, Assets.textures[Util.SHOP_ITEM]);
			item.addParameter("type", type);
			item.addParameter("cost", cost);
			item.x = Util.UI_PADDING;
			item.y = Util.UI_PADDING + position * (height / 4);

			var base:Sprite = createGoldCost(cost, type);
			base.x = item.x + item.width - base.width * 3 / 4;
			base.y = -4;
			item.addChild(base);

			return item;
		}
		
		private function clickUpgrade(params:Dictionary):void {
			dispatchEvent(new GameEvent(GameEvent.SHOP_SPEND, 0, 0, params));
		}
		
		private function createGoldCost(cost:int, type:String):Sprite {
			var base:Sprite = new Sprite();

			var goldImage:Image = new Image(Assets.textures[Util.ICON_GOLD]);
			var costText:TextField = new TextField(goldImage.width, goldImage.height, cost.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			costText.autoScale = true;
			shopPrices[type] = costText;

			base.addChild(goldImage);
			base.addChild(costText);

			base.touchable = false;

			return base;
		}

		/**********************************************************************************
		 * Stat & Gold management
		 **********************************************************************************/

		public function incStat(type:String, cost:int):void {
			switch(type) {
				case HP:
					setHP(char.maxHp + 1);
					Util.logger.logAction(10, {
						"itemBought":"hpIncrease",
						"newCharacterHP":char.maxHp,
						"upgradeAmount":1,
						"goldSpent":cost
					});
					break;
				case ATTACK:
					setAtk(char.attack + 1);
					Util.logger.logAction(10, {
						"itemBought":"attackIncrease",
						"newCharacterAttack":char.attack,
						"upgradeAmount":1,
						"goldSpent":cost
					});
					break;
				case STAMINA:
					setStamina(char.maxStamina + 1);
					Util.logger.logAction(10, {
						"itemBought":"staminaIncrease",
						"newCharacterStamina":char.maxStamina,
						"upgradeAmount":1,
						"goldSpent":cost
					});
					break;
				case LOS:
					setLos(char.los + 1);
					Util.logger.logAction(10, {
						"itemBought":"lineOfSight",
						"newCharacterLOS":char.los,
						"upgradeAmount":1,
						"goldSpent":cost
					});
					break
			}
		}

		public function setHP(val:int):void {
			char.maxHp = val;
			char.hp = char.maxHp;
			charStats[HP].text = String(char.maxHp);
		}

		public function setAtk(val:int):void {
			char.attack = val;
			charStats[ATTACK].text = String(char.attack);
		}

		public function setStamina(val:int):void {
			char.maxStamina = val;
			char.stamina = char.maxStamina;
			charStats[STAMINA].text = String(char.maxStamina);
		}

		public function setLos(val:int):void {
			char.los = val;
			charStats[STAMINA].text = String(char.los);
			dispatchEvent(new GameEvent(GameEvent.CHARACTER_LOS_CHANGE, 0, 0));
		}

		private function onEnterFrame(event:EnterFrameEvent):void {
			if (!char) {
				return;
			}
			
			var i:int;
			var newCost:int;
			var shopButton:Clickable;
			for (var item:String in shopItems) {
				newCost = getHpCost();
				newCost = item == ATTACK ? getAttackCost() : newCost;
				newCost = item == STAMINA ? getStaminaCost() : newCost;
				newCost = item == LOS ? getLOSCost() : newCost;

				shopItems[item].parameters["cost"] = newCost;
				shopPrices[item].text = String(newCost);
			}
			setHP(char.maxHp);
			setAtk(char.attack);
			setStamina(char.maxStamina);
			setLos(char.los);
		}
	}
}
