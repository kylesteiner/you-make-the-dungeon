package {
	import org.flixel.*;

	[SWF(width="370", height="280", backgroundColor="#ffffff")]
	
	public class Main extends FlxGame {
		
		public function Main() {
			super(370, 280, MenuState);
		}	
	}
}