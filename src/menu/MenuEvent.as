package menu {
	import starling.events.Event;

	public class MenuEvent extends Event {
		public static const NEW_GAME:String = "new_game";
		public static const CONTINUE_GAME:String = "continue_game";
		public static const CREDITS:String = "credits";
		public static const DETAILED_CREDITS:String = "detailed_credits";
		public static const EXIT:String = "exit";
		public static const SCORES:String = "scores";

		public function MenuEvent(type:String, bubbles:Boolean=true) {
			super(type, bubbles);
		}
	}
}
