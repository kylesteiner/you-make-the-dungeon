// Floor.as
// Stores the state of a single floor.

package {
	import flash.net.*;
	import flash.utils.*;
	import starling.display.Image;

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
		public static const NON_TILE_LINES:int = 5;

		public static const NEXT_LEVEL_MESSAGE:String = "You did it!\nClick anywhere for next level."

		// 2D Array of Tiles. Represents the current state of all tiles.
		public var grid:Array;
		public var char:Character;
		public var floorName:String;

		// Stores the state of objective tiles. If the tile has been visited, the value is
		// true, otherwise it is false.
		// Map string (objective key) -> boolean (state)
		public var objectiveState:Dictionary;

		private var initialGrid:Array;
		public var gridHeight:int;
		public var gridWidth:int;

		// Character's initial stats.
		private var initialX:int;
		private var initialY:int;
		private var initialXp:int;
		private var initialLevel:int;

		private var floorFiles:Dictionary;
		private var nextFloor:String;
		private var onCompleteCallback:Function;

		// If the character is fighting, the enemy the character is fighting.
		private var enemy:EnemyTile;
		// Number of frames until the next combat animation.
		private var combatFrames:int;
		// True if character is attacking, false otherwise.
		private var characterCombatTurn:Boolean;
		private var dmgText:TextField;

		private var textures:Dictionary;
		private var nextTransition:String;
		private var highlightedLocations:Array;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Floor(floorData:ByteArray,
							  textureDict:Dictionary,
							  level:int,
							  xp:int,
							  floorDict:Dictionary,
							  nextFloorCallback:Function) {
			super();
			initialLevel = level;
			initialXp = xp;
			textures = textureDict;
			objectiveState = new Dictionary();
			highlightedLocations = new Array();
			combatFrames = 0;
			characterCombatTurn = true;

			floorFiles = floorDict;
			onCompleteCallback = nextFloorCallback;

			parseFloorData(floorData);
			resetFloor();

			// Tile events bubble up from Tile and Character, so we
			// don't have to register an event listener on every child class.
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TileEvent.CHAR_ARRIVED, onCharArrived);
			addEventListener(TileEvent.CHAR_EXITED, onCharExited);
			addEventListener(TileEvent.CHAR_HANDLED, onCharHandled);
			addEventListener(TileEvent.COMBAT, onCombat);
			addEventListener(TileEvent.OBJ_COMPLETED, onObjCompleted);
		}

		public function getEntry():Tile {
			var x:int; var y:int;

			for(x = 0; x < grid.length; x++) {
				for(y = 0; y < grid[x].length; y++) {
					if(grid[x][y] is EntryTile) {
						return grid[x][y];
					}
				}
			}

			return null;
		}

		public function getExit():Tile {
			var x:int; var y:int;

			for(x = 0; x < grid.length; x++) {
				for(y = 0; y < grid[x].length; y++) {
					if(grid[x][y] is ExitTile) {
						return grid[x][y];
					}
				}
			}

			return null;
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
					initialX, initialY, initialLevel, initialXp, textures[Util.HERO]);
			addChild(char);

			// Reset the objective state.
			for (var k:Object in objectiveState) {
				var key:String = String(k);
				objectiveState[key] = false;
			}

			// Reset the combat state.
			combatFrames = 0;
			characterCombatTurn = true;
		}

		// Returns true if the tile location the player chose is valid with the current dungeon setup.
		public function fitsInDungeon(i:int, j:int, selectedTile:Tile):Boolean {
			return (i + 1 < grid.length && grid[i + 1][j] && grid[i + 1][j].west && selectedTile.east) ||
				   (i - 1 >= 0 && grid[i - 1][j] && grid[i - 1][j].east && selectedTile.west) ||
				   (j + 1 < grid[0].length && grid[i][j + 1] && grid[i][j + 1].north && selectedTile.south) ||
				   (j - 1 >= 0 && grid[i][j - 1] && grid[i][j - 1].south && selectedTile.north);
		}

		// Highlights tiles on the grid that the player can move the selected tile to.
		public function highlightAllowedLocations(selectedTile:Tile):void {
			var i:int; var j:int; var hl:Image;

			for (i = 0; i < grid.length; i++) {
				for (j = 0; j < grid[i].length; j++) {
					if (!grid[i][j]) {
						var goodTile:Boolean = false;
						if (fitsInDungeon(i, j, selectedTile)) {
							hl = new Image(textures[Util.TILE_HL_Y]);
							hl.x = i * Util.PIXELS_PER_TILE;
							hl.y = j * Util.PIXELS_PER_TILE;
							highlightedLocations.push(hl);
							addChild(hl);
						}
					}
				}
			}
		}

		// Removes all highlighted tiles on the grid.
		public function clearHighlightedLocations():void {
			for (var i:int = 0; i < highlightedLocations.length; i++) {
				removeChild(highlightedLocations[i]);
			}
			highlightedLocations.splice()
		}

		// Returns a 2D array with the given dimensions.
		private function initializeGrid(x:int, y:int):Array {
			var arr:Array = new Array(x);
			// Potential bug exists here when appending Tiles to
			// the end of the outside array (which should never occur)
			// Code elsewhere will treat an Array of 5 Arrays and a Tile
			// as 6 Arrays, which then bugs when we set properties of the
			// 6th "Array".
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
			// Remove hidden escape characters from floor name.
			var floorData:Array = floorDataString.split("\n");
			floorName = Util.stripString(floorData[0]);

			// Parse the name of the next floor.
			// Remove hidden escape characters
			nextFloor = Util.stripString(floorData[1]);

			nextTransition = Util.stripString(floorData[2]);

			// Parse the floor dimensions and initialize the grid array.
			var floorSize:Array = floorData[3].split("\t");
			gridWidth = Number(floorSize[0]);
			gridHeight = Number(floorSize[1]);
			initialGrid = initializeGrid(gridWidth, gridHeight);

			// Parse the character's starting position.
			var characterData:Array = floorData[4].split("\t");
			initialX = Number(characterData[0]);
			initialY = Number(characterData[1]);
			char = new Character(
					initialX, initialY, initialLevel, initialXp, textures[Util.HERO]);

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
				// Final portion of each string needs to have
				// escape characters stripped off. This will cause
				// bugs with preplaced tiles otherwise.
				tN = (lineData[3] == "1") ? true : false;
				tS = (lineData[4] == "1") ? true : false;
				tE = (lineData[5] == "1") ? true : false;
				tW = (Util.stripString(lineData[6]) == "1") ? true : false;
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
				} else if (tType == "none") {
					tileData.push(new ImpassableTile(tX, tY, textures[Util.TILE_NONE]));
				}
			}

			// put tileData's tiles into a grid
			for each (var tile:Tile in tileData) {
				initialGrid[tile.grid_x][tile.grid_y] = tile;
			}
		}

		private function onEnterFrame(e:Event):void {
			if (char.inCombat && combatFrames == 0) {
				// Time for the next combat round.
				if (characterCombatTurn) {
					enemy.hp -= char.attack;

					dmgText = new TextField(64, 32, "-" + char.attack, "Verdana", 24, 0x0000FF, true);
					dmgText.x = 200;
					dmgText.y = 200;
					addChild(dmgText);

					// TODO: Adjust character damage on character HUD.
					combatFrames = 30;

					// Add XP if player wins the combat.
					if (enemy.hp <= 0) {
						char.xp += enemy.xpReward;
						char.tryLevelUp();
						enemy.removeImage();
						char.inCombat = false;
						dispatchEvent(new TileEvent(TileEvent.CHAR_HANDLED,
													Util.real_to_grid(x),
													Util.real_to_grid(y),
													char));
					}
					characterCombatTurn = false;  // Swap turns.
				} else {
					char.hp -= enemy.attack;

					dmgText = new TextField(64, 32, "-" + enemy.attack, "Verdana", 24, 0xFF0000, true);
					dmgText.x = 200;
					dmgText.y = 200;
					addChild(dmgText);

					combatFrames = 30;

					if (char.hp <= 0) {
						// TODO: handle character death.
					}
					characterCombatTurn = true;  // Swap turns.
				}
			}

			// Remove the combat damage text after 15 frames.
			if (combatFrames == 15) {
				removeChild(dmgText);
			}
			// Tick down the frames between combat animations every frame.
			if (combatFrames > 0) {
				combatFrames--;
			}

			addChild(char);
		}

		// When a character arrives at a tile, it fires an event up to Floor.
		// Find the tile it arrived at and call its handleChar() function.
		private function onCharArrived(e:TileEvent):void {
			var t:Tile = grid[e.grid_x][e.grid_y];
			if (t) {
				t.handleChar(e.char);
			}
		}

		private function onCharHandled(e:TileEvent):void {
			char.continueMovement();
		}

		// Event handler for when a character arrives at an exit tile.
		// The event chain goes: character -> floor -> tile -> floor.
		private function onCharExited(e:TileEvent):void {
			// TODO: Do actual win condition handling.
			var winText:TextField = new TextField(640, 480, NEXT_LEVEL_MESSAGE, "Verdana", Util.MEDIUM_FONT_SIZE);
			var nextFloorButton:Clickable = new Clickable(0, 0,
													onCompleteCallback,
													winText);
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_TRANSITION_INDEX]);
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_FLOOR_INDEX]);
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_TILES_INDEX]);
			nextFloorButton.addParameter(char.level);
			nextFloorButton.addParameter(char.xp);
			addChild(nextFloorButton);
		}

		// Called when the character moves into an objective tile. Updates objectiveState
		// to mark the tile as visited.
		// Event chain: Character -> Floor -> ObjectiveTile -> Floor
		private function onObjCompleted(e:TileEvent):void {
			var t:ObjectiveTile = grid[e.grid_x][e.grid_y];
			objectiveState[t.objKey] = true;
		}

		// Called when a character runs into an enemy tile. Combat is executed
		// step by step over several frames, so combat logic isn't directly
		// invoked.
		private function onCombat(e:TileEvent):void {
			char.inCombat = true;
			characterCombatTurn = true;
			enemy = grid[e.grid_x][e.grid_y];
		}
	}
}
