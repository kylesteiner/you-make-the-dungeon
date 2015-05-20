package clickable {
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchPhase;
    import starling.events.TouchEvent;
    import starling.textures.Texture;

    public class Clickable extends Sprite {

        public var texture:Texture;
        public var textureImage:Image;
        public var baseImage:DisplayObject;
        public var onClick:Function;

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

            if (baseDisplay) {
                baseImage = baseDisplay;
                addChild(baseImage);
            }

            if (baseTexture) {
                texture = baseTexture;
                textureImage = new Image(texture);
                addChild(textureImage);
            }

            this.onClick = onClick;
            addEventListener(TouchEvent.TOUCH, onMouseEvent);
        }

        // Override if you need to pass parameters with onClick.
        public function callCallback():void {
            onClick();
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
