package tutorial {
    import starling.display.*;
    import starling.events.*;
    import starling.utils.Color;
    import starling.textures.Texture;

    public class TutorialManager extends Sprite {

        private var tutorialQueue:Array;
        private var currentTutorial:DisplayObject;

        public function TutorialManager() {
            tutorialQueue = new Array();

            addEventListener(TouchEvent.TOUCH, onMouseEvent);
            addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        }

        public function isActive():Boolean {
            return currentTutorial != null;
        }

        public function addTutorial(tutorial:Texture):void {
            var tutorialSprite:Sprite = new Sprite();
            tutorialSprite.addChild(Util.getTransparentQuad());
            tutorialSprite.addChild(new Image(tutorial));

            tutorialQueue.push(tutorialSprite);
        }

        public function openTutorial():void {
            if (isActive()) {
                return;
            }

            currentTutorial = tutorialQueue.shift();
            addChild(currentTutorial);
        }

        public function closeTutorial():void {
            removeChild(currentTutorial);
            currentTutorial = null;

            dispatchEvent(new TutorialEvent(TutorialEvent.CLOSE_TUTORIAL));
        }

        public function onMouseEvent(event:TouchEvent):void {
            var touch:Touch = event.getTouch(this);
            if (!isActive() || !touch) {
                return;
            }

            if (touch.phase == TouchPhase.BEGAN) {
                closeTutorial();
            }
        }

        public function onKeyDown(event:KeyboardEvent):void {
            if (!isActive()) {
                return;
            }

            closeTutorial();
        }

        public function onEnterFrame():void {
            if (!isActive() && tutorialQueue.length > 0) {
                openTutorial();
            }
        }
    }
}
