package {
    import starling.display.*;
    import starling.events.*;
    import starling.textures.*;

    public class Clickable extends Sprite {

        public var texture:Texture;
        public var textureImage:Image;
        public var baseImage:DisplayObject;
        public var callback:Function;
        public var parameter:Object;

        public function Clickable(xPos:int, yPos:int, action:Function, baseDisplay:DisplayObject = null, baseTexture:Texture = null) {
                super();
                x = xPos;
                y = yPos;
                height = 480;
                width = 640;
                parameter = null;

                if(baseDisplay) {
                    baseImage = baseDisplay;
                    addChild(baseImage);
                }

                if(baseTexture) {
                    texture = baseTexture;
                    textureImage = new Image(texture);
                    addChild(textureImage);
                }

                callback = action;

                addEventListener(TouchEvent.TOUCH, onMouseEvent);
        }

        private function onMouseEvent(event:TouchEvent):void {
			var touch:Touch = event.getTouch(stage);

            if(touch.phase == TouchPhase.BEGAN) {
                if(parameter) {
                    callback(parameter);
                } else {
                    callback();
                }
            }
		}

        public function addParameter(param:Object):void {
            parameter = param;
        }

    }
}
