package {
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.*;
    import starling.textures.Texture;

    public class Clickable extends Sprite {

        public var texture:Texture;
        public var textureImage:Image;
        public var baseImage:DisplayObject;
        public var callback:Function;
        public var parameters:Array;

        public function Clickable(xPos:int,
                                  yPos:int,
                                  action:Function,
                                  baseDisplay:DisplayObject = null,
                                  baseTexture:Texture = null) {
            super();
            x = xPos;
            y = yPos;
            height = Util.STAGE_HEIGHT;
            width = Util.STAGE_WIDTH;
            parameters = new Array();

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
            var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);

            if(!touch) {
                return;
            }

            if(parameters.length > 0) {
                callback(parameters);
            } else {
                callback();
            }
		}

        public function addParameter(param:Object):void {
            parameters.push(param);
        }

    }
}
