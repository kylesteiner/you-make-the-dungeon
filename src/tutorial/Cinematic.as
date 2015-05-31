package tutorial {
    import starling.display.*;
    import starling.events.*;

    import flash.utils.Dictionary;

    public class Cinematic extends Sprite {
        public static const COMMAND_WAIT:String = "command_wait";
        public static const COMMAND_MOVE:String = "command_move";
        public static const COMMAND_NONE:String = "command_none";

        public var timeElapsed:Number;
        public var command:String;
        public var commandArguments:Dictionary;
        public var eventQueue:Array;
        public var speed:int;
        public var iX:int;
        public var iY:int;

        public function Cinematic(startX:int, startY:int, speed:int, commands:Array) {
            super();

            timeElapsed = 0;
            commandArguments = new Dictionary();
            eventQueue = new Array();
            iX = startX;
            iY = startY;
            this.speed = speed;

            var i:int;
            for(i = 0; i < commands.length; i++) {
                addCommand(commands[i]);
            }

            fireNextCommand();

            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
            addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        public function addCommand(newCommand:Dictionary):void {
            eventQueue.push(newCommand);
        }

        public function onEnterFrame(event:EnterFrameEvent):void {
            timeElapsed += event.passedTime;

            if (command == COMMAND_MOVE) {
                var xDirection:int = iX - commandArguments["destX"] < 0 ? 1 : -1;
                var yDirection:int = iY - commandArguments["destY"] < 0 ? 1 : -1;
                var xLen:int = Math.abs(iX - commandArguments["destX"]);
                var yLen:int = Math.abs(iY - commandArguments["destY"]);
                var xMove:int = Math.min(xLen, speed);
                var yMove:int = Math.min(yLen, speed);

                iX += xDirection * xMove;
                iY += yDirection * yMove;

                dispatchEvent(new GameEvent(GameEvent.MOVE_CAMERA, xDirection * xMove, yDirection * yMove));
            }

            if (command == COMMAND_NONE) {
                dispatchEvent(new GameEvent(GameEvent.CINEMATIC_COMPLETE, 0, 0));
            } else if (command == COMMAND_WAIT && timeElapsed > commandArguments["timeToWait"]) {
                fireNextCommand();
            } else if (command == COMMAND_MOVE &&
                       iX == commandArguments["destX"] &&
                       iY == commandArguments["destY"]) {
                fireNextCommand();
            }

        }

        public function onKeyDown(event:KeyboardEvent):void {
            if(event.keyCode == Util.TUTORIAL_SKIP_KEY) {
                dispatchEvent(new GameEvent(GameEvent.CINEMATIC_COMPLETE, 0, 0));
            }
        }

        public function fireNextCommand():void {
            command = COMMAND_NONE;
            timeElapsed = 0;

            if (eventQueue.length == 0) {
                return;
            }

            var nextEvent:Dictionary = eventQueue.shift();
            command = nextEvent["command"];

            commandArguments = new Dictionary();
            commandArguments["timeToWait"] = nextEvent["timeToWait"];
            commandArguments["destX"] = nextEvent["destX"];
            commandArguments["destY"] = nextEvent["destY"];
        }
    }
}
