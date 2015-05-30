package {
	import starling.events.Event;

	public class TutorialEvent extends Event {
		public static const CLICKED:String = "clicked";
		public var next:TutorialOverlay;

		public function TutorialEvent(type:String,
									  next:TutorialOverlay=null,
									  bubbles:Boolean=false) {
			super(type, bubbles);
			this.next = next;
		}
	}

}
