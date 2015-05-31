package {
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class Credits extends Sprite {
		public function Credits() {
			super();
			var backButton:Clickable = new Clickable(0, 0, back, new TextField(128, Util.MEDIUM_FONT_SIZE*1.5, "BACK", Util.SECONDARY_FONT, Util.MEDIUM_FONT_SIZE));
			backButton.y = 10;
			backButton.x = -20;
			addChild(backButton);

			var forwardButton:Clickable = new Clickable(0, 0, forward, new TextField(128, Util.MEDIUM_FONT_SIZE*1.5, "MORE", Util.SECONDARY_FONT, Util.MEDIUM_FONT_SIZE));
			forwardButton.y = 10;
			forwardButton.x = Util.STAGE_WIDTH - forwardButton.width - 20;
			addChild(forwardButton);

			var leftCredits:String = "";

			leftCredits += "Developers: \nBabak Dabagh\nKyle Steiner\nKing Xia\nEric Zeng\n\n";
			leftCredits += "Major thanks to Louisa Fan for sprite designs + iconography.\n";
			leftCredits += "\tCharacter design\n";
			leftCredits += "\tEnemy design\n";
			leftCredits += "\tTrap design\n";
			leftCredits += "\tIcon design\n";
			leftCredits += "\tKey + Cake design\n";
			leftCredits += "\tCursor design\n";

			var rightCredits:String = "";

			var creditsLineLeft:TextField = new TextField(Util.STAGE_WIDTH / 2, Util.STAGE_HEIGHT - backButton.height, leftCredits, Util.SECONDARY_FONT, Util.SMALL_FONT_SIZE*3 / 4);
			creditsLineLeft.x = 0;
			creditsLineLeft.y = backButton.y + backButton.height;
			creditsLineLeft.autoScale = true;
			creditsLineLeft.hAlign = HAlign.LEFT;
			creditsLineLeft.vAlign = VAlign.TOP;
			addChild(creditsLineLeft);

			var creditsLineRight:TextField = new TextField(Util.STAGE_WIDTH / 2, Util.STAGE_HEIGHT - backButton.height, rightCredits, Util.SECONDARY_FONT, Util.SMALL_FONT_SIZE*3 / 4);
			creditsLineRight.x = creditsLineLeft.x + creditsLineLeft.width;
			creditsLineRight.y = creditsLineLeft.y;
			creditsLineRight.autoScale = true;
			creditsLineRight.hAlign = HAlign.LEFT;
			creditsLineRight.vAlign = VAlign.TOP;
			addChild(creditsLineRight);
		}

		public function back():void {
			dispatchEvent(new MenuEvent(MenuEvent.EXIT));
		}

		public function forward():void {
			dispatchEvent(new MenuEvent(MenuEvent.DETAILED_CREDITS));
		}
	}
}
