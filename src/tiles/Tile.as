// Tile.as
// Base class for empty tiles. Special tiles will extend this class.
package tiles {
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
		public var held:Boolean;

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
			
			image = new Image(texture);
			addChild(image);

			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);
			
			locked = true;
			held = false;
			
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
		}

		// Called when the player moves into this tile. Override this function
		// to define interactions between tiles and characters.
		public function handleChar(c:Character):void {}

		// When the floor is reset, this function will be called on every tile.
		// Override this function if the tile's state changes during gameplay.
		public function reset():void { }
		
		// Realigns the selected tile from the tile HUD on the Floor.
		public function positionTileOnGrid():void {
			//need to test that it is a legal position
			//snap to function should be better than
			x = Util.grid_to_real(Util.real_to_grid(x + 16));
			y = Util.grid_to_real(Util.real_to_grid(y + 16));
			checkGameBounds();
			grid_x = Util.real_to_grid(x + 16);
			grid_y = Util.real_to_grid(y + 16);
			locked = true;
		}
		
		private function onMouseEvent(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			
			if (!touch || locked) {
				return;
			}
			
			if (held) {
				x += touch.globalX - touch.previousGlobalX;
				y += touch.globalY - touch.previousGlobalY;
				checkGameBounds();
				grid_x = Util.real_to_grid(x + 16);
				grid_y = Util.real_to_grid(y + 16);
			}

			if (touch.phase == TouchPhase.BEGAN) {
				held = true;
			}
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
	}
}
