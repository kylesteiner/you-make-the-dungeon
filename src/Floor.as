// Floor.as
// Stores the state of a single floor.

package {
	import flash.net.*;
	import flash.utils.*;
	import flash.ui.Keyboard;
	import mx.utils.StringUtil;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.*;

	import Character;
	import Combat;
	import entities.*;
	import Logger;
	import tiles.*;
	import Util;

	public class Floor extends Sprite {
		public static const NEXT_LEVEL_MESSAGE:String = "You did it!\nClick here for next floor."

		public var grid:Array;			// 2D Array of Tiles.
		public var entityGrid:Array;	// 2D Array of Entities.
		public var fogGrid:Array;		// 2D Array of fog Images.
		public var char:Character;
		public var floorName:String;
		public var highlightedLocations:Array;

		// Stores the state of objective tiles. If the tile has been visited, the value is
		// true, otherwise it is false.
		// Map string (objective key) -> boolean (state)
		public var objectiveState:Dictionary;

		// Grid metadata.
		private var initialGrid:Array;
		private var initialFogGrid:Array;
		private var initialEntities:Array;
		public var gridHeight:int;
		public var gridWidth:int;
		public var preplacedTiles:int;
		public var completed:Boolean;

		// Character's initial stats.
		private var initialX:int;
		private var initialY:int;
		private var initialXp:int;
		private var initialHp:int;
		private var initialLevel:int;
		private var initialStamina:int;
		private var initialLos:int;

		private var floorFiles:Dictionary;
		private var nextFloor:String;
		private var onCompleteCallback:Function;

		// If the character is fighting, the enemy the character is fighting.
		private var enemy:Enemy;
		private var dmgText:TextField;

		private var textures:Dictionary;
		private var animations:Dictionary;

		private var mixer:Mixer;

		// logger
		private var logger:Logger;
		private var nextTransition:String;

		public var tutorialImage:Image;

		private var nextFloorButton:Clickable;
		private var tutorialDisplaying:Boolean;
		private var originalTutorialDisplaying:Boolean;

		public var altCallback:Function;

		public var pressedKeys:Array;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Floor(floorData:ByteArray,
							  textureDict:Dictionary,
							  animationDict:Dictionary,
							  level:int,
							  xp:int,
							  health:int,
							  stamina:int,
							  lineOfSight:int,
							  floorDict:Dictionary,
							  nextFloorCallback:Function,
							  soundMixer:Mixer,
							  logger:Logger = null,
							  showPrompt:int = 0) {
			super();
			initialLevel = level;
			initialXp = xp;
			initialHp = health;
			initialStamina = stamina;
			initialLos = lineOfSight;
			preplacedTiles = 0;
			textures = textureDict;
			animations = animationDict;

			mixer = soundMixer;

			altCallback = null;

			objectiveState = new Dictionary();


			this.logger = logger;

			floorFiles = floorDict;
			onCompleteCallback = nextFloorCallback;

			pressedKeys = new Array();

			parseFloorData(floorData);
			resetFloor();

			highlightedLocations = new Array(gridWidth);
			for (var i:int = 0; i < gridWidth; i++) {
				highlightedLocations[i] = new Array(gridHeight);
			}

			/*if(showPrompt > 0) {
				if(showPrompt == 1) {
					tutorialImage = new Image(textures[Util.TUTORIAL_BACKGROUND]);
				} else if(showPrompt == 2) {
					tutorialImage = new Image(textures[Util.TUTORIAL_TILE]);
				} else if(showPrompt > 2) {
					tutorialImage = new Image(textures[Util.TUTORIAL_PAN]);
				}

				tutorialImage.touchable = false;
				tutorialImage.alpha = 0.7;
				originalTutorialDisplaying = true;
				tutorialDisplaying = true;
				tutorialImage.x = getToX(0);
				tutorialImage.y = getToY(0);
				addChild(tutorialImage);
			}*/

			// Tile events bubble up from Tile and Character, so we
			// don't have to register an event listener on every child class.
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TileEvent.CHAR_ARRIVED, onCharArrived);
			addEventListener(TileEvent.CHAR_EXITED, onCharExited);
			addEventListener(TileEvent.CHAR_HANDLED, onCharHandled);
			addEventListener(TileEvent.OBJ_COMPLETED, onObjCompleted);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function getToX(x:int):int {
			var temp:int = 0;
			if (parent) {
				var shift:int = parent.x > 0 ? -1 : 1;
				while (temp + parent.x != x) {
					temp += shift;
				}
			}
			return temp;
		}

		private function getToY(y:int):int {
			var temp:int = 0;
			if (parent) {
				var shift:int = parent.y > 0 ? -1 : 1;
				while (temp + parent.y != y) {
					temp += shift;
				}
			}
			return temp;
		}

		public function removeTutorial():void {
			if(tutorialImage) {
				removeChild(tutorialImage);
				tutorialDisplaying = false;
			}
		}

		public function shiftTutorialX(value:int):void {
			if (tutorialImage) {
				tutorialImage.x += value;
			}
			if (nextFloorButton) {
				nextFloorButton.x += value;
			}
		}

		public function shiftTutorialY(value:int):void {
			if (tutorialImage) {
				tutorialImage.y += value;
			}
			if (nextFloorButton) {
				nextFloorButton.y += value;
			}
		}

		public function toggleRun():void {
			char.toggleRun();
		}

		// Called when the run button is clicked.
		public function runFloor():void {
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
			// Restore floor to pre-run grid
			// Put entities back in
			// Dont adjust fog of war

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
				clearHighlightedLocations()
			}

			//clearHighlightedLocations();

			// Replace the current grid with a fresh one.
			grid = Util.initializeGrid(gridWidth, gridHeight);
			fogGrid = Util.initializeGrid(gridWidth, gridHeight);
			entityGrid = Util.initializeGrid(gridWidth, gridHeight);

			// Add all of the initial tiles to the grid and display tree.
			for (i = 0; i < initialGrid.length; i++) {
				for (j = 0; j < initialGrid[i].length; j++) {
					grid[i][j] = initialGrid[i][j];
					if (grid[i][j]) {
						var t:Tile = grid[i][j];
						t.reset();
						addChild(t);
					}
				}
			}

			// Add all of the initial entities to the grid and display tree.
			for (i = 0; i < initialGrid.length; i++) {
				for (j = 0; j < initialGrid[i].length; j++) {
					entityGrid[i][j] = initialEntities[i][j];
					if (entityGrid[i][j]) {
						addChild(entityGrid[i][j]);
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

			resetCharacter();

			// Reset the objective state.
			for (var k:Object in objectiveState) {
				var key:String = String(k);
				objectiveState[key] = false;
			}

			/*
			if(tutorialImage && originalTutorialDisplaying) {
				tutorialDisplaying = true;
				tutorialImage.x = getToX(0);
				tutorialImage.y = getToY(0);
				addChild(tutorialImage);
			}*/

		}

		// Remove the character from the display tree and create a new one to reset
		// its state.
		public function resetCharacter():void {
			if (char) {
				char.removeFromParent();
			}
			char = new Character(initialX,
								 initialY,
								 10,  // TODO: set an initialHp value
								 initialStamina,
								 initialLos,
								 animations[Util.CHARACTER],
								 textures[Util.ICON_ATK]);
			addChild(char);
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
				if (j + 1 < fogGrid[i].length && fogGrid[i + 1][j + 1]) {
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
				if (j + 1 < fogGrid[i].length  && fogGrid[i - 1][j + 1]) {
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
			var coords:Array = getAllowedLocations(selectedTile);
			for (var i:int = 0; i < coords.length; i++) {
				var coord:Object = coords[i];
				var hl:Image = new Image(textures[Util.TILE_HL_G_NEW]);
				hl.x = coord.x * Util.PIXELS_PER_TILE;
				hl.y = coord.y * Util.PIXELS_PER_TILE;
				highlightedLocations[coord.x][coord.y] = hl;
				addChild(highlightedLocations[coord.x][coord.y]);
			}
		}

		// Returned an array of tiles on the grid that the player can move the selected tile to.
		public function getAllowedLocations(selectedTile:Tile):Array {
			var i:int; var j:int; var start_i:int; var start_j:int; var visited:Array;

			// Find entry tile
			OuterLoop: for (i = 0; i < grid.length; i++) {
				for (j = 0; j < grid[i].length; j++) {
					if (grid[i][j] is EntryTile) {
						start_i = i;
						start_j = j;
						break OuterLoop;
					}
				}
			}

			// Build visited grid
			visited = new Array(gridWidth);
			for (i = 0; i < gridWidth; i++) {
				visited[i] = new Array(gridHeight);
				for (j = 0; j < gridHeight; j++) {
					visited[i][j] = false;
				}
			}
			return getAllowedLocationsHelper(start_i, start_j, selectedTile, visited, -1);
		}

		// Recursively iterates over the map from the start and finds allowed locations
		public function getAllowedLocationsHelper(i:int, j:int, selectedTile:Tile, visited:Array, direction:int):Array {
			if (visited[i][j] || highlightedLocations[i][j]) {
				return new Array();
			}

			if (!grid[i][j] && ((direction == Util.NORTH && selectedTile.north) || (direction == Util.SOUTH && selectedTile.south) ||
					(direction == Util.WEST && selectedTile.west) || (direction == Util.EAST && selectedTile.east))) {
				// Open spot on grid that the selected tile can be placed
				var coordinate:Object = {x:int, y:int};
				coordinate.x = i;
				coordinate.y = j;
				return new Array(coordinate);
			} else if (grid[i][j] || direction == -1) {
				// Currently traversing path (-1 direction indicates the start tile)
				visited[i][j] = true;
				var ret:Array = new Array();
				if (i + 1 < gridWidth && grid[i][j].east) {
					ret = ret.concat(getAllowedLocationsHelper(i + 1, j, selectedTile, visited, Util.WEST));
				}
				if (i - 1 >= 0 && grid[i][j].west) {
					ret = ret.concat(getAllowedLocationsHelper(i - 1, j, selectedTile, visited, Util.EAST));
				}
				if (j + 1 < gridHeight && grid[i][j].south) {
					ret = ret.concat(getAllowedLocationsHelper(i, j + 1, selectedTile, visited, Util.NORTH));
				}
				if (j - 1 >= 0 && grid[i][j].north) {
					ret = ret.concat(getAllowedLocationsHelper(i, j - 1, selectedTile, visited, Util.SOUTH));
				}
				return ret;
			} else {
				return new Array()
			}
		}

		// Removes all highlighted tiles on the grid.
		public function clearHighlightedLocations():void {
			for (var i:int = 0; i < gridWidth; i++) {
				for (var j:int = 0; j < gridHeight; j++) {
					if (highlightedLocations[i][j]) {
						removeChild(highlightedLocations[i][j]);
						highlightedLocations[i][j] = null;
					}
				}
			}
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
			//nextFloor = Util.stripString(floorData[1]);
			nextFloor = "LOL PLACEHOLDER";

			//nextTransition = Util.stripString(floorData[2]);
			nextTransition = "LOL ALSO PLACEHOLDER";

			// Parse the floor dimensions and initialize the grid array.
			var floorSize:Array = floorData[1].split("\t");
			gridWidth = Number(floorSize[0]);
			gridHeight = Number(floorSize[1]);
			var mapBoundsBackground:Image = new Image(textures[Util.GRID_BACKGROUND]);
			mapBoundsBackground.width = Util.PIXELS_PER_TILE * gridWidth + Util.PIXELS_PER_TILE * 0.2;
			mapBoundsBackground.height = Util.PIXELS_PER_TILE * gridHeight + Util.PIXELS_PER_TILE * 0.2;
			mapBoundsBackground.x = - Util.PIXELS_PER_TILE * 0.1;
			mapBoundsBackground.y = - Util.PIXELS_PER_TILE * 0.1
			addChild(mapBoundsBackground);

			initialGrid = Util.initializeGrid(gridWidth, gridHeight);
			initialFogGrid = Util.initializeGrid(gridWidth, gridHeight);
			initialEntities = Util.initializeGrid(gridWidth, gridHeight);

			// Add a fog image at every grid tile.
			for (i = 0; i < initialFogGrid.length; i++) {
				for (j = 0; j < initialFogGrid[i].length; j++) {
					var fog:Image = new Image(textures[Util.TILE_FOG]);
					fog.x = i * Util.PIXELS_PER_TILE;
					fog.y = j * Util.PIXELS_PER_TILE;
					initialFogGrid[i][j] = fog;
				}
			}

			// Parse the character's starting position.
			var characterData:Array = floorData[2].split("\t");
			initialX = Number(characterData[0]);
			initialY = Number(characterData[1]);
			char = new Character(initialX,
								 initialY,
								 initialHp,  // TODO: set an initialHp value
								 initialStamina,
								 initialLos,
								 animations[Util.CHARACTER],
								 textures[Util.ICON_ATK]);

			// Parse all of the tiles.
			var numTiles:int = Number(floorData[5]);

			var lineData:Array;
			var tType:String;
			var tX:int; var tY:int;
			var tN:Boolean; var tS:Boolean; var tE:Boolean; var tW:Boolean;
			var tTexture:Texture;

			for (i = 0; i < numTiles; i++) {
				preplacedTiles++;
				lineData = floorData[i + 6].split("\t");

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
					initialGrid[tX][tY] = new Tile(tX, tY, tN, tS, tE, tW, tTexture);
				} else if (tType == "entry") {
					initialGrid[tX][tY] = new EntryTile(tX, tY, tN, tS, tE, tW, tTexture);
					initialFogGrid[tX][tY] = false;
					setUpInitialFoglessSpots(tX, tY);
				} else if (tType == "exit") {
					initialGrid[tX][tY] = new ExitTile(tX, tY, tN, tS, tE, tW, tTexture);
					initialFogGrid[tX][tY] = false;
				} else if (tType == "none") {
					initialGrid[tX][tY] = new ImpassableTile(tX, tY, textures[Util.TILE_NONE]);
				} else {
					trace("Created tile with invalid type " + tType + ": " + floorName + ", line " + i + 6)
				}
			}

			var numEntities:int = Number(floorData[6 + numTiles]);
			for (i = 0; i < numEntities; i++) {
				var line:int = 7 + numTiles + i;
				lineData = floorData[line].split('\t');
				tType = StringUtil.trim(lineData[0]);
				tX = Number(lineData[1]);
				tY = Number(lineData[2]);
				var textureName:String = StringUtil.trim(lineData[3]);

				if (tType == "enemy") {
					trace("Parsed enemy");
					var hp:int = Number(lineData[4]);
					var attack:int = Number(lineData[5]);
					var reward:int = Number(lineData[6]);
					initialEntities[tX][tY] = new Enemy(tX, tY, textures[textureName], hp, attack, reward);
				} else if (tType == "healing") {
					trace("Parsed health");
					var health:int = Number(lineData[4]);
					initialEntities[tX][tY] = new Healing(tX, tY, textures[textureName], health);
				} else if (tType == "objective") {
					trace("Parsed objective");
					var key:String = lineData[4];
					var prereqs:Array = new Array();
					for (j = 5; j < lineData.length; j++) {
						prereqs.push(StringUtil.trim(lineData[j]));
					}
					initialEntities[tX][tY] = new Objective(tX, tY, textures[textureName], key, prereqs);
					objectiveState[key] = false;
				} else {
					trace("Created entity with invalid type " + tType + ": " + floorName + ", line " + line);
				}
			}
		}

		// given an i and j (x and y) [position on the grid], removes the fogged locations around it
		// does 2 in each direction, and one in every diagonal direction
		// unlike the public function, just sets that spot to false
		// and doesn't deal with trying to remove a child that might not exist.
		private function setUpInitialFoglessSpots(i:int, j:int):void {
			var x:int; var y:int;
			var radius:int = char.los;

			for(x = i - radius; x <= i + radius; x++) {
				if(x >= 0 && x < initialFogGrid.length) {
					for(y = j - radius; y <= j + radius; y++) {
						if(y >= 0 && y < initialFogGrid[x].length) {
							if(Math.abs(x-i) + Math.abs(y-j) <= radius) {
								initialFogGrid[x][y] = false;
							}
						}
					}
				}
			}
		}

		// Game update loop. Currently handles combat over a series of frames.
		private function onEnterFrame(e:Event):void {
			addChild(char);

			if (nextFloorButton) {
				addChild(nextFloorButton);
			}

			if(tutorialImage && tutorialDisplaying) {
				addChild(tutorialImage);
			}

			var keyCode:uint;
			var cgx:int; var cgy:int;
			var charTile:Tile; var nextTile:Tile;

			for each (keyCode in pressedKeys) {
				cgx = Util.real_to_grid(char.x);
				cgy = Util.real_to_grid(char.y);

				if(!grid[cgx][cgy]) {
					continue; // empty tile, invalid state
				}

				charTile = grid[cgx][cgy];

				if (keyCode == Keyboard.UP && cgy > 0) {
					if(!grid[cgx][cgy-1]) {
						continue;
					}

					nextTile = grid[cgx][cgy-1];
					if(charTile.north && nextTile.south) {
						char.move(Util.NORTH);
					}
				} else if (keyCode == Keyboard.DOWN && cgy < gridHeight - 1) {
					if(!grid[cgx][cgy+1]) {
						continue;
					}

					nextTile = grid[cgx][cgy+1];
					if(charTile.south && nextTile.north) {
						char.move(Util.SOUTH);
					}
				} else if (keyCode == Keyboard.LEFT && cgx > 0) {
					if(!grid[cgx-1][cgy]) {
						continue;
					}

					nextTile = grid[cgx-1][cgy];
					if(charTile.west && nextTile.east) {
						char.move(Util.WEST);
					}
				} else if (keyCode == Keyboard.RIGHT && cgx < gridWidth - 1) {
					if(!grid[cgx+1][cgy]) {
						continue;
					}

					nextTile = grid[cgx+1][cgy];
					if(charTile.east && nextTile.west) {
						char.move(Util.EAST);
					}
				}
			}
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if(!char.runState) {
				return;
			}

			if(pressedKeys.indexOf(event.keyCode) == -1) {
				pressedKeys.push(event.keyCode);
			}
		}

		private function onKeyUp(event:KeyboardEvent):void {
			if(!char.runState) {
				return;
			}

			if(pressedKeys.indexOf(event.keyCode) == -1) {
				return;
			}

			pressedKeys.splice(pressedKeys.indexOf(event.keyCode), 1);
			// TODO: test functionality with pressng + releasing many keys
		}

		// When a character arrives at a tile, it fires an event up to Floor.
		// Find the tile it arrived at and call its handleChar() function.
		private function onCharArrived(e:TileEvent):void {
			var entity:Entity = entityGrid[e.grid_x][e.grid_y];
			if (!entity) {
				return;
			}
			if (entity is Enemy && logger) {
				var enemy:Enemy = entity as Enemy;
				logger.logAction(5, {
					"characterHealthLeft":char.hp,
					"characterHealthMax":char.maxHp,
					"characterAttack":char.attack,
					"enemyAttack":enemy.attack,
					"enemyHealth":enemy.hp,
					"enemyReward":enemy.reward
				});
			} else if (entity is Healing && logger) {
				var healing:Healing = entity as Healing;
				logger.logAction(6, {
					"characterHealth":char.hp,
					"characterMaxHealth":char.maxHp,
					"healthRestored":healing.health
				});
			}
			// TODO: Handle character-entity interaction
		}

		public function onCombatSuccess(enemy:Enemy):void {
			entityGrid[enemy.grid_x][enemy.grid_y] = null;
			removeChild(enemy);
		}

		public function onCharHandled(e:TileEvent):void {
		}

		// Event handler for when a character arrives at an exit tile.
		// The event chain goes: character -> floor -> tile -> floor.
		private function onCharExited(e:TileEvent):void {
			// TODO: Do actual win condition handling.
			if (logger) {
				logger.logLevelEnd({
					"characterHpRemaining":char.hp,
					"characterMaxHP":char.maxHp
				});
			}
			completed = true;

			mixer.play(Util.FLOOR_COMPLETE);

			var winBox:Sprite = new Sprite();
			var popup:Image = new Image(textures[Util.POPUP_BACKGROUND])
			winBox.addChild(popup);
			winBox.addChild(new TextField(popup.width, popup.height, NEXT_LEVEL_MESSAGE, Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			winBox.x = (Util.STAGE_WIDTH - winBox.width) / 2 - this.parent.x;
			winBox.y = (Util.STAGE_HEIGHT - winBox.height) / 2 - this.parent.y;

			nextFloorButton = new Clickable(0, 0, onCompleteCallback, winBox);
			nextFloorButton.addParameter(altCallback); // Default = switchToFloor
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_TRANSITION_INDEX]);
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_FLOOR_INDEX]);
			nextFloorButton.addParameter(floorFiles[nextFloor][Util.DICT_TILES_INDEX]);

			var i:int = 0;
			if(nextFloor == Util.FLOOR_1) {
				i = 1;
			} else if(nextFloor == Util.FLOOR_2) {
				i = 2;
			} else if(nextFloor == Util.FLOOR_8) {
				i = 3;
			}
			nextFloorButton.addParameter(i);
		}

		// Called when the character moves into an objective tile. Updates objectiveState
		// to mark the tile as visited.
		// Event chain: Character -> Floor -> ObjectiveTile -> Floor
		private function onObjCompleted(e:TileEvent):void {
			var obj:Objective = entityGrid[e.grid_x][e.grid_y];
			objectiveState[obj.key] = true;
		}
	}
}
