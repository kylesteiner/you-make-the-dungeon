package {
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class Summary extends Clickable {
		public var amountHealed:int;
		public var damageTaken:int;
		public var distanceTraveled:int;
		public var enemiesDefeated:int;
		public var goldCollected:int;
		
		public var bestGold:int;
		public var bestDistance:int;
		public var bestEnemies:int;

		private var complete:TextField;
		private var best:TextField;
		private var clickContinue:TextField;
		private var healedField:TextField;
		private var damageField:TextField;
		private var distanceField:TextField;
		private var enemiesField:TextField;
		private var goldField:TextField;
		private var bestGoldField:TextField;
		private var bestDistanceField:TextField;
		private var bestEnemiesField:TextField;

		private var healImage:Image;
		private var damageImage:Image;
		private var distanceImage:Image;
		private var enemiesImage:Image;
		private var goldImage:Image;

		public function Summary(xPos:int,
                                yPos:int,
                                onClick:Function,
                                baseDisplay:DisplayObject = null,
                                baseTexture:Texture = null) {
			super(xPos, yPos, onClick, baseDisplay, baseTexture);

			amountHealed = 0;
			damageTaken = 0;
			distanceTraveled = 0;
			enemiesDefeated = 0;
			goldCollected = 0;

			complete = new TextField(560, 64, "Run Completed", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			complete.x = -135;
			addChild(complete);
			
			best = new TextField(560, 64, "Best So Far", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			best.x = 135;
			addChild(best);

			goldImage = new Image(Assets.textures[Util.ICON_GOLD]);
			goldImage.x = 30;
			goldImage.y = 64;
			addChild(goldImage);

			goldField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			goldField.x = 62;
			goldField.y = 64;
			goldField.hAlign = HAlign.LEFT;
			addChild(goldField);
			
			bestGoldField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			bestGoldField.x = Util.STAGE_WIDTH - 240;
			bestGoldField.y = 64;
			bestGoldField.hAlign = HAlign.LEFT;
			addChild(bestGoldField);

			enemiesImage = new Image(Assets.textures[Util.ICON_ATK]);
			enemiesImage.x = 30;
			enemiesImage.y = 112;
			addChild(enemiesImage);

			enemiesField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			enemiesField.x = 62;
			enemiesField.y = 112;
			enemiesField.hAlign = HAlign.LEFT;
			addChild(enemiesField);
			
			bestEnemiesField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			bestEnemiesField.x = Util.STAGE_WIDTH - 240;
			bestEnemiesField.y = 112;
			bestEnemiesField.hAlign = HAlign.LEFT;
			addChild(bestEnemiesField);

			distanceImage = new Image(Assets.textures[Util.ICON_STAMINA]);
			distanceImage.x = 30;
			distanceImage.y = 160;
			addChild(distanceImage);

			distanceField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			distanceField.x = 62;
			distanceField.y = 160;
			distanceField.hAlign = HAlign.LEFT;
			addChild(distanceField);
			
			bestDistanceField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			bestDistanceField.x = Util.STAGE_WIDTH - 240;
			bestDistanceField.y = 160;
			bestDistanceField.hAlign = HAlign.LEFT;
			addChild(bestDistanceField);

			damageImage = new Image(Assets.textures[Util.ICON_ATK]);
			damageImage.x = 30;
			damageImage.y = 208;
			addChild(damageImage);

			damageField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			damageField.x = 62;
			damageField.y = 208;
			damageField.hAlign = HAlign.LEFT;
			addChild(damageField);

			healImage = new Image(Assets.textures[Util.ICON_HEALTH]);
			healImage.x = 30
			healImage.y = 256;
			addChild(healImage);

			healedField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			healedField.x = 62;
			healedField.y = 256;
			healedField.hAlign = HAlign.LEFT;
			addChild(healedField);

			clickContinue = new TextField(560, 64, "Click to Continue", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			clickContinue.y = 304;
			addChild(clickContinue);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:EnterFrameEvent):void {
			goldField.text = "Gold Collected: " + goldCollected;
			enemiesField.text = "Enemies Defeated: " + enemiesDefeated;
			distanceField.text = "Distance Traveled: " + distanceTraveled;
			damageField.text = "Damage taken: " + damageTaken;
			healedField.text = "Amount Healed: " + amountHealed;
			bestGoldField.text = "" + Math.max(bestGold, goldCollected);
			bestDistanceField.text = "" + Math.max(distanceTraveled, bestDistance);
			bestEnemiesField.text = "" + Math.max(enemiesDefeated, bestEnemies);
		}

		public function reset():void {
			amountHealed = 0;
			damageTaken = 0;
			distanceTraveled = 0;
			enemiesDefeated = 0;
			goldCollected = 0;
		}
	}
}
