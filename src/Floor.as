// Floor.as
// Stores the state of a single floor.

package {
	import flash.ui.Keyboard;
	// import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.Texture;

	import entities.*;
	import tiles.*;

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
		private var initialHp:int;
		private var initialAtk:int;
		private var initialStamina:int;
		private var initialLoS:int;

		private var floorFiles:Dictionary;
		private var onCompleteCallback:Function;

		private var textures:Dictionary;
		private var animations:Dictionary;

		private var mixer:Mixer;

		// logger
		private var logger:Logger;

		public var tutorialImage:Image;

		private var tutorialDisplaying:Boolean;
		private var originalTutorialDisplaying:Boolean;

		public var altCallback:Function;

		public var pressedKeys:Array;

		public var rooms:RoomSet;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Floor(floorData:String,
							  textures:Dictionary,
							  animations:Dictionary,
							  initialHp:int,
							  initialAtk:int,
							  initialStamina:int,
							  initialLineOfSight:int,
							  floorFiles:Dictionary,
							  nextFloorCallback:Function,
							  soundMixer:Mixer,
							  logger:Logger = null,
							  showPrompt:int = 0) {
			super();
			this.textures = textures;
			this.animations = animations;
			this.initialHp = initialHp;
			this.initialAtk = initialAtk;
			this.initialStamina = initialStamina;
			initialLoS = initialLineOfSight;

			this.floorFiles = floorFiles;
			onCompleteCallback = nextFloorCallback;
			altCallback = null;
			mixer = soundMixer;

			this.logger = logger;
			preplacedTiles = 0;

			pressedKeys = new Array();
			objectiveState = new Dictionary();

			// Get floor layout information from the JSON file.
			parseFloorData(floorData);

			// Set up the background.
			var mapBoundsBackground:Image = new Image(textures[Util.GRID_BACKGROUND]);
			mapBoundsBackground.width = Util.PIXELS_PER_TILE * gridWidth + Util.PIXELS_PER_TILE * 0.2;
			mapBoundsBackground.height = Util.PIXELS_PER_TILE * gridHeight + Util.PIXELS_PER_TILE * 0.2;
			mapBoundsBackground.x = - Util.PIXELS_PER_TILE * 0.1;
			mapBoundsBackground.y = - Util.PIXELS_PER_TILE * 0.1
			addChild(mapBoundsBackground);

			// Initialize floor using the initial state.
			resetFloor();

			highlightedLocations = new Array(gridWidth);
			for (var i:int = 0; i < gridWidth; i++) {
				highlightedLocations[i] = new Array(gridHeight);
			}

			/* if(showPrompt > 0) {
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
			} */

			// Tile events bubble up from Tile and Character, so we
			// don't have to register an event listener on every child class.
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(GameEvent.ARRIVED_AT_TILE, onCharArrived);
			addEventListener(GameEvent.ARRIVED_AT_EXIT, onCharExited);
			addEventListener(GameEvent.OBJ_COMPLETED, onObjCompleted);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(GameEvent.REVEAL_ROOM, onRoomReveal);
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
		}

		public function shiftTutorialY(value:int):void {
			if (tutorialImage) {
				tutorialImage.y += value;
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
						if (grid[i][j]) {
							grid[i][j].removeFromParent();
						}
					}
				}
				clearHighlightedLocations()
			}

			// Replace the current grid with a fresh one.
			grid = initializeGrid(gridWidth, gridHeight);
			fogGrid = initializeGrid(gridWidth, gridHeight);
			entityGrid = initializeGrid(gridWidth, gridHeight);

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
		}

		// Get rid of the old character (if it exists) and make a new one
		// with the default values.
		public function resetCharacter():void {
			if (char) {
				char.removeFromParent();
			}
			char = new Character(initialX,
								 initialY,
							 	 initialHp,
								 initialAtk,
								 initialStamina,
								 initialLoS,
								 animations[Util.CHARACTER],
								 textures[Util.ICON_ATK]);
			addChild(char);
		}

		// given an i and j (x and y) [position on the grid], removes the fogged locations around it
		// does 2 in each direction, and one in every diagonal direction
		public function removeFoggedLocations(i:int, j:int):void {
			var x:int; var y:int;
			var radius:int = char.los;

			for(x = i - radius; x <= i + radius; x++) {
				if(x >= 0 && x < fogGrid.length) {
					for(y = j - radius; y <= j + radius; y++) {
						if(y >= 0 && y < fogGrid[x].length) {
							if(Math.abs(x-i) + Math.abs(y-j) <= radius && fogGrid[x][y]) {
								removeChild(fogGrid[x][y]);
								fogGrid[x][y] = false;
							}
						}
					}
				}
			}
		}

		// Highlights tiles on the grid that the player can move the selected tile to.
		public function highlightAllowedLocations(directions:Array, hudState:String):void {
			var x:int; var y:int;

			if (hudState == BuildHUD.STATE_TILE) {
				var allowed:Array = getAllowedLocations(directions);
				for (x = 0; x < gridWidth; x++) {
					for (y = 0; y < gridHeight; y++) {
						addRemoveHighlight(x, y, allowed[x][y]);
					}
				}
			} else if (hudState == BuildHUD.STATE_ENTITY) {
				for (x = 0; x < gridWidth; x++) {
					for (y = 0; y < gridHeight; y++) {
						addRemoveHighlight(x, y, isEmptyTile(grid[x][y]) && !entityGrid[x][y]);
					}
				}
			}
		}

		public function isEmptyTile(tile:Tile):Boolean {
			return tile is Tile && !(tile is EntryTile) &&
				   !(tile is ExitTile) && !(tile is ImpassableTile) &&
				   !entityGrid[tile.grid_x][tile.grid_y];
		}

		private function addRemoveHighlight(x:int, y:int, add:Boolean):void {
			if (add) {
				// Highlight available location on grid
				if (!highlightedLocations[x][y]) {
					var hl:Image = new Image(textures[Util.TILE_HL_G_NEW]);
					hl.x = x * Util.PIXELS_PER_TILE;
					hl.y = y * Util.PIXELS_PER_TILE;
					highlightedLocations[x][y] = hl;
				}
				addChild(highlightedLocations[x][y]);
			} else {
				// Remove old highlighted location
				removeChild(highlightedLocations[x][y]);
				highlightedLocations[x][y] = null;
			}
		}

		// Removes all highlighted tiles on the grid.
		public function clearHighlightedLocations():void {
			for (var x:int = 0; x < gridWidth; x++) {
				for (var y:int = 0; y < gridHeight; y++) {
					removeChild(highlightedLocations[x][y]);
				}
			}
		}

		// Returned an array of tiles on the grid that the player can move the selected tile to.
		private function getAllowedLocations(directions:Array):Array {
			var x:int; var y:int; var start_x:int; var start_y:int; var visited:Array; var available:Array;

			// Find entry tile
			OuterLoop: for (x = 0; x < grid.length; x++) {
				for (y = 0; y < grid[x].length; y++) {
					if (grid[x][y] is EntryTile) {
						start_x = x;
						start_y = y;
						break OuterLoop;
					}
				}
			}

			// Build visited & available grids
			available = new Array(gridWidth);
			visited = new Array(gridWidth);
			for (x = 0; x < gridWidth; x++) {
				available[x] = new Array(gridHeight);
				visited[x] = new Array(gridHeight);
				for (y = 0; y < gridHeight; y++) {
					available[x][y] = false;;
					visited[x][y] = false;
				}
			}
			getAllowedLocationsHelper(start_x, start_y, directions, visited, available, -1);
			return available;
		}

		// Recursively iterates over the map from the start and finds allowed locations
		private function getAllowedLocationsHelper(x:int, y:int, directions:Array, visited:Array, available:Array, direction:int):void {
			if (visited[x][y]) {
				return;
			}

			if (!grid[x][y] && ((direction == Util.NORTH && directions[Util.NORTH]) || (direction == Util.SOUTH && directions[Util.SOUTH]) ||
					(direction == Util.WEST && directions[Util.WEST]) || (direction == Util.EAST && directions[Util.EAST]))) {
				// Open spot on grid that the selected tile can be placed
				available[x][y] = true;
			} else if (grid[x][y] || direction == -1) {
				// Currently traversing path (-1 direction indicates the start tile)
				visited[x][y] = true;
				if (x + 1 < gridWidth && grid[x][y].east) {
					getAllowedLocationsHelper(x + 1, y, directions, visited, available, Util.WEST);
				}
				if (x - 1 >= 0 && grid[x][y].west) {
					getAllowedLocationsHelper(x - 1, y, directions, visited, available, Util.EAST);
				}
				if (y + 1 < gridHeight && grid[x][y].south) {
					getAllowedLocationsHelper(x, y + 1, directions, visited, available, Util.NORTH);
				}
				if (y - 1 >= 0 && grid[x][y].north) {
					getAllowedLocationsHelper(x, y - 1, directions, visited, available, Util.SOUTH);
				}
			}
		}

		public function deleteSelected(tile:Tile, entity:Entity):void {
			if (entity) {
				removeChild(entity);
				entityGrid[entity.grid_x][entity.grid_y] = null;
			} else if (isEmptyTile(tile)) {
				removeChild(tile);
				grid[tile.grid_x][tile.grid_y] = null;
				mixer.play(Util.TILE_REMOVE);
			} else {
				mixer.play(Util.TILE_FAILURE);
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

		private function parseFloorData(floorDataString:String):void {
			trace(floorDataString);
			var floorData:Object = JSON.parse(floorDataString);

			floorName = floorData["floor_name"];

			gridWidth = floorData["floor_dimensions"]["width"];
			gridHeight = floorData["floor_dimensions"]["height"];

			initialGrid = initializeGrid(gridWidth, gridHeight);
			initialFogGrid = initializeGrid(gridWidth, gridHeight);
			initialEntities = initializeGrid(gridWidth, gridHeight);

			// Add a fog image at every grid tile.
			var i:int;
			var j:int;
			for (i = 0; i < initialFogGrid.length; i++) {
				for (j = 0; j < initialFogGrid[i].length; j++) {
					var fog:Image = new Image(textures[Util.TILE_FOG]);
					fog.x = i * Util.PIXELS_PER_TILE;
					fog.y = j * Util.PIXELS_PER_TILE;
					initialFogGrid[i][j] = fog;
				}
			}

			// Parse the character's starting position.
			initialX = floorData["character_start"]["x"];
			initialY = floorData["character_start"]["y"];
			char = new Character(initialX,
								 initialY,
								 initialHp,
								 initialAtk,
								 initialStamina,
								 initialLoS,
								 animations[Util.CHARACTER],
								 textures[Util.ICON_ATK]);

			var tType:String;
			var tX:int; var tY:int;
			var tN:Boolean; var tS:Boolean; var tE:Boolean; var tW:Boolean;
			var tTexture:Texture;

			var floorTiles:Array = floorData["tiles"];
			preplacedTiles = floorTiles.length;
			for (i = 0; i < floorTiles.length; i++) {
				var tile:Object = floorTiles[i];

				tType = tile["type"];
				tX = tile["x"];
				tY = tile["y"];

				// Build the String referring to the texture.
				// Final portion of each string needs to have
				// escape characters stripped off. This will cause
				// bugs with preplaced tiles otherwise.
				tN = (tile["edges"].indexOf("n") != -1) ? true : false;
				tS = (tile["edges"].indexOf("s") != -1) ? true : false;
				tE = (tile["edges"].indexOf("e") != -1) ? true : false;
				tW = (tile["edges"].indexOf("w") != -1) ? true : false;

				tTexture = textures[Util.getTextureString(tN, tS, tE, tW)];

				if (tile["type"] == "empty") {
					initialGrid[tX][tY] = new Tile(tX, tY, tN, tS, tE, tW, tTexture);
				} else if (tile["type"] == "entry") {
					initialGrid[tX][tY] = new EntryTile(tX, tY, tN, tS, tE, tW, tTexture);
					initialFogGrid[tX][tY] = false;
					setUpInitialFoglessSpots(tX, tY);
				} else if (tile["type"] == "exit") {
					initialGrid[tX][tY] = new ExitTile(tX, tY, tN, tS, tE, tW, tTexture);
					initialFogGrid[tX][tY] = false;
				} else if (tile["type"] == "none") {
					initialGrid[tX][tY] = new ImpassableTile(tX, tY, textures[Util.TILE_NONE]);
				}
			}

			var floorEntities:Array = floorData["entities"];
			for (i = 0; i < floorEntities.length; i++) {
				var entity:Object = floorEntities[i];
				tX = entity["x"];
				tY = entity["y"];
				var textureName:String = entity["texture"];

				if (entity["type"] == "enemy") {
					var hp:int = entity["hp"];
					var attack:int = entity["attack"];
					var reward:int = entity["reward"];
					initialEntities[tX][tY] = new Enemy(tX, tY, textureName, textures[textureName], logger, hp, attack, reward);
				} else if (entity["type"] == "healing") {
					var health:int = entity["health"];
					initialEntities[tX][tY] = new Healing(tX, tY, textures[textureName], logger, health);
				} else if (entity["type"] == "objective") {
					var key:String = entity["key"];
					var prereqs:Array = entity["prereqs"];
					initialEntities[tX][tY] = new Objective(tX, tY, textures[textureName], logger, key, prereqs);
					objectiveState[key] = false;
				}
			}

			var tempFloorEntities:Array = floorData["temporary_entities"];
			for(i = 0; i < tempFloorEntities.length; i++) {
				// do something
			}

			rooms = new RoomSet(floorData["rooms"]);
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

		private function onEnterFrame(e:Event):void {
			addChild(char);

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
						if (logger) {
							logger.logAction(11, { "directionMoved":"North"});
						}
					}
				} else if (keyCode == Keyboard.DOWN && cgy < gridHeight - 1) {
					if(!grid[cgx][cgy+1]) {
						continue;
					}

					nextTile = grid[cgx][cgy+1];
					if(charTile.south && nextTile.north) {
						char.move(Util.SOUTH);
						if (logger) {
							logger.logAction(11, { "directionMoved":"South"});
						}
					}
				} else if (keyCode == Keyboard.LEFT && cgx > 0) {
					if(!grid[cgx-1][cgy]) {
						continue;
					}

					nextTile = grid[cgx-1][cgy];
					if(charTile.west && nextTile.east) {
						char.move(Util.WEST);
						if (logger) {
							logger.logAction(11, { "directionMoved":"West"});
						}
					}
				} else if (keyCode == Keyboard.RIGHT && cgx < gridWidth - 1) {
					if(!grid[cgx+1][cgy]) {
						continue;
					}

					nextTile = grid[cgx+1][cgy];
					if(charTile.east && nextTile.west) {
						char.move(Util.EAST);
						if (logger) {
							logger.logAction(11, { "directionMoved":"East"});
						}
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
		private function onCharArrived(e:GameEvent):void {
			var entity:Entity = entityGrid[e.x][e.y];
			if (!entity) {
				return;
			}
			entity.handleChar(char);
		}

		public function onCombatSuccess(enemy:Enemy):void {
			entityGrid[enemy.grid_x][enemy.grid_y] = null;
			removeChild(enemy);
		}

		// Event handler for when a character arrives at an exit tile.
		// The event chain goes: character -> floor -> tile -> floor.
		private function onCharExited(e:GameEvent):void {
			// TODO: Do actual win condition handling.
			/*if (logger) {
				logger.logLevelEnd({
					"characterHpRemaining":char.hp,
					"characterMaxHP":char.maxHp
				});
			}*/
			completed = true;

			mixer.play(Util.FLOOR_COMPLETE);

			var winBox:Sprite = new Sprite();
			var popup:Image = new Image(textures[Util.POPUP_BACKGROUND])
			winBox.addChild(popup);
			winBox.addChild(new TextField(popup.width, popup.height, NEXT_LEVEL_MESSAGE, Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE));
			winBox.x = (Util.STAGE_WIDTH - winBox.width) / 2 - this.parent.x;
			winBox.y = (Util.STAGE_HEIGHT - winBox.height) / 2 - this.parent.y;
		}

		// Called when the character moves into an objective tile. Updates objectiveState
		// to mark the tile as visited.
		// Event chain: Character -> Floor -> ObjectiveTile -> Floor
		private function onObjCompleted(e:GameEvent):void {
			var obj:Objective = entityGrid[e.x][e.y];
			objectiveState[obj.key] = true;
		}

		private function onRoomReveal(event:GameEvent):void {
			mixer.play(Util.COMBAT_FAILURE);

			rooms.tStatus.text = "reveal";

			if(!event.hasData) {
				return;
			}

			var coords:Array = event.gameData[0];
			var point:Point;
			for each(point in coords) {
				if(fogGrid[point.x][point.y]) {
					removeChild(fogGrid[point.x][point.y]);
					fogGrid[point.x][point.y] = false;
				}
			}
		}
	}
}
