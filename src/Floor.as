// Floor.as
// Stores the state of a single floor.

package {
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import mx.utils.StringUtil;

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
		public var gridHeight:int;
		public var gridWidth:int;
		public var preplacedTiles:int;
		public var completed:Boolean;

		// Character's initial stats.
		private var initialX:int;
		private var initialY:int;
		private var initialHp:int;
		private var initialStamina:int;
		private var initialAttack:int;
		private var initialLoS:int;

		// Entities that have been removed in by character actions the run phase
		// but need to be replaced after the run phase.
		private var removedEntities:Array;

		// Floor metadata and control flow.
		private var floorFiles:Dictionary;
		private var nextFloor:String;
		private var nextTransition:String;
		private var onCompleteCallback:Function;
		public var altCallback:Function;

		// Assets.
		private var textures:Dictionary;
		private var animations:Dictionary;
		private var mixer:Mixer;

		// Tutorial UI elements.
		public var tutorialImage:Image;
		private var tutorialDisplaying:Boolean;
		private var originalTutorialDisplaying:Boolean;

		// Array for storing user key presses.
		public var pressedKeys:Array;

		// Revealed enemies that randomly walk about the floor.
		public var activeEnemies:Array;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Floor(floorDataString:String,
							  textures:Dictionary,
							  animations:Dictionary,
							  initialHp:int,
							  initialStamina:int,
							  initialAttack:int,
							  initialLineOfSight:int,
							  floorFiles:Dictionary,
							  nextFloorCallback:Function,
							  soundMixer:Mixer,
							  showPrompt:int = 0) {
			super();
			this.textures = textures;
			this.animations = animations;
			this.initialHp = initialHp;
			this.initialStamina = initialStamina;
			this.initialAttack = initialAttack;
			initialLoS = initialLineOfSight;

			this.floorFiles = floorFiles;
			onCompleteCallback = nextFloorCallback;
			altCallback = null;
			mixer = soundMixer;

			preplacedTiles = 0;

			pressedKeys = new Array();
			objectiveState = new Dictionary();
			removedEntities = new Array();
			activeEnemies = new Array();

			// Parse the floor layout information from the JSON file.
			var floorData:Object = JSON.parse(floorDataString);
			floorName = floorData["floor_name"];
			nextFloor = "LOL PLACEHOLDER";
			nextTransition = "LOL ALSO PLACEHOLDER";

			gridWidth = floorData["floor_dimensions"]["width"];
			gridHeight = floorData["floor_dimensions"]["height"];

			// Set up the background.
			var mapBoundsBackground:Image = new Image(textures[Util.GRID_BACKGROUND]);
			mapBoundsBackground.width = Util.PIXELS_PER_TILE * gridWidth + Util.PIXELS_PER_TILE * 0.2;
			mapBoundsBackground.height = Util.PIXELS_PER_TILE * gridHeight + Util.PIXELS_PER_TILE * 0.2;
			mapBoundsBackground.x = - Util.PIXELS_PER_TILE * 0.1;
			mapBoundsBackground.y = - Util.PIXELS_PER_TILE * 0.1
			addChild(mapBoundsBackground);

			// Initialize all grids.
			grid = initializeGrid(gridWidth, gridHeight);
			fogGrid = initializeGrid(gridWidth, gridHeight);
			entityGrid = initializeGrid(gridWidth, gridHeight);

			var i:int;
			var j:int;
			// Add a fog image at every grid tile.
			for (i = 0; i < gridWidth; i++) {
				for (j = 0; j < gridHeight; j++) {
					var fog:Image = new Image(textures[Util.TILE_FOG]);
					fog.x = i * Util.PIXELS_PER_TILE;
					fog.y = j * Util.PIXELS_PER_TILE;
					fogGrid[i][j] = fog;
					addChild(fog);
				}
			}

			char = new Character(floorData["character_start"]["x"],
								 floorData["character_start"]["y"],
								 initialHp,
								 initialStamina,
								 initialAttack,
								 initialLoS,
								 animations[Util.CHARACTER],
								 textures[Util.ICON_ATK]);

			var tType:String;
			var tX:int; var tY:int;
			var tN:Boolean; var tS:Boolean; var tE:Boolean; var tW:Boolean;
			var tTexture:Texture;

			// Parse the tiles and place them on the grid.
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
					var t:Tile = new Tile(tX, tY, tN, tS, tE, tW, tTexture);
					grid[tX][tY] = t;
					addChild(t);
				} else if (tile["type"] == "entry") {
					var en:EntryTile = new EntryTile(tX, tY, tN, tS, tE, tW, tTexture);
					grid[tX][tY] = en;
					addChild(en);
					removeChild(fogGrid[tX][tY]);
					fogGrid[tX][tY] = null;
					removeFoggedLocations(tX, tY);
				} else if (tile["type"] == "exit") {
					var ex:ExitTile = new ExitTile(tX, tY, tN, tS, tE, tW, tTexture);
					grid[tX][tY] = ex;
					addChild(ex);
					removeChild(fogGrid[tX][tY]);
					fogGrid[tX][tY] = null;
				} else if (tile["type"] == "none") {
					var im:ImpassableTile = new ImpassableTile(tX, tY, textures[Util.TILE_NONE]);
					grid[tX][tY] = im;
					addChild(im);
				}
			}

			// Parse the entities and place them on the entityGrid.
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
					var enemy:Enemy = new Enemy(tX, tY, textureName, textures[textureName], hp, attack, reward);
					entityGrid[tX][tY] = enemy;
					addChild(enemy);
				} else if (entity["type"] == "healing") {
					var health:int = entity["health"];
					var healing:Healing = new Healing(tX, tY, textures[textureName], health);
					entityGrid[tX][tY] = healing;
					addChild(healing);
				} else if (entity["type"] == "objective") {
					var key:String = entity["key"];
					var prereqs:Array = entity["prereqs"];
					var obj:Objective = new Objective(tX, tY, textures[textureName], key, prereqs);
					entityGrid[tX][tY] = obj;
					objectiveState[key] = false;
					addChild(obj);
				}
			}

			highlightedLocations = new Array(gridWidth);
			for (i = 0; i < gridWidth; i++) {
				highlightedLocations[i] = new Array(gridHeight);
			}

			// Tile events bubble up from Tile and Character, so we
			// don't have to register an event listener on every child class.
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(GameEvent.ARRIVED_AT_TILE, onCharArrived);
			addEventListener(GameEvent.ARRIVED_AT_EXIT, onCharExited);
			addEventListener(GameEvent.OBJ_COMPLETED, onObjCompleted);
			addEventListener(GameEvent.HEALED, onHeal);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
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
			char.toggleRunUI();
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

		// Resets the floor after a run.
		public function resetFloor():void {
			clearHighlightedLocations();

			char.reset();

			while (removedEntities.length > 0) {
				var entity:Entity = removedEntities.pop();
				entity.reset();
				entityGrid[entity.grid_x][entity.grid_y] = entity;
				addChild(entity);
			}

			for (var k:Object in objectiveState) {
				var key:String = String(k);
				objectiveState[key] = false;
			}
		}

		// given an i and j (x and y) [position on the grid], removes the fogged locations around it
		// does 2 in each direction, and one in every diagonal direction
		public function removeFoggedLocations(i:int, j:int):void {
			var x:int; var y:int;

			var radius:int = char.los;

			for (x = i - radius; x <= i + radius; x++) {
				if (x >= 0 && x < gridWidth) {
					for (y = j - radius; y <= j + radius; y++) {
						if (y >= 0 && y < gridHeight) {
							if (Math.abs(x-i) + Math.abs(y-j) <= radius && fogGrid[x][y]) {
								removeChild(fogGrid[x][y]);
								fogGrid[x][y] = false;
								if (entityGrid[x][y] is Enemy) {
									activeEnemies.push(entityGrid[x][y]);
								}
							}
						}
					}
				}
			}
		}

		// Highlights tiles on the grid that the player can move the selected tile to.
		public function highlightAllowedLocations(directions:Array, hudState:String):void {
			var x:int; var y:int; var addBool:Boolean;
			var allowed:Array = hudState == BuildHUD.STATE_TILE ? getAllowedLocations(directions) : new Array();

			for(x = 0; x < gridWidth; x++) {
				for(y = 0; y < gridHeight; y++) {
					addBool = false;

					if(hudState == BuildHUD.STATE_TILE) {
						addBool = allowed[x][y];
					} else if(hudState == BuildHUD.STATE_ENTITY) {
						addBool = isEmptyTile(grid[x][y]) && !entityGrid[x][y] && !fogGrid[x][y];
					} else if(hudState == BuildHUD.STATE_DELETE) {
						addBool = isEmptyTile(grid[x][y]); // Add boolean for preplaced tiles
					}

					addRemoveHighlight(x, y, hudState, addBool);
				}
			}
		}

		public function isEmptyTile(tile:Tile):Boolean {
			return tile is Tile &&
				   !(tile is EntryTile) &&
				   !(tile is ExitTile) &&
				   !(tile is ImpassableTile) &&
				   !entityGrid[tile.grid_x][tile.grid_y];
		}

		private function addRemoveHighlight(x:int, y:int, hudState:String, add:Boolean):void {
			// Clear any old highlight at this location
			removeChild(highlightedLocations[x][y]);
			highlightedLocations[x][y] = null;

			if (add) {
				// Highlight available location on grid
				var textureString:String;
				var highlight:Image;

				if(hudState == BuildHUD.STATE_TILE) {
					textureString = Util.TILE_HL_TILE;
				} else if(hudState == BuildHUD.STATE_ENTITY) {
					textureString = Util.TILE_HL_ENTITY;
				} else if(hudState == BuildHUD.STATE_DELETE) {
					textureString = Util.TILE_HL_DEL;
				}

				highlight = new Image(textures[textureString]);
				highlight.x = x * Util.PIXELS_PER_TILE;
				highlight.y = y * Util.PIXELS_PER_TILE;
				highlightedLocations[x][y] = highlight;

				addChild(highlightedLocations[x][y]);
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
		private function getAllowedLocationsHelper(x:int,
			 									   y:int,
												   directions:Array,
												   visited:Array,
												   available:Array,
												   direction:int):void {
			if (visited[x][y]) {
				return;
			}

			if (!grid[x][y] &&
				((direction == Util.NORTH && directions[Util.NORTH])
				|| (direction == Util.SOUTH && directions[Util.SOUTH])
				|| (direction == Util.WEST && directions[Util.WEST])
				|| (direction == Util.EAST && directions[Util.EAST]))) {
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

		public function deleteSelected(tile:Tile, entity:Entity):Boolean {
			if (entity) {
				removeChild(entity);
				entityGrid[entity.grid_x][entity.grid_y] = null;
				removeEnemyFromArray(entity);
				return true;
			} else if (isEmptyTile(tile)) {
				removeChild(tile);
				grid[tile.grid_x][tile.grid_y] = null;
				return true;
			}
			return false;
		}

		// Removes the enemy from activeEnemies because there isn't a basic
		// remove from array function
		private function removeEnemyFromArray(entity:Entity):void {
			for (var i:int = 0; i < activeEnemies.length; i++) {
				if (activeEnemies[i] == entity) {
					activeEnemies.splice(i, 1);
				}
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

		private function onEnterFrame(e:Event):void {
			// Workaround because tiles are above the Character in the display
			// hierarchy after being placed.
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
					if (charTile.north && nextTile.south) {
						if (!char.inCombat && !char.moving) {
							moveAllEnemies(1);
						}
						char.move(Util.NORTH);
						if (Util.logger) {
							Util.logger.logAction(11, {
								"directionMoved": "North"
							});
						}
					}
				} else if (keyCode == Keyboard.DOWN && cgy < gridHeight - 1) {
					if(!grid[cgx][cgy+1]) {
						continue;
					}

					nextTile = grid[cgx][cgy+1];
					if (charTile.south && nextTile.north) {
						if (!char.inCombat && !char.moving) {
							moveAllEnemies(3);
						}
						char.move(Util.SOUTH);
						if (Util.logger) {
							Util.logger.logAction(11, {
								"directionMoved": "South"
							});
						}
					}
				} else if (keyCode == Keyboard.LEFT && cgx > 0) {
					if(!grid[cgx-1][cgy]) {
						continue;
					}

					nextTile = grid[cgx-1][cgy];
					if (charTile.west && nextTile.east) {
						if (!char.inCombat && !char.moving) {
							moveAllEnemies(2);
						}
						char.move(Util.WEST);
						if (Util.logger) {
							Util.logger.logAction(11, {
								"directionMoved": "West"
							});
						}
					}
				} else if (keyCode == Keyboard.RIGHT && cgx < gridWidth - 1) {
					if(!grid[cgx+1][cgy]) {
						continue;
					}

					nextTile = grid[cgx+1][cgy];
					if (charTile.east && nextTile.west) {
						if (!char.inCombat && !char.moving) {
							moveAllEnemies(0);
						}
						char.move(Util.EAST);
						if (Util.logger) {
							Util.logger.logAction(11, {
								"directionMoved": "East"
							});
						}
					}
				}
			}
		}

		private function moveAllEnemies(charDirection:int):void {
			var monster:Enemy; var x:int; var y:int;
			var tile:Tile;
			for each (monster in activeEnemies) {
				if (monster.stationary) {
					continue;
				}
				var notMoved:Boolean = true;
				var movement:Array = new Array();
				movement[0] = false;
				movement[1] = false;
				movement[2] = false;
				movement[3] = false;
				while (notMoved) {
					var direction:int = monster.currentDirection;
					tile = grid[monster.grid_x][monster.grid_y];
					if (movement[0] && movement[1] && movement[2] && movement[3]) {
						break;
					}
					// 0 means keep direction, 1 means pick the first
					// direction in if, 2 means the othe
					var randomPick:int = Math.random() * 100 % 3;
					if (direction == 0) { // east
						if (tile.north && randomPick == 1) {
							monster.currentDirection = 1;
							direction = 1;
						} else if (tile.south && randomPick == 2) {
							monster.currentDirection = 3;
							direction = 3;
						}
					} else if (direction == 1) { // north
						if (tile.east && randomPick == 1) {
							monster.currentDirection = 0;
							direction = 0;
						} else if (tile.west && randomPick == 2) {
							monster.currentDirection = 2;
							direction = 2;
						}
					} else if (direction == 2) { // west
						if (tile.west && randomPick == 1) {
							monster.currentDirection = 1;
							direction = 1;
						} else if (tile.south && randomPick == 2) {
							monster.currentDirection = 3;
							direction = 3;
						}
					} else { // south
						if (tile.east && randomPick == 1) {
							monster.currentDirection = 0;
							direction = 0;
						} else if (tile.west && randomPick == 2) {
							monster.currentDirection = 2;
							direction = 2;
						}
					}
					if (direction == 0) { // east
						if (tile.east && tile.grid_x != gridWidth - 1
								&& grid[tile.grid_x + 1][tile.grid_y]
								&& grid[tile.grid_x + 1][tile.grid_y].west) {
							// move monster east
							if (charDirection == 2 && char.grid_x == tile.grid_x + 1
									&& char.grid_y == tile.grid_y
									|| entityGrid[tile.grid_x + 1][tile.grid_y]) {
								notMoved = false;
							} else if (!entityGrid[tile.grid_x + 1][tile.grid_y]) {
								x = monster.grid_x;
								y = monster.grid_y;
								monster.move(monster.grid_x + 1, monster.grid_y);
								notMoved = false;
								entityGrid[x + 1][y] = entityGrid[x][y];
								entityGrid[x][y] = null;
							} else {
								monster.currentDirection = Math.random() * 100 % 4;
							}
						} else {
							// pick new random direction
							monster.currentDirection = Math.random() * 100 % 4;
						}
					} else if (direction == 1) { // north
						if (tile.north && tile.grid_y > 0
								&& grid[tile.grid_x][tile.grid_y - 1]
								&& grid[tile.grid_x][tile.grid_y - 1].south) {
							// move monster north
							if (charDirection == 3 && char.grid_x == tile.grid_x
									&& char.grid_y == tile.grid_y - 1
									|| entityGrid[tile.grid_x][tile.grid_y -1]) {
								notMoved = false;
							} else if (!entityGrid[tile.grid_x][tile.grid_y - 1]) {
								x = monster.grid_x;
								y = monster.grid_y;
								monster.move(monster.grid_x, monster.grid_y - 1);
								notMoved = false;
								entityGrid[x][y - 1] = entityGrid[x][y];
								entityGrid[x][y] = null;
							} else {
								monster.currentDirection = Math.random() * 100 % 4;
							}
						} else {
							// pick new random direction
							monster.currentDirection = Math.random() * 100 % 4;
						}
					} else if (direction == 2) { // west
						if (tile.west && tile.grid_x > 0
								&& grid[tile.grid_x - 1][tile.grid_y]
								&& grid[tile.grid_x - 1][tile.grid_y].east) {
							// move monster west
							if (charDirection == 0 && char.grid_x == tile.grid_x - 1
									&& char.grid_y == tile.grid_y) {
								notMoved = false;
							} else if (!entityGrid[tile.grid_x - 1][tile.grid_y]){
								x = monster.grid_x;
								y = monster.grid_y;
								monster.move(monster.grid_x - 1, monster.grid_y);
								notMoved = false;
								entityGrid[x - 1][y] = entityGrid[x][y];
								entityGrid[x][y] = null;
							} else {
								monster.currentDirection = Math.random() * 100 % 4;
							}
						} else {
							// pick new random direction
							monster.currentDirection = Math.random() * 100 % 4;
						}
					} else { // direction equals 3, south
						if (tile.south && tile.grid_y != gridHeight - 1
								&& grid[tile.grid_x][tile.grid_y + 1]
								&& grid[tile.grid_x][tile.grid_y + 1].north) {
							// move monster south
							if (charDirection == 1 && char.grid_x == tile.grid_x
									&& char.grid_y == tile.grid_y + 1) {
								notMoved = false;
							} else if (!entityGrid[tile.grid_x][tile.grid_y + 1]) {
								x = monster.grid_x;
								y = monster.grid_y;
								monster.move(monster.grid_x, monster.grid_y + 1);
								notMoved = false;
								entityGrid[x][y + 1] = entityGrid[x][y];
								entityGrid[x][y] = null;
							} else {
								monster.currentDirection = Math.random() * 100 % 4;
							}
						} else {
							// pick new random direction
							monster.currentDirection = Math.random() * 100 % 4;
						}
					}
					movement[direction] = true;
				}
				trace("moved");
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

		// Event handler for when a character arrives at an exit tile.
		private function onCharExited(e:GameEvent):void {
			if (Util.logger) {
				Util.logger.logLevelEnd({
					"characterHpRemaining":char.hp,
					"characterMaxHP":char.maxHp
				});
			}
			completed = true;

			mixer.play(Util.FLOOR_COMPLETE);

			var winBox:Sprite = new Sprite();
			var popup:Image = new Image(textures[Util.POPUP_BACKGROUND])
			winBox.addChild(popup);
			winBox.addChild(new TextField(popup.width,
										  popup.height,
										  NEXT_LEVEL_MESSAGE,
										  Util.DEFAULT_FONT,
										  Util.MEDIUM_FONT_SIZE));
			winBox.x = (Util.STAGE_WIDTH - winBox.width) / 2 - this.parent.x;
			winBox.y = (Util.STAGE_HEIGHT - winBox.height) / 2 - this.parent.y;
		}

		// Called after the character defeats an enemy entity.
		public function onCombatSuccess(enemy:Enemy):void {
			removedEntities.push(enemy);
			entityGrid[enemy.grid_x][enemy.grid_y] = null;
			removeChild(enemy);
		}

		// Called when the character moves into an objective tile. Updates
		// objectiveState to mark the tile as visited.
		private function onObjCompleted(e:GameEvent):void {
			var obj:Objective = entityGrid[e.x][e.y];
			objectiveState[obj.key] = true;
			removedEntities.push(obj);
			entityGrid[e.x][e.y] = null;
			removeChild(obj);
		}

		// Called when the character is healed.
		private function onHeal(e:GameEvent):void {
			var heal:Healing = entityGrid[e.x][e.y];
			removedEntities.push(heal);
			entityGrid[e.x][e.y] = null;
			removeChild(heal);
		}
	}
}
