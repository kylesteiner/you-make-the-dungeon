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

		private var goldCosts:Dictionary;

		public var char:Character;

		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/

		public function ShopHUD() {
			super();

			//var bg:Image = new Image(Assets.textures[Util.SHOP_BACKGROUND]);
			//addChild(bg);

			charStats = new Dictionary();
			shopItems = new Dictionary();
			shopPrices = new Dictionary();
			goldCosts = new Dictionary();

			displayShop();

			//displayStat(0, HP, Assets.textures[Util.ICON_HEALTH], getHpCost());
			//displayStat(1, ATTACK, Assets.textures[Util.ICON_ATK], getAttackCost());
			//displayStat(2, STAMINA, Assets.textures[Util.ICON_STAMINA], getStaminaCost());
			//displayStat(3, LOS, Assets.textures[Util.ICON_LOS], getLOSCost());

			x = Util.STAGE_WIDTH - width - 4;
			y = (Util.STAGE_HEIGHT - height) / 2;

			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}

		private function displayShop():void {
			shopItems[HP] = new Clickable(0, 0, clickUpgrade, null, Assets.textures[Util.HEALTH_PURCHASE]);
			shopItems[HP].addParameter("type", HP);
			shopItems[HP].addParameter("cost", getHpCost());

			shopItems[ATTACK] = new Clickable(0, shopItems[HP].y + shopItems[HP].height, clickUpgrade, null, Assets.textures[Util.ATTACK_PURCHASE]);
			shopItems[ATTACK].addParameter("type", ATTACK);
			shopItems[ATTACK].addParameter("cost", getAttackCost());

			shopItems[STAMINA] = new Clickable(0, shopItems[ATTACK].y + shopItems[ATTACK].height, clickUpgrade, null, Assets.textures[Util.STAMINA_PURCHASE]);
			shopItems[STAMINA].addParameter("type", STAMINA);
			shopItems[STAMINA].addParameter("cost", getStaminaCost());

			shopItems[LOS] = new Clickable(0, shopItems[STAMINA].y + shopItems[STAMINA].height, clickUpgrade, null, Assets.textures[Util.LOS_PURCHASE]);
			shopItems[LOS].addParameter("type", LOS);
			shopItems[LOS].addParameter("cost", getLOSCost());

			charStats[HP] = new TextField(16, Util.SMALL_FONT_SIZE, "0", Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE - 2);
			charStats[HP].x = shopItems[HP].x + shopItems[HP].width - charStats[HP].width;
			charStats[HP].y = shopItems[HP].y + 4;
			charStats[HP].autoScale = true;
			charStats[HP].touchable = false;

			charStats[ATTACK] = new TextField(16, Util.SMALL_FONT_SIZE, "0", Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE - 2);
			charStats[ATTACK].x = shopItems[ATTACK].x + shopItems[ATTACK].width - charStats[ATTACK].width;
			charStats[ATTACK].y = shopItems[ATTACK].y + 4;
			charStats[ATTACK].autoScale = true;
			charStats[ATTACK].touchable = false;

			charStats[STAMINA] = new TextField(16, Util.SMALL_FONT_SIZE, "0", Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE - 2);
			charStats[STAMINA].x = shopItems[STAMINA].x + shopItems[STAMINA].width - charStats[STAMINA].width;
			charStats[STAMINA].y = shopItems[STAMINA].y + 4;
			charStats[STAMINA].autoScale = true;
			charStats[STAMINA].touchable = false;

			charStats[LOS] = new TextField(16, Util.SMALL_FONT_SIZE, "0", Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE - 2);
			charStats[LOS].x = shopItems[LOS].x + shopItems[LOS].width - charStats[LOS].width;
			charStats[LOS].y = shopItems[LOS].y + 4;
			charStats[LOS].autoScale = true;
			charStats[LOS].touchable = false;

			shopPrices[HP] = createGoldCost(getHpCost(), HP);
			shopPrices[HP].x = shopItems[HP].x + 10;
			shopPrices[HP].y = shopItems[HP].y - 4;

			shopPrices[ATTACK] = createGoldCost(getAttackCost(), ATTACK);
			shopPrices[ATTACK].x = shopItems[ATTACK].x + 10;
			shopPrices[ATTACK].y = shopItems[ATTACK].y - 4;

			shopPrices[STAMINA] = createGoldCost(getStaminaCost(), STAMINA);
			shopPrices[STAMINA].x = shopItems[STAMINA].x + 10;
			shopPrices[STAMINA].y = shopItems[STAMINA].y - 4;

			shopPrices[LOS] = createGoldCost(getLOSCost(), LOS);
			shopPrices[LOS].x = shopItems[LOS].x + 10;
			shopPrices[LOS].y = shopItems[LOS].y - 4;

			addChild(shopItems[HP]);
			addChild(shopItems[ATTACK]);
			addChild(shopItems[STAMINA]);
			addChild(shopItems[LOS]);

			addChild(charStats[HP]);
			addChild(charStats[ATTACK]);
			addChild(charStats[STAMINA]);
			addChild(charStats[LOS]);

			addChild(shopPrices[HP]);
			addChild(shopPrices[ATTACK]);
			addChild(shopPrices[STAMINA]);
			addChild(shopPrices[LOS]);
		}

		private function displayStat(position:int, type:String, icon:Texture, cost:int):void {
			// Show stat and icon
			charStats[type] = new TextField(50, 0, "0", Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE);
			charStats[type].y = 9 + height * position / 4;
			setupCharStat(charStats[type], new Image(icon));
			// Show upgrade button
			shopItems[type] = displayShopItem(position, type, cost);
			addChild(shopItems[type]);
		}

		private function setupCharStat(tf:TextField, i:Image):void {
			tf.height = tf.textBounds.height;
			tf.hAlign = HAlign.LEFT;
			tf.x = 75;
			i.x = tf.x - i.width + 4;
			i.y = tf.y + tf.height / 2 - i.height / 2;
			addChild(tf);
			addChild(i);
		}

		private function getHpCost():int {
			var upgrades:int = 0;
			if (char) {
				upgrades = char.maxHp - Util.STARTING_HEALTH;
			}
			return Util.BASE_HP_UPGRADE_COST * (1 + int(upgrades / 5));
		}

		private function getStaminaCost():int {
			var upgrades:int = 0;
			if (char) {
				upgrades = char.maxStamina - Util.STARTING_STAMINA;
			}
			return Util.BASE_STAMINA_UPGRADE_COST * (1 + int(upgrades / 5));
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
			item.x = 8;
			item.y = 8 + position * (height / 4);

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
			//shopPrices[type] = costText;

			base.addChild(goldImage);
			base.addChild(costText);
			base.touchable = false;
			base.scaleX = 0.6;
			base.scaleY = 0.6;

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
			charStats[LOS].text = String(char.los);
			dispatchEvent(new GameEvent(GameEvent.CHARACTER_LOS_CHANGE, 0, 0));
		}

		private function onEnterFrame(event:EnterFrameEvent):void {
			if (!char) {
				return;
			}

			var i:int;
			var newCost:int;
			var shopButton:Clickable;
			var oldCost:Sprite;
			for (var item:String in shopItems) {
				newCost = getHpCost();
				newCost = item == ATTACK ? getAttackCost() : newCost;
				newCost = item == STAMINA ? getStaminaCost() : newCost;
				newCost = item == LOS ? getLOSCost() : newCost;

				shopItems[item].parameters["cost"] = newCost;
				removeChild(shopPrices[item]);
				oldCost = shopPrices[item];
				shopPrices[item] = createGoldCost(newCost, item);
				shopPrices[item].x = oldCost.x;
				shopPrices[item].y = oldCost.y;
				addChild(shopPrices[item]);
			}
			setHP(char.maxHp);
			setAtk(char.attack);
			setStamina(char.maxStamina);
			setLos(char.los);
		}
	}
}
