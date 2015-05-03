package {
	import starling.display.Sprite;
	import starling.text.TextField;

	import Character;
	//import Floor;
	import Tile;
	import Util;

	[SWF(width="640", height="480", backgroundColor="#000000")]

	public class Game extends Sprite
	{
		public function Game()
		{
			var textField:TextField = new TextField(100, 100, "Welcome to Starling!");
			textField.x = 0;
			textField.y = 200;
			addChild(textField);

			//var t:Tile = new Tile(3, 3, new Array(false, false, false, true));
			//addChild(t);
		}


	}
}
