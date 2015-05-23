package entities {
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;

	// Base class for all Entities. Should not be instantiated.
	public class Entity extends Sprite {
		public static const INFO_MARGIN:int = 8;

		public var grid_x:int;
		public var grid_y:int;
		public var img:Image;
		public var cost:int;
		public var deletable:Boolean; // true if placed by buildHud
		public var overlaySprite:Sprite;

		public function Entity(g_x:int, g_y:int, texture:Texture) {
			super();
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);
			grid_x = g_x;
			grid_y = g_y;

			img = new Image(texture);
			addChild(img);
		}

		public function handleChar(c:Character):void {}

		public function addOverlay():void {
			overlaySprite = generateOverlay();
			addChild(overlaySprite);
		}

		public function generateOverlay():Sprite {
			return new Sprite();
		}

		// Override if the state of the entity needs to be reset between runs.
		public function reset():void {}
	}
}
