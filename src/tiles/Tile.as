// Tile.as
// Base class for empty tiles. Special tiles will extend this class.
package tiles {
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class Tile extends Sprite {
		public var grid_x:int;
		public var grid_y:int;
		public var north:Boolean;
		public var south:Boolean;
		public var east:Boolean;
		public var west:Boolean;

		public var image:Image;
		public var text:TextField;
		public var textImage:Image;
		public var onGrid:Boolean; // for determining if it is on the grid itself or not
		public var infoWidth:int;
		public var infoHeight:int;

		// Create a new Tile object at position (g_x,g_y) of the grid.
		// If n, s, e, or w is true, that edge of the tile will be passable.
		// texture will be the image used for this tile.
		public function Tile(g_x:int,
							 g_y:int,
							 n:Boolean,
							 s:Boolean,
							 e:Boolean,
							 w:Boolean,
							 texture:Texture) {
			super();
			grid_x = g_x;
			grid_y = g_y;
			north = n;
			south = s;
			east = e;
			west = w;
			infoWidth = 125;
			infoHeight = 125;

			image = new Image(texture);
			addChild(image);

			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);

			displayInformation();
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
		}

		// Called when the player moves into this tile. Override this function
		// to define interactions between tiles and characters.
		public function handleChar(c:Character):void {}

		// When the floor is reset, this function will be called on every tile.
		// Override this function if the tile's state changes during gameplay.
		public function reset():void {}

		// when the user hovers over a tile, a small box will appear with the
		// information for that tile.
		public function displayInformation():void {
			setUpInfo("Empty Tile\nNothing Dangerous Here");
		}

		public function updateInfoPosition():void {
			if (text && textImage) {
				if (!onGrid) {
					text.x = getToPointX(Util.STAGE_WIDTH - infoWidth);
					text.y = getToPointY(0);
					textImage.x = getToPointX(Util.STAGE_WIDTH - infoWidth);
					textImage.y = getToPointY(0);
				} else if (parent && parent.parent) {
					text.x = getToPointX(Util.STAGE_WIDTH - infoWidth - parent.parent.x);
					text.y = getToPointY(0 - parent.parent.y);
					textImage.x = getToPointX(Util.STAGE_WIDTH - infoWidth - parent.parent.x);
					textImage.y = getToPointY(0 - parent.parent.y);
				}
			}
		}

		public function showInfo():void {
			if (parent && parent.parent) {
				parent.parent.addChild(textImage);
				parent.parent.addChild(text);
			}
		}

		public function removeInfo():void {
			if (parent && parent.parent) {
				parent.parent.removeChild(text);
				parent.parent.removeChild(textImage);
			}
		}

		private function onMouseEvent(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);

			if (!touch) {
				if (touch && onGrid) {
					updateInfoPosition();
					showInfo();
				} else {
					removeInfo();
				}
				return;
			}

			if (touch.phase == TouchPhase.HOVER) {
				// display text here;
				text.visible = true;
				updateInfoPosition();
				showInfo();
			}
		}

		// function to be inhereted that sets up the text field information
		// with the given string.
		protected function setUpInfo(info:String):void {
			textImage = new Image(Texture.fromColor(infoWidth, infoHeight, 0xffffffff));
			text = new TextField(infoWidth, infoHeight, info, "Bebas", 18, Color.BLACK);
			text.name = "infoText";
			textImage.name = "infoImage";
			text.border = true;
			updateInfoPosition();
		}

		// helps get the x offset for the tile info set to display
		// in the upper right corner
		public function getToPointX(goal:int):int {
			var temp:int = 0;
			var shift:int = goal > 0 ? 1 : -1;
			while (temp != goal) {
				temp += shift;
			}
			return temp;
		}

		// helps get the y offset for the tile info set to display
		// in the upper right corner
		public function getToPointY(goal:int):int {
			var temp:int = 0;
			var shift:int = goal > 0 ? 1 : -1;
			while (temp != goal) {
				temp += shift;
			}
			return temp;
		}
	}
}
