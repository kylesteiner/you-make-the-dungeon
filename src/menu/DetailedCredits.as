package menu {
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class DetailedCredits extends Sprite {
		public function DetailedCredits() {
			super();
			var backButton:Clickable = new Clickable(0, 0, back, new TextField(128, Util.MEDIUM_FONT_SIZE*1.5, "BACK", Util.SECONDARY_FONT, Util.MEDIUM_FONT_SIZE));
			backButton.y = 10;
			backButton.x = -20;
			addChild(backButton);

			var leftCredits:String = "";
            leftCredits += "Tiles: King Xia\nCoin: JM.Atencia (opengameart)\nFight animation: Freepik (flaticon)\n";
            leftCredits += "BGM Mute/Unmute: yannick (flaticon)\nSFX Mute/Unmute: Freepik (flaticon)\n";
            leftCredits += "Clock icon: Freepik (flaticon)\nBomb: Alucard (opengameart)\nFlame animation: Cuzco (opengameart)\n";
            leftCredits += "Shock animation: Clint Bellanger (opengameart)\nCombat floor: n4pgamer (opengameart)\nBackground: qubodup (opengameart)\n";
            leftCredits += "Chest: Daniel Cook (lostgarden)\nDoor: rubberduck (opengameart)\n";
            leftCredits += "Fonts: Bebas Neue Regular & Fertigo Pro Regular";

            var rightCredits:String = "";
            rightCredits += "BGM: Diving Turtle - PacDV.com\nGentle Thoughts 2 - PacDV.com\n";
            rightCredits += "Glow in the Dark - PacDV.com\nOriental Drift - PacDV.com\nPearl Cavern - Essa (soundcloud)\n";
            rightCredits += "Seven Nation - Scribe / Daniel Stephens (opengameart)\nSnowfall - Kistol/Joseph Gilbert (opengameart)\nWarm Interlude - PacDV.com\n";
            rightCredits += "\nSFX: Floor begin: snottyboy (soundbible)\nFloor complete: Mike Koenig (soundbible)\nTile place: Mark DiAngelo (soundbible)\nTile error: Joe Antares (flashkit)\n";
            rightCredits += "Button press: Deepfrozenapps (soundbible)\nTile remove: Mike Koenig (soundbible)\nCombat success: unknown :(\nCombat failure: Mike Simmons (flashkit)\n";
            rightCredits += "Attack: Vladimir (soundbible)\nCoin collect: Bard Wesson (freesound)\nGold spend: jalastram (opengameart)\nNo gold: artisticdude (opengameart)\n";
            rightCredits += "Chest open: Vitor da Silva Goncalves (opengameart)\nDoor open: artisticdude (opengameart)\n";
            rightCredits += "Basic trap: blastwavesfx (freesfx.co.uk)\nFlame trap: Mike Koenig (soundbible)\nShock trap: gr8sfx (freesfx.co.uk)\n";
			rightCredits += "Stamina heal: artisticdude (opengameart)\nHealing: DoKashiteru (opengameart)";

			var creditsLineLeft:TextField = new TextField(Util.STAGE_WIDTH / 2, Util.STAGE_HEIGHT - backButton.height, leftCredits, Util.SECONDARY_FONT, Util.SMALL_FONT_SIZE*3 / 4);
			creditsLineLeft.x = 0;
			creditsLineLeft.y = backButton.y + backButton.height;
			creditsLineLeft.autoScale = true;
			creditsLineLeft.hAlign = HAlign.LEFT;
			creditsLineLeft.vAlign = VAlign.TOP;
			addChild(creditsLineLeft);

			var creditsLineRight:TextField = new TextField(Util.STAGE_WIDTH / 2, Util.STAGE_HEIGHT, rightCredits, Util.SECONDARY_FONT, Util.SMALL_FONT_SIZE*3 / 4);
			creditsLineRight.x = creditsLineLeft.x + creditsLineLeft.width;
			creditsLineRight.y = 0;
			creditsLineRight.autoScale = true;
			creditsLineRight.hAlign = HAlign.LEFT;
			creditsLineRight.vAlign = VAlign.TOP;
			addChild(creditsLineRight);
		}

		public function back():void {
			dispatchEvent(new MenuEvent(MenuEvent.CREDITS));
		}
	}
}
