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
		
		public var reason:String;

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
		private var reasonTextField:TextField;

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
			complete.x = -125;
			complete.y = 24;
			addChild(complete);
			
			best = new TextField(560, 64, "Best So Far", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			best.x = 135;
			best.y = 24;
			addChild(best);

			goldImage = new Image(Assets.textures[Util.ICON_GOLD]);
			goldImage.x = 30;
			goldImage.y = 80;
			addChild(goldImage);

			goldField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			goldField.x = 62;
			goldField.y = 80;
			goldField.hAlign = HAlign.LEFT;
			addChild(goldField);
			
			bestGoldField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			bestGoldField.x = Util.STAGE_WIDTH - 240;
			bestGoldField.y = 80;
			bestGoldField.hAlign = HAlign.LEFT;
			addChild(bestGoldField);

			enemiesImage = new Image(Assets.textures[Util.ICON_ATK]);
			enemiesImage.x = 30;
			enemiesImage.y = 120;
			addChild(enemiesImage);

			enemiesField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			enemiesField.x = 62;
			enemiesField.y = 128;
			enemiesField.hAlign = HAlign.LEFT;
			addChild(enemiesField);
			
			bestEnemiesField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			bestEnemiesField.x = Util.STAGE_WIDTH - 240;
			bestEnemiesField.y = 128;
			bestEnemiesField.hAlign = HAlign.LEFT;
			addChild(bestEnemiesField);

			distanceImage = new Image(Assets.textures[Util.ICON_STAMINA]);
			distanceImage.x = 30;
			distanceImage.y = 176;
			addChild(distanceImage);

			distanceField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			distanceField.x = 62;
			distanceField.y = 176;
			distanceField.hAlign = HAlign.LEFT;
			addChild(distanceField);
			
			bestDistanceField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			bestDistanceField.x = Util.STAGE_WIDTH - 240;
			bestDistanceField.y = 176;
			bestDistanceField.hAlign = HAlign.LEFT;
			addChild(bestDistanceField);

			damageImage = new Image(Assets.textures[Util.ICON_ATK]);
			damageImage.x = 30;
			damageImage.y = 224;
			addChild(damageImage);

			damageField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			damageField.x = 62;
			damageField.y = 224;
			damageField.hAlign = HAlign.LEFT;
			addChild(damageField);

			healImage = new Image(Assets.textures[Util.ICON_HEALTH]);
			healImage.x = 30
			healImage.y = 272;
			addChild(healImage);

			healedField = new TextField(250, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			healedField.x = 62;
			healedField.y = 272;
			healedField.hAlign = HAlign.LEFT;
			addChild(healedField);
			
			reasonTextField = new TextField(500, 48, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			reasonTextField.x = Util.STAGE_WIDTH - 330;
			reasonTextField.y = 248;
			reasonTextField.hAlign = HAlign.LEFT;
			addChild(reasonTextField);

			clickContinue = new TextField(560, 64, "Click to Continue", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			clickContinue.y = 314;
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
			reasonTextField.text = reason;
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
