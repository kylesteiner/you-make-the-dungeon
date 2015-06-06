package menu {
	import flash.net.SharedObject;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class Scores extends Sprite {

		public function Scores() {
			super();
			var saveGame:SharedObject = SharedObject.getLocal("saveGame");
			var runScore:TextField = new TextField(120, 100, "Best Run Stats", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			runScore.x = 40;
			runScore.y = 40;
			addChild(runScore);
			// getting all of the stats.
			displayStats(saveGame, "bestRunGoldEarned", "Gold Earned: ", runScore.x - 60, runScore.y + 80);
			displayStats(saveGame, "bestRunDistance", "Distance Traveled: ", runScore.x - 40, runScore.y + 130);
			displayStats(saveGame, "bestRunEnemiesDefeated", "Enemies Defeated: ", runScore.x - 40, runScore.y + 180);

			var overallScore:TextField = new TextField(120, 100, "Overall Stats", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			overallScore.x = Util.STAGE_WIDTH - 240;
			overallScore.y = 40;
			addChild(overallScore);

			// get all the overall stats
			displayStats(saveGame, "overallGoldEarned", "Gold Earned: ", overallScore.x - 80, overallScore.y + 80);
			displayStats(saveGame, "overallDistance", "Distance Traveled: ", overallScore.x - 60, overallScore.y + 130);
			displayStats(saveGame, "overallEnemiesDefeated", "Enemies Defeated: ", overallScore.x - 60, overallScore.y + 180);
			displayStats(saveGame, "overallTilesPlaced", "Tiles Placed: ", overallScore.x - 80, overallScore.y + 230);
			displayStats(saveGame, "overallGoldSpent", "Gold Spent: ", overallScore.x - 80, overallScore.y + 280);
			var startButton:Clickable = new Clickable(256, Util.STAGE_HEIGHT - 80, back, new TextField(128, 40, "BACK", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			addChild(startButton);
		}

		private function displayStats(saveGame:SharedObject, name:String, display:String, x:int, y:int):void {
			var stat:int = getStats(saveGame, name);
			var statText:TextField = new TextField(280, 100, display + stat, Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			statText.x = x;
			statText.y = y;
			addChild(statText);
		}

		private function getStats(saveGame:SharedObject, name:String):int {
			if (saveGame.data[name]) {
				return saveGame.data[name];
			} else  {
				return 0;
			}
		}

		public function back():void {
			dispatchEvent(new MenuEvent(MenuEvent.EXIT));
		}

	}

}
