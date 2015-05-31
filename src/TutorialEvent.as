package {
	import starling.events.Event;

	public class TutorialEvent extends Event {
		public static const NEXT:String = "tutorial_next";
		public var current:TutorialOverlay;
		public var next:TutorialOverlay;

		public function TutorialEvent(type:String,
									  current:TutorialOverlay,
									  next:TutorialOverlay=null,
									  bubbles:Boolean=true) {
			super(type, bubbles);
			this.current = current;
			this.next = next;
		}
	}

}
