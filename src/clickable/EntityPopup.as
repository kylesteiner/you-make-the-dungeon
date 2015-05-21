package clickable {
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class EntityPopup extends Clickable {
		private var index:int;

		public function EntityPopup(xPos:int,
                                    yPos:int,
                                    onClick:Function,
                                    baseDisplay:DisplayObject,
                                    baseTexture:Texture,
                                    index:int) {
			super(xPos, yPos, onClick, baseDisplay, baseTexture);
			this.index = index;
		}

		override public function callCallback():void {
            onClick(index);
		}
	}
}
