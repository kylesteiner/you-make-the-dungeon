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

	import ai.Combat;
	import ai.SearchAgent;
	import Character;
	import tiles.*;
	import Util;
	import Logger;

	public class Floor extends Sprite {
		// Number of lines at the beginning of floordata files that are
		// dedicated to non-tile objects at the start.
		public static const NON_TILE_LINES:int = 5;

		public static const NEXT_LEVEL_MESSAGE:String = "You did it!\nClick anywhere for next level."

		// 2D Array of Tiles. Represents the current state of all tiles.
		public var grid:Array;
		public var fogGrid:Array;
		public var char:Character;
		public var floorName:String;

		// Stores the state of objective tiles. If the tile has been visited, the value is
		// true, otherwise it is false.
		// Map string (objective key) -> boolean (state)
		public var objectiveState:Dictionary;

		// Grid metadata.
		private var initialGrid:Array;
		private var initialFogGrid:Array;
		public var gridHeight:int;
		public var gridWidth:int;
		public var preplacedTiles:int;

		// Character's initial stats.
		private var initialX:int;
		private var initialY:int;
		private var initialXp:int;
		private var initialLevel:int;

		private var agent:SearchAgent;

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

		// logger
		private var logger:Logger;
		private var nextTransition:String;
		private var highlightedLocations:Array;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Floor(floorData:ByteArray,
							  textureDict:Dictionary,
							  level:int,
							  xp:int,
							  floorDict:Dictionary,
							  nextFloorCallback:Function,
							  logger:Logger = null) {
			super();
			initialLevel = level;
			initialXp = xp;
			preplacedTiles = 0;
			textures = textureDict;
			objectiveState = new Dictionary();

			agent = new SearchAgent(SearchAgent.aStar, SearchAgent.heuristic);

			highlightedLocations = new Array();

			combatFrames = 0;
			characterCombatTurn = true;
			this.logger = logger;

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

		// Called when the run button is clicked.
		public function runFloor():void {
			agent.computePath(this);
			var firstAction:int = agent.getAction();
			if (firstAction != -1) {
				char.move(firstAction);
			} else {
				// TODO: display that it couldn't find a path.
			}
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
			grid = Util.initializeGrid(gridWidth, gridHeight);
			fogGrid = Util.initializeGrid(gridWidth, gridHeight);

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

			// Add all of the fogged places into the map
			for (i = 0; i < initialFogGrid.length; i++) {
				for (j = 0; j < initialFogGrid[i].length; j++) {
					fogGrid[i][j] = initialFogGrid[i][j];
					if(fogGrid[i][j]) {
						addChild(fogGrid[i][j]);
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

		// given an i and j (x and y) [position on the grid], removes the fogged locations around it
		// does 2 in each direction, and one in every diagonal direction
		public function removeFoggedLocations(i:int, j:int):void {
			var x:int; var y:int; var h1:Image;

			// should go two up, down, left, right, and one in each diagonal location, removing
			// fog when needed
			for (x = 1; x <= 2; x++) {
				if (x + i < fogGrid.length && fogGrid[x + i][j]) {
					h1 = fogGrid[x + i][j];
					fogGrid[x + i][j] = false;
					removeChild(h1);
				}
			}
			for (x = -1; x >= -2; x--) {
				if (x + i >= 0 && fogGrid[x + i][j]) {
					h1 = fogGrid[i + x][j];
					fogGrid[x + i][j] = false;
					removeChild(h1);
				}
			}
			for (y = -1; y >= -2; y--) {
				if (y + j < fogGrid[i].length && fogGrid[i][y + j]) {
					h1 = fogGrid[i][y + j];
					fogGrid[i][y + j] = false;
					removeChild(h1);
				}
			}
			for (y = 1; y <= 2; y++) {
				if (y + j >= 0 && fogGrid[i][y + j]) {
					h1 = fogGrid[i][y + j];
					fogGrid[i][y + j] = false;
					removeChild(h1);
				}
			}
			// diagonal cases
			if (i + 1 < fogGrid.length) {
				if (j + 1 < fogGrid[j].length && fogGrid[i + 1][j + 1]) {
					h1 = fogGrid[i + 1][j + 1];
					fogGrid[i + 1][j + 1] = false;
					removeChild(h1);
				}
				if (j - 1 >= 0  && fogGrid[i + 1][j - 1]) {
					h1 = fogGrid[i + 1][j - 1];
					fogGrid[i + 1][j - 1] = false;
					removeChild(h1);
				}
			}
			if (i -1 >= 0) {
				if (j + 1 < fogGrid[j].length  && fogGrid[i - 1][j + 1]) {
					h1 = fogGrid[i - 1][j + 1];
					fogGrid[i - 1][j + 1] = false;
					removeChild(h1);
				}
				if (j - 1 >= 0  && fogGrid[i - 1][j - 1]) {
					h1 = fogGrid[i - 1][j - 1];
					fogGrid[i - 1][j - 1] = false;
					removeChild(h1);
				}
			}
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

			initialGrid = Util.initializeGrid(gridWidth, gridHeight);
			initialFogGrid = Util.initializeGrid(gridWidth, gridHeight);

			for (i = 0; i < initialFogGrid.length; i++) {
				for (j = 0; j < initialFogGrid[i].length; j++) {
					var fog:Image = new Image(textures[Util.TILE_FOG]);
					fog.x = i * Util.PIXELS_PER_TILE;
					fog.y = j * Util.PIXELS_PER_TILE;
					initialFogGrid[i][j] = fog;
				}
			}

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
				preplacedTiles++;
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
				if (tile is EntryTile) {
					initialFogGrid[tile.grid_x][tile.grid_y] = false;
					setUpInitialFoglessSpots(tile.grid_x, tile.grid_y);
				} else if (tile is ExitTile) {
					initialFogGrid[tile.grid_x][tile.grid_y] = false;
				}
			}

		}

		// given an i and j (x and y) [position on the grid], removes the fogged locations around it
		// does 2 in each direction, and one in every diagonal direction
		// unlike the public function, just sets that spot to false
		// and doesn't deal with trying to remove a child that might not exist.
		private function setUpInitialFoglessSpots(i:int, j:int):void {
			var x:int; var y:int;

			// should go two up, down, left, right, and one in each diagonal location, removing
			// fog when needed
			for (x = 1; x <= 2; x++) {
				if (x + i < initialFogGrid.length) {
					initialFogGrid[x + i][j] = false;
				}
			}
			for (x = -1; x >= -2; x--) {
				if (x + i >= 0) {
					initialFogGrid[x + i][j] = false;
				}
			}
			for (y = -1; y >= -2; y--) {
				if (y + j < initialFogGrid[i].length) {
					initialFogGrid[i][y + j] = false;
				}
			}
			for (y = 1; y <= 2; y++) {
				if (y + j >= 0) {
					initialFogGrid[i][y + j] = false;
				}
			}
			// diagonal cases
			if (i + 1 < initialFogGrid.length) {
				if (j + 1 < initialFogGrid[j].length) {
					initialFogGrid[i + 1][j + 1] = false;
				}
				if (j - 1 >= 0) {
					initialFogGrid[i + 1][j - 1] = false;
				}
			}
			if (i -1 >= 0) {
				if (j + 1 < initialFogGrid[j].length) {
					initialFogGrid[i - 1][j + 1] = false;
				}
				if (j - 1 >= 0) {
					initialFogGrid[i - 1][j - 1] = false;
				}
			}
		}

		// Game update loop. Currently handles combat over a series of frames.
		private function onEnterFrame(e:Event):void {
			if (char.inCombat && combatFrames == 0) {
				// Time for the next combat round.
				if (characterCombatTurn) {
					Combat.charAttacksEnemy(char.state, enemy.state);

					// TODO: display damage more prettily
					dmgText = new TextField(64, 32, "-" + char.state.attack, Util.DEFAULT_FONT, 24, 0x0000FF, true);
					dmgText.x = 200;
					dmgText.y = 200;
					addChild(dmgText);

					combatFrames = 30;

					// If the enemy dies, remove the enemy image and end combat.
					if (enemy.state.hp <= 0) {
						// TODO: Display XP gain, healing
						enemy.removeImage();
						char.inCombat = false;
						dispatchEvent(new TileEvent(TileEvent.CHAR_HANDLED,
													Util.real_to_grid(x),
													Util.real_to_grid(y),
													char));
					}
					characterCombatTurn = false;  // Swap turns.
				} else {
					Combat.enemyAttacksChar(char.state, enemy.state);
					// TODO: display damage more prettily
					dmgText = new TextField(64, 32, "-" + enemy.state.attack, Util.DEFAULT_FONT, 24, 0xFF0000, true);
					dmgText.x = 200;
					dmgText.y = 200;
					addChild(dmgText);

					combatFrames = 30;

					if (char.state.hp <= 0) {
						// TODO: handle character death.
						if (logger) {
							logger.logAction(4, { "characterLevel":char.state.level, "characterAttack":char.state.attack, "enemyName":enemy.enemyName,
												 "enemyLevel":enemy.level, "enemyAttack":enemy.state.attack, "enemyHealthLeft":enemy.state.hp, "initialEnemyHealth":enemy.initialHp} );
						}
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
				if (t is EnemyTile && logger) {
					var eTile:EnemyTile = t as EnemyTile;
					logger.logAction(5, { "characterLevel":e.char.state.level, "characterHealthLeft":e.char.state.hp, "characterHealthMax":e.char.state.maxHp,
										 "characterAttack":e.char.state.attack, "enemyName": eTile.enemyName,
										 "enemyLevel":eTile.level, "enemyAttack":eTile.state.attack, "enemyHealth":eTile.initialHp} );
				} else if (t is HealingTile && logger) {
					var hTile:HealingTile = t as HealingTile;
					if (!hTile.used) {
						logger.logAction(6, { "characterHealth":e.char.state.hp, "characterMaxHealth":e.char.state.maxHp, "healthRestored":hTile.state.health } );
					}
				}
				t.handleChar(e.char);
			}
		}

		private function onCharHandled(e:TileEvent):void {
			char.move(agent.getAction());
		}

		// Event handler for when a character arrives at an exit tile.
		// The event chain goes: character -> floor -> tile -> floor.
		private function onCharExited(e:TileEvent):void {
			// TODO: Do actual win condition handling.
			if (logger) {
				logger.logLevelEnd( {"characterLevel":e.char.state.level, "characterHpRemaining":e.char.state.hp, "characterMaxHP":e.char.state.maxHp } );
			}
			var winText:TextField = new TextField(640, 480, NEXT_LEVEL_MESSAGE, Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			var nextFloorButton:Clickable = new Clickable(0, 0,
													onCompleteCallback,
													winText);
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_TRANSITION_INDEX]);
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_FLOOR_INDEX]);
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_TILES_INDEX]);
			nextFloorButton.addParameter(char.state.level);
			nextFloorButton.addParameter(char.state.xp);
			addChild(nextFloorButton);
		}

		// Called when the character moves into an objective tile. Updates objectiveState
		// to mark the tile as visited.
		// Event chain: Character -> Floor -> ObjectiveTile -> Floor
		private function onObjCompleted(e:TileEvent):void {
			var t:ObjectiveTile = grid[e.grid_x][e.grid_y];
			objectiveState[t.state.key] = true;
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
