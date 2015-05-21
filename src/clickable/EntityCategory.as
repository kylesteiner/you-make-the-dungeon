package clickable {
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class EntityCategory extends Clickable {
		private var index:int;
        private var newValue:int;

		public function EntityCategory(xPos:int,
                                       yPos:int,
                                       onClick:Function,
                                       baseDisplay:DisplayObject,
                                       baseTexture:Texture,
                                       index:int,
                                       newValue:int) {
			super(xPos, yPos, onClick, baseDisplay, baseTexture);
			this.index = index;
            this.newValue = newValue;
		}

		override public function callCallback():void {
            onClick(index, newValue);
		}
	}
}
