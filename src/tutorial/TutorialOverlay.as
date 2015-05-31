package tutorial {
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class TutorialOverlay extends Sprite {
		public static const SKIP_DELAY:Number = 0.2;
		private var background:DisplayObject;
		private var foreground:DisplayObject;
		private var timeAccrued:Number;

		public function TutorialOverlay(foreground:DisplayObject,
										background:DisplayObject,
										touchable:Boolean=true) {
			this.foreground = foreground;
			this.background = background;
			addChild(background);
			addChild(foreground);

			this.touchable = touchable;

			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            addEventListener(TouchEvent.TOUCH, onMouseDown);
            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}

		public function onKeyDown(event:KeyboardEvent):void {
            if (timeAccrued < SKIP_DELAY) {
                return;
            }

			// Only allow keyboard skipping if the tutorial is also touchable.
			if (touchable) {
            	dispatchEvent(new TutorialEvent(TutorialEvent.NEXT));
			}
        }

        public function onMouseDown(event:TouchEvent):void {
            if (timeAccrued < SKIP_DELAY) {
                return;
            }

            var touch:Touch = event.getTouch(this);

            if (touch && touch.phase == TouchPhase.BEGAN) {
				trace("onMouseDown: dispatching event");
				dispatchEvent(new TutorialEvent(TutorialEvent.NEXT));
            }
        }

        public function onEnterFrame(event:EnterFrameEvent):void {
            timeAccrued += event.passedTime;
        }
	}
}
