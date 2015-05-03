package {
	import starling.display.*;
	import starling.textures.*;
	import starling.text.TextField;
	import starling.events.*;

	import Character;
	//import Floor;
	import Tile;
	import Util;

	public class Game extends Sprite {
		public var t:Tile;
		public var textField:TextField;

		public function Game() {
			textField = new TextField(100, 100, "Welcome to Starling!");
			textField.x = 0;
			textField.y = 200;
			addChild(textField);

			t = new Tile(3, 3, new Array(false, false, false, true));
			t.addChild(t.image);
			addChild(t);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(KeyboardEvent.KEY_DOWN, onMouseDown);
		}

		public function onEnterFrame(event:EnterFrameEvent):void {
			return;
		}

		public function onMouseDown(event:KeyboardEvent):void {
			//var touch:Touch = event.getTouch(stage);

			//if(touch && touch.phase == TouchPhase.BEGAN) {
			t.addChild(t.image);
			//}
		}


	}
}
