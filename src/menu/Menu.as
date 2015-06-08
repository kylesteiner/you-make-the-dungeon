package menu {
	import flash.net.SharedObject;

	import starling.display.Sprite;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.utils.VAlign;

	public class Menu extends Sprite {
		private var saveGame:SharedObject;

		public function Menu(versionID:int,
							 cid:int,
							 bgmMute:Clickable,
							 sfxMute:Clickable) {
			super();
			saveGame = SharedObject.getLocal("saveGame");

			addChild(new Image(Assets.textures[Util.MENU_BACKGROUND]));

			var titleField:TextField = new TextField(Util.STAGE_WIDTH, 120, "You Make The Dungeon", Util.SECONDARY_FONT, Util.LARGE_FONT_SIZE);
			titleField.x = (Util.STAGE_WIDTH / 2) - (titleField.width / 2);
			titleField.y = 32 + titleField.height / 2;
			titleField.vAlign = VAlign.TOP;
			addChild(titleField);

			var startField:TextField =
					new TextField(128, 40, "START", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			var startButton:Clickable =
					new Clickable(256, 192, newGame, startField, null);
			startButton.addParameter("initHealth", Util.STARTING_HEALTH);
			startButton.addParameter("initStamina", Util.STARTING_STAMINA);
			startButton.addParameter("initAttack", Util.STARTING_ATTACK);
			startButton.addParameter("initLos", Util.STARTING_LOS);
			addChild(startButton);

			var continueField:TextField =
					new TextField(128, 40, "CONTINUE", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE, saveGame.size != 0 ? 0x000000 : 0x696969);
			var continueButton:Clickable =
					new Clickable(256, 256, continueGame, continueField, null);
			continueButton.addParameter("initHealth", Util.STARTING_HEALTH);
			continueButton.addParameter("initStamina", Util.STARTING_STAMINA);
			continueButton.addParameter("initAttack", Util.STARTING_ATTACK);
			continueButton.addParameter("initLos", Util.STARTING_LOS);
			addChild(continueButton);

			var creditsField:TextField =
					new TextField(128, 40, "CREDITS", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE)
			var creditsButton:Clickable = new Clickable(256, 320, openCredits, creditsField);
			addChild(creditsButton);

			var scoresField:TextField =
					new TextField(128, 40, "SCORES", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			var scoresButton:Clickable = new Clickable(256, 384, openScores, scoresField);
			addChild(scoresButton);

			var versionString:String = "v " + versionID + "." + cid;
			var version:TextField = new TextField(48, 16, versionString, Util.DEFAULT_FONT, 16);
			version.x = 4;
			version.y = Util.STAGE_HEIGHT - version.height - 4;
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
