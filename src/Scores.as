package {
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class Scores extends Sprite {
		
		public function Scores() {
			super();
			var startButton:Clickable = new Clickable(256, 128, back, new TextField(128, 40, "BACK", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			var creditsLine:TextField = new TextField(384, 256, "SCORES COME HERE", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			creditsLine.x = startButton.x + (startButton.width - creditsLine.width) / 2;
			creditsLine.y = startButton.y + startButton.height;
		}

		public function back():void {
			dispatchEvent(new MenuEvent(MenuEvent.EXIT));
		}
		
	}

}