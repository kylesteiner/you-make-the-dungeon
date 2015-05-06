// Floor.as
// Stores the state of a single floor.

package {
	import flash.net.*;
	import flash.utils.*;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.*;

	import Character;
	import tiles.*;
	import Util;

	public class Floor extends Sprite {
		// Number of lines at the beginning of floordata files that are
		// dedicated to non-tile objects at the start.
		public static const NON_TILE_LINES:int = 3;

		// 2D Array of Tiles. Represents the current state of all tiles.
		public var grid:Array;
		public var char:Character;
		public var floorName:String;

		// Stores the state of objective tiles. If the tile has been visited, the value is
		// true, otherwise it is false.
		// Map string (objective key) -> boolean (state)
		public var objectiveState:Dictionary;

		private var initialGrid:Array;
		private var initialXp:int;

		private var gridHeight:int;
		private var gridWidth:int;

		// Character's initial grid coordinates.
		private var initialX:int;
		private var initialY:int;

		private var textures:Dictionary;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Floor(floorData:ByteArray,
							  textureDict:Dictionary,
							  xp:int) {
			super();
			initialXp = xp;
			textures = textureDict;
			objectiveState = new Dictionary();

			parseFloorData(floorData);

			resetFloor();

			// CHAR_EXITED events bubble up from Tile and Character, so we
			// don't have to register an event listener on every child class.
			addEventListener(TileEvent.CHAR_EXITED, onCharExited);
			addEventListener(TileEvent.CHAR_ARRIVED, onCharArrived);
			addEventListener(TileEvent.OBJ_COMPLETED, onObjCompleted);
		}

		// Resets the character and grid state to their initial values.
		public function resetFloor():void {
			var i:int; var j:int;

			if (grid) {
				// Remove all tiles from the display tree.
				for (i = 0; i < grid.length; i++) {
					for (j = 0; j < grid[i].length; j++) {
						// TODO: figure out it it is necessary to dispose of the
						// tile here.
						if (grid[i][j]) {
							grid[i][j].removeFromParent();
						}
					}
				}
			}

			// Replace the current grid with a fresh one.
			grid = initializeGrid(gridWidth, gridHeight);

			// Add all of the initial tiles to the grid and display tree.
			for (i = 0; i < initialGrid.length; i++) {
				for (j = 0; j < initialGrid[i].length; j++) {
					grid[i][j] = initialGrid[i][j];
					if(grid[i][j]) {
						var t:Tile = grid[i][j];
						t.reset();
						addChild(t);
					}
				}
			}

			// Remove the character from the display tree and create a new one to reset
			// its state.
			if (char) {
				char.removeFromParent();
			}
			char = new Character(
					initialX, initialY, initialXp, textures[Util.HERO]);
			addChild(char);

			// Reset the objective state.
			for (var k:Object in objectiveState) {
				var key:String = String(k);
				objectiveState[key] = false;
			}
		}

		// Returns a 2D array with the given dimensions.
		private function initializeGrid(x:int, y:int):Array {
			var arr:Array = new Array(x);
			for (var i:int = 0; i < x; i++) {
				arr[i] = new Array(y);
			}
			return arr;
		}

		private function parseFloorData(floorDataBytes:ByteArray):void {
			// TODO: ensure loaded file always has correct number of lines
			//		 as well as all necessary data (char, entry, exit).
			// TODO: ensure that each line in loaded file has correct number
			//		 of arguments.
			var i:int; var j:int;

			var floorDataString:String =
				floorDataBytes.readUTFBytes(floorDataBytes.length);

			// Parse the floor name.
			var floorData:Array = floorDataString.split("\n");
			floorName = floorData[0];

			// Parse the floor dimensions and initialize the grid array.
			var floorSize:Array = floorData[1].split("\t");
			gridWidth = Number(floorSize[0]);
			gridHeight = Number(floorSize[1]);
			initialGrid = initializeGrid(gridWidth, gridHeight);

			// Parse the character's starting position.
			var characterData:Array = floorData[2].split("\t");
			initialX = Number(characterData[0]);
			initialY = Number(characterData[1]);
			char = new Character(
					initialX, initialY, initialXp, textures[Util.HERO]);

			// Parse all of the tiles.
			var lineData:Array;
			var initTile:Tile;
			var tType:String;
			var tX:int; var tY:int;
			var tN:Boolean; var tS:Boolean; var tE:Boolean; var tW:Boolean;
			var textureString:String;
			var tTexture:Texture;
			var tileData:Array = new Array();

			for (i = NON_TILE_LINES; i < floorData.length; i++) {
				if (floorData[i].length == 0) {
					continue;
				}

				lineData = floorData[i].split("\t");

				tType = lineData[0];
				tX = Number(lineData[1]);
				tY = Number(lineData[2]);

				// Build the String referring to the texture.
				tN = (lineData[3] == "1") ? true : false;
				tS = (lineData[4] == "1") ? true : false;
				tE = (lineData[5] == "1") ? true : false;
				tW = (lineData[6] == "1") ? true : false;
				tTexture = textures[Util.getTextureString(tN, tS, tE, tW)];

				if (tType == "empty") {
					tileData.push(new Tile(tX, tY, tN, tS, tE, tW, tTexture));
				} else if (tType == "entry") {
					tileData.push(new EntryTile(tX, tY, tN, tS, tE, tW, tTexture));
				} else if (tType == "exit") {
					tileData.push(new ExitTile(tX, tY, tN, tS, tE, tW, tTexture));
				} else if (tType == "health") {
					var tHealth:int = Number(lineData[7]);
					tileData.push(new HealingTile(tX, tY, tN, tS, tE, tW, tTexture, textures[Util.HEALING], tHealth));
				} else if (tType == "enemy") {
					var eName:String = lineData[7];
					var eLvl:int = Number(lineData[8]);
					var eHp:int = Number(lineData[9]);
					var eAtk:int = Number(lineData[10]);
					var eReward:int = Number(lineData[11]);
					tileData.push(new EnemyTile(tX, tY, tN, tS, tE, tW, tTexture, textures[Util.MONSTER_1], eName, eLvl, eHp, eAtk, eReward));
				} else if (tType == "objective") {
					var oName:String = lineData[7];
					var prereqs:Array = new Array();
					for (j = 8; j < lineData.length; j++) {
						prereqs.push(lineData[j]);
					}
					tileData.push(new ObjectiveTile(tX, tY, tN, tS, tE, tW, tTexture, textures[Util.KEY], oName, prereqs));
					objectiveState[oName] = false;
				}
			}

			// put tileData's tiles into a grid
			for each (var tile:Tile in tileData) {
				initialGrid[tile.grid_x][tile.grid_y] = tile;
			}
		}

		// When a character arrives at a tile, it fires an event up to Floor.
		// Find the tile it arrived at and call its handleChar() function.
		private function onCharArrived(e:TileEvent):void {
			var t:Tile = grid[e.grid_x][e.grid_y];
			if (t) {
				t.handleChar(e.char);
			}
		}

		// Event handler for when a character arrives at an exit tile.
		// The event chain goes: character -> floor -> tile -> floor.
		private function onCharExited(e:TileEvent):void {
			// TODO: Do actual win condition handling.
			var t:TextField = new TextField(256, 32, "You won!", "Verdana", 20);
			t.x = 100
			t.y = 200;
			addChild(t);
		}

		// Called when the character moves into an objective tile. Updates objectiveState
		// to mark the tile as visited.
		// Event chain: Character -> Floor -> ObjectiveTile -> Floor
		private function onObjCompleted(e:TileEvent):void {
			var t:ObjectiveTile = grid[e.grid_x][e.grid_y];
			objectiveState[t.objKey] = true;
		}
	}
}
