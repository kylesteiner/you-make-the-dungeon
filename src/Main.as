package {
	import flash.display.Sprite;
	import starling.core.Starling;

	[SWF(width="640", height="480", backgroundColor="#FFFFFF")]

	public class Main extends Sprite {
		private var _starling:Starling;

		public function Main() {
			_starling = new Starling(Game, stage);
			_starling.start();
		}
	}
}
