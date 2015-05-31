package {
	import starling.display.Sprite;
	import starling.text.TextField;

	public class Credits extends Sprite {
		public function Credits() {
			super();
			var backButton:Clickable = new Clickable(256, 128, back, new TextField(128, 40, "BACK", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			addChild(backButton);
			var creditsLine:TextField = new TextField(384, 256, "THANKS TO LOUISA FAN FOR THE GAME ART.\nWe'll get the other sources later.", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
			creditsLine.x = backButton.x + (backButton.width - creditsLine.width) / 2;
			creditsLine.y = backButton.y + backButton.height;
			addChild(creditsLine);
		}

		public function back():void {
			dispatchEvent(new MenuEvent(MenuEvent.EXIT));
		}
	}
}
