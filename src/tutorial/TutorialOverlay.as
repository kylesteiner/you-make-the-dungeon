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
		private var next:TutorialOverlay;
		private var background:DisplayObject;
		private var foreground:DisplayObject;
		private var timeAccrued:Number;

		public function TutorialOverlay(foreground:DisplayObject,
										background:DisplayObject,
										next:TutorialOverlay=null,
										touchable:Boolean=true) {
			this.foreground = foreground;
			this.background = background;
			addChild(background);
			addChild(foreground);

			this.next = next;
			this.touchable = touchable;

			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            addEventListener(TouchEvent.TOUCH, onMouseDown);
            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}

		public function onKeyDown(event:KeyboardEvent):void {
			trace("onKeyDown");
            if(timeAccrued < SKIP_DELAY) {
                return;
            }

            if(event.keyCode == Util.TUTORIAL_SKIP_KEY) {
                dispatchEvent(new GameEvent(GameEvent.TUTORIAL_COMPLETE, 0, 0));
            }

            dispatchEvent(new TutorialEvent(TutorialEvent.NEXT, this, next));
        }

        public function onMouseDown(event:TouchEvent):void {
			trace("onMouseDown");
            if(timeAccrued < SKIP_DELAY) {
                return;
            }

            var touch:Touch = event.getTouch(this);

            if (touch && touch.phase == TouchPhase.BEGAN) {
				trace("onMouseDown: dispatching event");
				dispatchEvent(new TutorialEvent(TutorialEvent.NEXT, this, next));
            }
        }

        public function onEnterFrame(event:EnterFrameEvent):void {
            timeAccrued += event.passedTime;
        }
	}
}
