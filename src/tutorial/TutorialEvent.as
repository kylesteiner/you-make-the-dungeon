package tutorial {
	import starling.events.Event;

	public class TutorialEvent extends Event {
		public static const NEXT:String = "tutorial_next";
		public static const INTRO_COMPLETE:String = "intro_complete";

		public static const CLOSE_TUTORIAL:String = "tutorial_close";
		public static const END_RUN:String = "tutorial_end_run";
		public static const REVEAL_ENEMY:String = "tutorial_enemy";
		public static const REVEAL_TRAP:String = "tutorial_trap";

		public function TutorialEvent(type:String, bubbles:Boolean=true) {
			super(type, bubbles);
		}
	}
}
