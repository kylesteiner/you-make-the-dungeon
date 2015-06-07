package tutorial {
    import starling.display.*;
    import starling.events.*;
    import starling.utils.Color;

    public class TutorialManager extends Sprite {

        private var tutorialQueue:Array;
        private var currentTutorial:DisplayObject;

        public function TutorialManager() {
            tutorialQueue = new Array();

            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
            addEventListener(TouchEvent.Touch, onMouseEvent);
            addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        public function isActive():Boolean {
            return currentTutorial != null;
        }

        public function add(tutorial:DisplayObject):void {
            tutorialQueue.push(tutorial);
        }

        public function openTutorial():void {
            if (isActive()) {
                return;
            }

            currentTutorial = tutorialQueue.shift();
        }

        public function closeTutorial():void {
            removeChild(currentTutorial);
            currentTutorial = null;
        }

        public function onMouseEvent(event:TouchEvent) {
            var touch:Touch = event.getTouch(this);
            if (!isActive() || !touch) {
                return;
            }

            if (touch.phase == TouchPhase.BEGAN) {
                closeTutorial();
            }
        }

        public function onKeyDown(event:KeyboardEvent) {
            if (!isActive()) {
                return;
            }

            closeTutorial();
        }

        public function onEnterFrame(event:EnterFrameEvent) {
            if (!isActive()) {
                openTutorial();
            }
        }

        public static function constructTutorial(tutorialTexture:texture):Sprite {
            var tutorial:Sprite = new Sprite();
            tutorial.addChild(Util.getTransparentQuad());
            tutorial.addChild(new Image(tutorialTexture));
            return tutorial;
        }
    }
}
