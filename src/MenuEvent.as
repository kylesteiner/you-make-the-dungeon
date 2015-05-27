package {
	import starling.events.Event;

	public class MenuEvent extends Event {
		public static const NEW_GAME:String = "new_game";
		public static const CONTINUE_GAME:String = "continue_game";
		public static const CREDITS:String = "credits";
		public static const EXIT:String = "exit";

		public function MenuEvent(type:String, bubbles:Boolean=true) {
			super(type, bubbles);
		}
	}
}
