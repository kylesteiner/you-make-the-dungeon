// Tile.as
// Base class for empty tiles. Special tiles will extend this class.
package tiles {
	import flash.text.TextFormat;
	import starling.text.TextField;
	import starling.utils.Color
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.events.*;

	import Character;
	import Util;

	public class Tile extends Sprite {
		public var grid_x:int;
		public var grid_y:int;
		public var north:Boolean;
		public var south:Boolean;
		public var east:Boolean;
		public var west:Boolean;

		public var image:Image;
		public var locked:Boolean;
		public var selected:Boolean;
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

			locked = true;
			selected = false;

			displayInformation();
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
		}

		// Called when the player moves into this tile. Override this function
		// to define interactions between tiles and characters.
		public function handleChar(c:Character):void {
			dispatchEvent(new TileEvent(TileEvent.CHAR_HANDLED,
										Util.real_to_grid(x),
										Util.real_to_grid(y)));
		}

		// When the floor is reset, this function will be called on every tile.
		// Override this function if the tile's state changes during gameplay.
		public function reset():void { }

		// when the user hovers over a tile, a small box will appear with the
		// information for that tile.
		public function displayInformation():void {
			setUpInfo("Empty Tile\nNothing Dangerous Here");
		}

		// Realigns the selected tile from the tile HUD on the Floor.
		public function positionTileOnGrid(worldX:int, worldY:int):void {
			//need to test that it is a legal position
			//snap to function should be better than
			x = Util.grid_to_real(Util.real_to_grid(x - worldX + Util.PIXELS_PER_TILE / 2));
			y = Util.grid_to_real(Util.real_to_grid(y - worldY + Util.PIXELS_PER_TILE / 2));
			checkGameBounds();
			grid_x = Util.real_to_grid(x - worldX + Util.PIXELS_PER_TILE / 2);
			grid_y = Util.real_to_grid(y - worldY + Util.PIXELS_PER_TILE / 2);
			locked = true;
		}
		
		public function updateInfoPosition():void {
			text.x = getToPointX();
			text.y = getToPointY();
			textImage.x = getToPointX();
			textImage.y = getToPointY();
			if (onGrid) {
				trace(parent.parent);
				text.x -= parent.parent.x;
				text.y -= parent.parent.y;
				textImage.x -= parent.parent.x;
				textImage.y -= parent.parent.y;
			}
		}
		

		// Moves the tiles to the given touch location (for tile selection)
		public function moveToTouch(touch:Touch, worldX:int, worldY:int):void {
			if (selected) {
				x += touch.globalX - touch.previousGlobalX;
				y += touch.globalY - touch.previousGlobalY;
				checkGameBounds();
				grid_x = Util.real_to_grid(x - worldX + Util.PIXELS_PER_TILE / 2);
				grid_y = Util.real_to_grid(y - worldY + Util.PIXELS_PER_TILE / 2);
			}
		}

		private function onMouseEvent(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);

			if (!touch || locked) {
				if (touch && onGrid) {
					updateInfoPosition();
					addChild(textImage);
					addChild(text);
				} else {
					removeChild(text);
					removeChild(textImage);
				}
				return;
			}

			if (!selected) {
				updateInfoPosition();
			} else {
				removeChild(text);
				removeChild(textImage);
			}

			if (touch.phase == TouchPhase.HOVER) {
				// display text here;
				text.visible = true;
				updateInfoPosition();
				addChild(textImage);
				addChild(text);
			}

			if (touch.phase == TouchPhase.ENDED) {
				selected = true;
			}
		}

		// function to be inhereted that sets up the text field information
		// with the given string.
		protected function setUpInfo(info:String):void {
			textImage = new Image(Texture.fromColor(infoWidth, infoHeight, 0xffffffff));
			text = new TextField(infoWidth, infoHeight, info, "Bebas", 18, Color.BLACK);
			text.border = true;
			textImage.x = getToPointX();
			textImage.y = getToPointY();
			text.x = getToPointX();
			text.y = getToPointY();
		}

		private function checkGameBounds():void {
			if(x < 0) {
				x = 0;
			}

			if(x > Util.STAGE_WIDTH - Util.PIXELS_PER_TILE) {
				x = Util.STAGE_WIDTH - Util.PIXELS_PER_TILE;
			}

			if(y < 0) {
				y = 0;
			}

			if(y > Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE) {
				y = Util.STAGE_HEIGHT - Util.PIXELS_PER_TILE;
			}
		}

		// helps get the x offset for the tile info set to display
		// in the upper right corner
		public function getToPointX():int {
			var goal:int = Util.STAGE_WIDTH - infoWidth;
			var temp:int = 0;
			while (x + temp != goal) {
				temp++;
			}
			return temp;
		}

		// helps get the y offset for the tile info set to display
		// in the upper right corner
		public function getToPointY():int {
			var goal:int = 0;
			var temp:int = 0;
			while (y + temp != goal) {
				temp--;
			}
			return temp;
		}
	}
}
