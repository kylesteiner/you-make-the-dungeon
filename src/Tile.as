//Tile.as
//Superclass for all tiles within the game.
//Should never be instantiated.

package {
	import flash.display.Sprite;
	import starling.core.Starling;
	import Util;
	
	public class Tile extends Sprite {
		public var grid_x:int;
		public var grid_y:int;
		public var north:Boolean;
		public var south:Boolean;
		public var east:Boolean;
		public var west:Boolean;
	
		private var _starling:Starling;
		
		//Create a new Tile object with grid x/y positions, and openings
		//edges should be an array of 4 Booleans representing
		//the directions that the tile could have opening for.
		//
		//Requires edges is not null and that it has exactly 4 items
		public function Tile(g_x:int, g_y:int, edges:Array) {
			//super(Util.grid_to_real(g_x), Util.grid_to_real(g_y));
			assert(edges != null);
			assert(edges.length == 4);
			super();
			grid_x = g_x;
			grid_y = g_y;
			north = edges[Util.NORTH];
			south = edges[Util.SOUTH];
			east = edges[Util.EAST];
			west = edges[Util.WEST];
		}
		
		//Process the character moving through this tile.
		//
		//Requires that c is not null
		public function on_entry(c:Character):void {
			assert(c != null);
			return;
		}
	}
}