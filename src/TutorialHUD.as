package {
    import starling.display.*;
    import starling.events.*;
    import starling.utils.Color;

    import flash.utils.Dictionary;

    public class TutorialHUD extends Sprite {
        public static const SKIP_DELAY:Number = 0.2;

        public var tutorialOrder:Array;
        public var tutorialIndex:int;
        public var tutorialImage:Image;
        public var blackQuad:Quad;
        public var timeAccrued:Number;

        private var textures:Dictionary;

        public function TutorialHUD(textureDict:Dictionary) {
            textures = textureDict;

            tutorialIndex = 0;
            tutorialOrder = new Array();
            tutorialOrder.push(Util.TUTORIAL_NEA);
            tutorialOrder.push(Util.TUTORIAL_EXIT);
            tutorialOrder.push(Util.TUTORIAL_GOLD);
            tutorialOrder.push(Util.TUTORIAL_ADVENTURERS);
            tutorialOrder.push(Util.TUTORIAL_SPEND);
            tutorialOrder.push(Util.TUTORIAL_KEYS);
            tutorialOrder.push(Util.TUTORIAL_UI);

            blackQuad = new Quad(Util.STAGE_WIDTH, Util.STAGE_HEIGHT, 0xffffff);
            blackQuad.alpha = 0.7;

            tutorialImage = new Image(textures[tutorialOrder[tutorialIndex]]);

            timeAccrued = 0;

            addChild(blackQuad);
            addChild(tutorialImage);

            addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            addEventListener(TouchEvent.TOUCH, onMouseDown);
            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        }

        public function advanceTutorial():void {
            removeChild(tutorialImage);
            timeAccrued = 0;
            tutorialIndex += 1;
            if(tutorialIndex < tutorialOrder.length) {
                tutorialImage = new Image(textures[tutorialOrder[tutorialIndex]]);
                addChild(tutorialImage);
            } else {
                dispatchEvent(new GameEvent(GameEvent.TUTORIAL_COMPLETE, 0, 0));
            }

        }

        public function onKeyDown(event:KeyboardEvent):void {
            if(timeAccrued < SKIP_DELAY) {
                return;
            }

            advanceTutorial();
        }

        public function onMouseDown(event:TouchEvent):void {
            if(timeAccrued < SKIP_DELAY) {
                return;
            }

            var touch:Touch = event.getTouch(this);

            if (touch && touch.phase == TouchPhase.BEGAN) {
                advanceTutorial();
            }
        }

        public function onEnterFrame(event:EnterFrameEvent):void {
            timeAccrued += event.passedTime;
        }

    }
}
