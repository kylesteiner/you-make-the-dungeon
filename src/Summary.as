package {
	import starling.display.DisplayObject;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class Summary extends Clickable {
		public var amountHealed:int;
		public var damageTaken:int;
		public var distanceTraveled:int;
		public var enemiesDefeated:int;
		public var goldCollected:int;

		public var healedField:TextField;
		public var damageField:TextField;
		public var distanceField:TextField;
		public var enemiesField:TextField;
		public var goldField:TextField;

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

			goldField = new TextField(250, 64, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			goldField.x = 30;
			goldField.y = 30;
			addChild(goldField);

			enemiesField = new TextField(250, 64, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			enemiesField.x = 30;
			enemiesField.y = 94;
			addChild(enemiesField);

			distanceField = new TextField(250, 64, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			distanceField.x = 30;
			distanceField.y = 158;
			addChild(distanceField);

			damageField = new TextField(250, 64, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			damageField.x = 30;
			damageField.y = 222;
			addChild(damageField);

			healedField = new TextField(250, 64, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			healedField.x = 30;
			healedField.y = 286;
			addChild(healedField);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:EnterFrameEvent):void {
			goldField.text = "Gold Collected: " + goldCollected;
			enemiesField.text = "Enemies Defeated: " + enemiesDefeated;
			distanceField.text = "Distance Traveled: " + distanceTraveled;
			damageField.text = "Damage taken: " + damageTaken;
			healedField.text = "Amount Healed: " + amountHealed;
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
