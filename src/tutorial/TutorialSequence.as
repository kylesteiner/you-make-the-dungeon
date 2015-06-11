package tutorial {
	import starling.display.Sprite;

	public class TutorialSequence extends Sprite {
		private var current:int;
		private var frames:Array;	// Array of TutorialOverlays
		private var onComplete:Function;

		public function TutorialSequence(onComplete:Function, frames:Array) {
			this.onComplete = onComplete;
			if (frames) {
				this.frames = frames;
			} else {
				this.frames = new Array();
			}
			current = 0;
			addChild(frames[0]);
			addEventListener(TutorialEvent.NEXT, onTutorialClicked);
		}

		public function add(frame:TutorialOverlay):void {
			frames.push(frame);
		}

		public function next():void {
			removeChild(frames[current]);
			current++;
			if (current < frames.length) {
				addChild(frames[current]);
				return;
			}
			onComplete();
		}

		public function onTutorialClicked(e:TutorialEvent):void {
			next();
		}
	}
}
