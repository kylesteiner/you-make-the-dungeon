package {
	import flash.display.Sprite;
	import starling.core.Starling;
	import Level;

	[SWF(width="640", height="480", backgroundColor="#000000")]

	public class Main extends Sprite {
		private var _starling:Starling;

		public function Main() {
			_starling = new Starling(Game, stage);
			_starling.start();
		}
	}

}
