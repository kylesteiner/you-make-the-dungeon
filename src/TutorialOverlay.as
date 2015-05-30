package {
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class TutorialOverlay extends Sprite {
		private var next:TutorialOverlay;
		private var texture:Texture;

		public function TutorialOverlay(texture:Texture,
										next:TutorialOverlay=null,
										touchable:Boolean=true) {
			this.texture = texture;
			addChild(texture);

			this.next = next;
			this.touchable = touchable;
		}

		public function onKeyDown(event:KeyboardEvent):void {
            if(timeAccrued < SKIP_DELAY) {
                return;
            }

            if(event.keyCode == Util.TUTORIAL_SKIP_KEY) {
                dispatchEvent(new GameEvent(GameEvent.TUTORIAL_COMPLETE, 0, 0));
            }

            dispatchEvent(new TutorialEvent(TutorialEvent.CLICKED, next));
        }

        public function onMouseDown(event:TouchEvent):void {
            if(timeAccrued < SKIP_DELAY) {
                return;
            }

            var touch:Touch = event.getTouch(this);

            if (touch && touch.phase == TouchPhase.BEGAN) {
				dispatchEvent(new TutorialEvent(TutorialEvent.CLICKED, next));
            }
        }

        public function onEnterFrame(event:EnterFrameEvent):void {
            timeAccrued += event.passedTime;
        }
	}
}
