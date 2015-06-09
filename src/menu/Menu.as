package menu {
	import flash.net.SharedObject;

	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.VAlign;
	import starling.utils.HAlign;

	public class Menu extends Sprite {
		private var saveGame:SharedObject;

		public function Menu(versionID:int,
							 cid:int,
							 bgmMute:Clickable,
							 sfxMute:Clickable) {
			super();
			saveGame = SharedObject.getLocal("saveGame");

			var titleField:TextField = new TextField(Util.STAGE_WIDTH, 80, "You Make The Dungeon", Util.SECONDARY_FONT, Util.LARGE_FONT_SIZE + 8);
			titleField.x = (Util.STAGE_WIDTH / 2) - (titleField.width / 2);
			titleField.y = 16;
			titleField.vAlign = VAlign.TOP;
			addChild(titleField);

			var startField:TextField =
					new TextField(196, 60, "NEW GAME", Util.SECONDARY_FONT, Util.SMALL_FONT_SIZE + 4);
			startField.hAlign = HAlign.LEFT;
			var startButton:Clickable =
					new Clickable(16, Util.STAGE_HEIGHT - 215, newGame, startField, null);
			startButton.addParameter("initHealth", Util.STARTING_HEALTH);
			startButton.addParameter("initStamina", Util.STARTING_STAMINA);
			startButton.addParameter("initAttack", Util.STARTING_ATTACK);
			startButton.addParameter("initLos", Util.STARTING_LOS);
			addChild(startButton);

			var continueField:TextField =
					new TextField(196, 60, "CONTINUE", Util.SECONDARY_FONT, Util.SMALL_FONT_SIZE + 4, saveGame.size != 0 ? 0x000000 : 0x696969);
			continueField.hAlign = HAlign.LEFT;
			var continueButton:Clickable =
					new Clickable(16, Util.STAGE_HEIGHT - 145, continueGame, continueField, null);
			continueButton.addParameter("initHealth", Util.STARTING_HEALTH);
			continueButton.addParameter("initStamina", Util.STARTING_STAMINA);
			continueButton.addParameter("initAttack", Util.STARTING_ATTACK);
			continueButton.addParameter("initLos", Util.STARTING_LOS);
			addChild(continueButton);

			var creditsField:TextField =
					new TextField(196, 60, "CREDITS", Util.SECONDARY_FONT, Util.SMALL_FONT_SIZE + 4)
			creditsField.hAlign = HAlign.LEFT;
			var creditsButton:Clickable = new Clickable(16, Util.STAGE_HEIGHT - 100, openCredits, creditsField);
			addChild(creditsButton);

			var scoresField:TextField =
					new TextField(196, 60, "SCORES", Util.SECONDARY_FONT, Util.SMALL_FONT_SIZE + 4);
			scoresField.hAlign = HAlign.LEFT;
			var scoresButton:Clickable = new Clickable(16, Util.STAGE_HEIGHT - 55, openScores, scoresField);
			addChild(scoresButton);

			var versionString:String = "v " + versionID + "." + cid;
			var version:TextField = new TextField(48, 16, versionString, Util.SECONDARY_FONT, 16);
			version.x = Util.STAGE_WIDTH - version.width - 80;
			version.y = Util.STAGE_HEIGHT - version.height - 8;
			addChild(version);

			addChild(sfxMute);
			addChild(bgmMute);
		}

		public function newGame(params:Object):void {
			saveGame.clear();
			dispatchEvent(new MenuEvent(MenuEvent.NEW_GAME));
		}

		public function continueGame(params:Object):void {
			if (saveGame.size == 0) {
				return;
			}
			dispatchEvent(new MenuEvent(MenuEvent.CONTINUE_GAME));
		}

		public function openCredits():void {
			dispatchEvent(new MenuEvent(MenuEvent.CREDITS));
		}

		public function openScores():void {
			dispatchEvent(new MenuEvent(MenuEvent.SCORES));
		}
	}
}
