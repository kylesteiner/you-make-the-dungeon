package clickable {
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchPhase;
    import starling.events.TouchEvent;
    import starling.textures.Texture;

    import flash.utils.Dictionary;

    public class Clickable extends Sprite {

        public var texture:Texture;
        public var textureImage:Image;
        public var baseImage:DisplayObject;
        public var onClick:Function;
        public var parameters:Dictionary;
        public var hasParameters:Boolean;

        public function Clickable(xPos:int,
                                  yPos:int,
                                  onClick:Function,
                                  baseDisplay:DisplayObject = null,
                                  baseTexture:Texture = null) {
            super();
            x = xPos;
            y = yPos;
            height = Util.STAGE_HEIGHT;
            width = Util.STAGE_WIDTH;

            if (baseTexture) {
                texture = baseTexture;
                textureImage = new Image(texture);
                addChild(textureImage);
            }

            if (baseDisplay) {
                baseImage = baseDisplay;
                addChild(baseImage);
            }

            parameters = new Dictionary();

            this.onClick = onClick;

            addEventListener(TouchEvent.TOUCH, onMouseEvent);
        }

        // Override if you need to pass parameters with onClick.
        public function callCallback():void {
            if(!hasParameters) {
                onClick();
            } else {
                onClick(parameters);
            }
        }

        public function addParameter(key:String, data:Object):void {
            hasParameters = true;
            parameters[key] = data;
        }

        private function onMouseEvent(event:TouchEvent):void {
            var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
            if(!touch) {
                return;
            }
            callCallback();
		}
    }
}
