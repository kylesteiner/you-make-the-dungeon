package tutorial {
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
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

			if (touchable) {
				var click:TextField = new TextField(250, 50,
													"Click anywhere to continue",
													Util.DEFAULT_FONT,
													Util.SMALL_FONT_SIZE);
				click.x = Util.STAGE_WIDTH - 250;
				click.y = Util.STAGE_HEIGHT - 50;
				addChild(click);
			}

            addEventListener(TouchEvent.TOUCH, onMouseDown);
            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
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
