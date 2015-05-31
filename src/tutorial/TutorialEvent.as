package tutorial {
	import starling.events.Event;

	public class TutorialEvent extends Event {
		public static const NEXT:String = "tutorial_next";
		public static const INTRO_COMPLETE:String = "intro_complete";

		public function TutorialEvent(type:String, bubbles:Boolean=true) {
			super(type, bubbles);
		}
	}
}
