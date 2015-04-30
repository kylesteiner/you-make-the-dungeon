package {
	import flash.display.Sprite;
	import starling.core.Starling;
	
	[SWF(width="370", height="280", backgroundColor="#ffffff")]
	public class Main extends Sprite {
		private var _starling:Starling;
		
		public function Main() {
			_starling = new Starling(Game, stage);
			_starling.start();
		}
	}

}