// Level.as
// Stores the state of a single floor.

package {
	import flash.display.Sprite;
	import starling.core.Starling;
	import flash.net.*;

	import Util;
	import Tile;
	import Character;

	public class Floor extends Sprite {
		// 2D Array of Tiles. Represents the current state of all tiles.
		public var grid:Array;
		public var char:Character;

		private var initialGrid:Array;
		private var initialXp:int;
		// Character initial (x, y)
		// Could also say that initial x, y is determined by the
		// first entry tile.
		private var initialX:int;
		private var initialY:int;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Floor(floorData:String, xp:int) {
			super();

			initialXp = xp;

			var readFrom:URLRequest = new URLRequest(floorData);
			var floorLoader:URLLoader = new URLLoader();
			floorLoader.load(readFrom);
			floorLoader.addEventListener(Event.COMPLETE, constructFloor);

			grid = new Array(initialGrid.length);
			resetGrid();
		}

		// Resets the character and grid state to their initial values.
		private function resetFloor():void {
			// Remove all tiles from the display tree.
			for (var i:int = 0; i < grid.length; i++) {
				for (var j:int = 0; j < grid[i].length; j++) {
					// TODO: figure out it it is necessary to dispose of the
					// tile here.
					grid[i][j].removeFromParent();
				}
			}

			// Add all of the initial tiles to the grid and display tree.
			for (var i:int = 0; i < initialGrid.length; i++) {
				for (var j:int = 0; j < initialGrid[i].length; j++) {
					grid[i][j] = initialGrid[i][j];
					addChild(grid[i][j]);
				}
			}

			// TODO: figure out character's starting position.
			char = new Character(0, 0, initialXp);
		}

		private function constructFloor(loadEvent:Event):void {
			// TODO: ensure loaded file always has correct number of lines
			//		 as well as all necessary data (char, entry, exit).
			var floorData:Array = loadEvent.target.data.split("\n");
			var name:String = floorData[0];
			var characterData:Array = floorData[1].split("\t");
			initialX = characterData[0];
			initialY = characterData[1];
			char = new Character(initialX, initialY, initialXp);

			var lineData:Array;
			var initTile:Tile;
			var tX:int; var tY:int;
			var tN:Boolean; var tS:Boolean; var tE:Boolean; var tW:Boolean;
			var tTexture:Texture;
			var tileData:Array = new Array();

			for (var i:int = 2; i < floorData.length; i++) {
				lineData = line.split("\t");
				// TODO: determine type of Tile to instantiate here
				// 		 and add it to tileData
			}

			// TODO: put tileData's tiles into a grid
			var newGrid:Array = new Array();
			// TODO: set that grid to initialGrid
			initialGrid = newGrid;
		}
	}
}
