package tutorial {
    import starling.display.*;
    import starling.events.*;
    import starling.utils.Color;
    import starling.textures.Texture;

    import flash.utils.Dictionary;

    public class TutorialManager extends Sprite {

        private var tutorialQueue:Array;
        private var currentTutorial:DisplayObject;
        private var skip:Boolean;

        public function TutorialManager() {
            tutorialQueue = new Array();
            skip = true;

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

            var thisDict:Dictionary = new Dictionary();
            thisDict["visual"] = this;

            dispatchEvent(new GameEvent(GameEvent.SURFACE_ELEMENT, 0, 0, thisDict));
        }

        public function closeTutorial():void {
            removeChild(currentTutorial);
            currentTutorial = null;

            dispatchEvent(new TutorialEvent(TutorialEvent.CLOSE_TUTORIAL));
        }

        public function onMouseEvent(event:TouchEvent):void {
            var touch:Touch = event.getTouch(this);
            if (!isActive() || !touch || !skip) {
                return;
            }

            if (touch.phase == TouchPhase.BEGAN) {
                closeTutorial();
            }
        }

        public function onKeyDown(event:KeyboardEvent):void {
            if (!isActive() || !skip) {
                return;
            }

            closeTutorial();
        }

        public function onEnterFrame():void {
            if (!isActive() && tutorialQueue.length > 0) {
                openTutorial();
            }
        }

        public function canSkip(flag:Boolean):void {
            skip = flag;
        }
    }
}
