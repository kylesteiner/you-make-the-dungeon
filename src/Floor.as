// Level.as
// Stores the state of a single floor.

package {
	import flash.display.Sprite;
	import starling.core.Starling;
	import flash.net.*;
	import starling.events.*;
	import starling.textures.*;

	import Util;
	import tiles.*;
	import Character;

	public class Floor extends Sprite {
		// 2D Array of Tiles. Represents the current state of all tiles.
		public var grid:Array;
		public var char:Character;
		public var floorName:String;

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
			resetFloor();
		}

		// Resets the character and grid state to their initial values.
		private function resetFloor():void {
			var i:int; var j:int;
			// Remove all tiles from the display tree.
			for (i = 0; i < grid.length; i++) {
				for (j = 0; j < grid[i].length; j++) {
					// TODO: figure out it it is necessary to dispose of the
					// tile here.
					grid[i][j].removeFromParent();
				}
			}

			// Add all of the initial tiles to the grid and display tree.
			for (i = 0; i < initialGrid.length; i++) {
				for (j = 0; j < initialGrid[i].length; j++) {
					grid[i][j] = initialGrid[i][j];
					addChild(grid[i][j]);
				}
			}

			// TODO: figure out character's starting position.
			//		 ensure old character is no longer being rendered.
			char = new Character(initialX, initialY, initialXp);
		}

		private function constructFloor(loadEvent:Event):void {
			// TODO: ensure loaded file always has correct number of lines
			//		 as well as all necessary data (char, entry, exit).
			// TODO: ensure that each line in loaded file has correct number
			//		 of arguments.
			var i:int; var j:int;

			var floorData:Array = loadEvent.data.split("\n");
			floorName = floorData[0];

			var innerArray:Array;
			var newGrid:Array = new Array();
			var floorSize:Array = floorData[1].split("\t");
			for (i = 0; i < Number(floorSize[1]); i++) {
				innerArray = new Array();
				for (j = 0; j < Number(floorSize[0]); j++) {
					innerArray.append(null);
				}
				newGrid.push(innerArray);
			}

			var characterData:Array = floorData[2].split("\t");
			initialX = Number(characterData[0]);
			initialY = Number(characterData[1]);
			char = new Character(initialX, initialY, initialXp);

			var lineData:Array;
			var initTile:Tile;
			var tX:int; var tY:int;
			var tN:Boolean; var tS:Boolean; var tE:Boolean; var tW:Boolean;
			var tTexture:Texture;
			var tileData:Array = new Array();

			for (i = 2; i < floorData.length; i++) {
				lineData = floorData[i].split("\t");

				tX = Number(lineData[1]);
				tY = Number(lineData[2]);
				tN = (lineData[3] == "1") ? true : false;
				tS = (lineData[4] == "1") ? true : false;
				tE = (lineData[5] == "1") ? true : false;
				tW = (lineData[6] == "1") ? true : false;
				//tTexture = ?

				// TODO: determine type of Tile to instantiate here
				// 		 and add it to tileData
				//initTile = new Tile(tX, tY, tN, tS, tE, tW, tTexture);
			}

			// put tileData's tiles into a grid
			for each (var tile:Tile in tileData) {
				newGrid[tile.grid_y][tile.grid_x] = tile;
			}

			// set that grid to initialGrid
			initialGrid = newGrid;
		}
	}
}
