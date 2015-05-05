// Floor.as
// Stores the state of a single floor.

package {
	import flash.display.Sprite;
	import starling.core.Starling;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;

	import Util;
	import tiles.*;
	import Character;

	public class Floor extends Sprite {
		// Number of lines at the beginning of floordata files
		// that are dedicated to non-tile objects at the start
		public static const NON_TILE_LINES:int = 3;

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

		private var tileTextures:Dictionary;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Floor(floorData:ByteArray, textureDict:Dictionary, xp:int) {
			super();

			initialXp = xp;
			tileTextures = textureDict;

			constructFloor(floorData);

			grid = new Array(initialGrid.length);
			//constructInitialGrid();
			resetFloor();
			//resetFloor();
		}

		// Resets the character and grid state to their initial values.
		private function resetFloor():void {
			var i:int; var j:int;

			// Remove all tiles from the display tree.
			for (i = 0; i < grid.length; i++) {
				for (j = 0; j < grid[i].length; j++) {
					// TODO: figure out it it is necessary to dispose of the
					// tile here.
					if(grid[i][j]) {
						grid[i][j].removeFromParent();
					}
				}
			}

			// Add all of the initial tiles to the grid and display tree.
			for (i = 0; i < initialGrid.length; i++) {
				for (j = 0; j < initialGrid[i].length; j++) {
					grid[i][j] = initialGrid[i][j];
					if(grid[i][j]) {
						addChild(grid[i][j]);
					}
				}
			}

			// TODO: figure out character's starting position.
			//		 ensure old character is no longer being rendered.
			char = new Character(initialX, initialY, initialXp);
		}

		private function constructInitialGrid():void {
			grid = new Array();
			var i:int; var j:int;
			for(i = 0; i < initialGrid.length; i++) {
				grid.push(new Array());
				for(j = 0; j < initialGrid[i]; j++) {
					grid[i].push(null);
				}
			}
		}

		//private function constructFloor(loadEvent:Event):void {
		private function constructFloor(floorDataBytes:ByteArray):void {
			// TODO: ensure loaded file always has correct number of lines
			//		 as well as all necessary data (char, entry, exit).
			// TODO: ensure that each line in loaded file has correct number
			//		 of arguments.
			var i:int; var j:int;

			//var floorData:Array = loadEvent.data.split("\n");
			var floorDataString:String = floorDataBytes.readUTFBytes(floorDataBytes.length);
			var floorData:Array = floorDataString.split("\n");
			floorName = floorData[0];

			var innerArray:Array;
			var newGrid:Array = new Array();
			var floorSize:Array = floorData[1].split("\t");
			for (i = 0; i < Number(floorSize[1]); i++) {
				innerArray = new Array();
				for (j = 0; j < Number(floorSize[0]); j++) {
					innerArray.push(null);
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
			var textureString:String;
			var tTexture:Texture;
			var tileData:Array = new Array();

			for (i = NON_TILE_LINES; i < floorData.length; i++) {
				lineData = floorData[i].split("\t");

				tX = Number(lineData[1]);
				tY = Number(lineData[2]);
				tN = (lineData[3] == "1") ? true : false;
				tS = (lineData[4] == "1") ? true : false;
				tE = (lineData[5] == "1") ? true : false;
				tW = (lineData[6] == "1") ? true : false;
				textureString = "tile_" + (tN ? "n" : "") + (tS ? "s" : "") + (tE ? "e" : "") + (tW ? "w" : "");
				textureString += (!tN && !tS && !tE && !tW) ? "none" : "";
				tTexture = tileTextures[textureString];

				// TODO: determine type of Tile to instantiate here
				// 		 and add it to tileData
				initTile = new Tile(tX, tY, tN, tS, tE, tW, tTexture);
				tileData.push(initTile);
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
