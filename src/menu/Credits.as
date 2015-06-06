package menu {
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

			leftCredits += "Produced by \nBabak Dabagh\tEric Zeng\nKing Xia\tKyle Steiner\n\n";

			var rightCredits:String = "";
			rightCredits += "Major thanks to Louisa Fan for sprite designs + iconography.\n";
			rightCredits += "\tCharacter design\n";
			rightCredits += "\tEnemy design\n";
			rightCredits += "\tTrap design\n";
			rightCredits += "\tIcon design\n";
			rightCredits += "\tKey + Cake design\n";
			rightCredits += "\tCursor design\n";

			var creditsLineLeft:TextField = new TextField(Util.STAGE_WIDTH, (Util.STAGE_HEIGHT - backButton.height) / 2, leftCredits, Util.SECONDARY_FONT, Util.LARGE_FONT_SIZE*3);
			creditsLineLeft.x = 0;
			creditsLineLeft.y = backButton.y + backButton.height;
			creditsLineLeft.autoScale = true;
			creditsLineLeft.hAlign = HAlign.CENTER;
			creditsLineLeft.vAlign = VAlign.TOP;
			addChild(creditsLineLeft);

			var creditsLineRight:TextField = new TextField(Util.STAGE_WIDTH, (Util.STAGE_HEIGHT - backButton.height) / 2, rightCredits, Util.SECONDARY_FONT, Util.LARGE_FONT_SIZE);
			creditsLineRight.x = 0;
			creditsLineRight.y = creditsLineLeft.y + creditsLineLeft.height;
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
