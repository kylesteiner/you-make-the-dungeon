// Floor.as
// Stores the state of a single floor.

package {
	import flash.ui.Keyboard;
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
		public static const NEXT_LEVEL_MESSAGE:String = "You did it!\nThanks for playing the demo!\nClick here to return the the main menu."

		public var grid:Array;			// 2D Array of Tiles.
		public var entityGrid:Array;	// 2D Array of Entities.
		public var fogGrid:Array;		// 2D Array of fog Images.
		public var goldGrid:Array;		// 2D Array of gold to be populated each run phase
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
		// Revealed enemies that randomly walk about the floor.
		public var activeEnemies:Array;

		// Floor metadata and control flow.
		private var floorFiles:Dictionary;
		private var onCompleteCallback:Function;
		public var altCallback:Function;

		// Room metadata and control flow
		public var rooms:RoomSet;
		public var roomFunctions:Dictionary();
		
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
		
		// Summary and related state.
		public var runSummary:Summary;
		private var preHealth:int;

		private var totalRuns:int;

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
							  runSummary:Summary,
							  showPrompt:int = 0) {
			super();
			this.textures = textures;
			this.animations = animations;
			this.initialHp = initialHp;
			this.initialStamina = initialStamina;
			this.initialAttack = initialAttack;
			initialLoS = initialLineOfSight;
			this.runSummary = runSummary;
			totalRuns = 0;

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
			goldGrid = initializeGrid(gridWidth, gridHeight);

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

				if (fogGrid[tX][tY]) {
					setChildIndex(fogGrid[tX][tY], numChildren - 1); // Move fog tile to front
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

				if (fogGrid[tX][tY]) {
					setChildIndex(fogGrid[tX][tY], numChildren - 1); // Move fog tile to front
				}
			}
			
			roomFunctions = new Dictionary();
			//roomFunctions[Util.ROOMCB_NONE] = SOME FUNCTION
			rooms = new RoomSet(floorData["rooms"], roomFunctions);

			highlightedLocations = new Array(gridWidth);
			for (i = 0; i < gridWidth; i++) {
				highlightedLocations[i] = new Array(gridHeight);
			}

			addChild(char);
			addChild(rooms);

			// Tile events bubble up from Tile and Character, so we
			// don't have to register an event listener on every child class.
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(GameEvent.ARRIVED_AT_TILE, onCharArrived);
			addEventListener(GameEvent.ARRIVED_AT_EXIT, onCharExited);
			addEventListener(GameEvent.REVEAL_ROOM, onRoomReveal);
			addEventListener(GameEvent.OBJ_COMPLETED, onObjCompleted);
			addEventListener(GameEvent.HEALED, onHeal);
			addEventListener(GameEvent.MOVING, onCharMoving);
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

		public function toggleRun(gameState:String):void {
			char.toggleRunUI();
			pressedKeys = new Array();

			// Ensure that the character and all enemies are higher in the
			// display order than the tiles.
			removeChild(char);
			addChild(char);
			for each (var enemy:Enemy in activeEnemies) {
				removeChild(enemy);
				addChild(enemy);
			}

			if(gameState == Game.STATE_RUN) {
				totalRuns += 1;
			}

			var x:int; var y:int;
			var goldSprite:Coin;
			for(x = 0; x < gridWidth; x++) {
				for(y = 0; y < gridHeight; y++) {
					removeChild(goldGrid[x][y]);

					if (grid[x][y]
						&& !(grid[x][y] is ImpassableTile)
						&& !fogGrid[x][y]
						&& !(char.grid_x == x && char.grid_y == y)
						&& gameState == Game.STATE_RUN) {
						goldSprite = new Coin(x, y, textures[Util.ICON_GOLD], Util.randomRange(1, 1 + totalRuns / 15));
						goldGrid[x][y] = goldSprite;
						addChild(goldSprite);
					}
				}
			}

			// Temporary rewards code
			if(goldGrid[3][3]) {
				goldGrid[3][3].gold = 100;
			}

			if(goldGrid[2][27]) {
				goldGrid[2][27].gold = 100;
			}

			if(goldGrid[14][19]) {
				goldGrid[14][19].gold = 30;
			}

			if(goldGrid[16][1]) {
				goldGrid[16][1].gold = 100;
			}

			if(goldGrid[19][9]) {
				goldGrid[19][9].gold = 50;
			}

			if(goldGrid[26][24]) {
				goldGrid[26][24].gold = 100;
			}

			if(goldGrid[28][3]) {
				goldGrid[28][3].gold = 75;
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

		// Resets the floor after a run.
		public function resetFloor():void {
			clearHighlightedLocations();

			char.reset();

			for each (var enemy:Enemy in activeEnemies) {
				enemy.reset();
				entityGrid[enemy.grid_x][enemy.grid_y] = enemy;
			}

			while (removedEntities.length > 0) {
				var entity:Entity = removedEntities.pop();
				entity.reset();
				entityGrid[entity.grid_x][entity.grid_y] = entity;
				addChild(entity);

				if (entity is Enemy) {
					var enemyEntity:Enemy = entity as Enemy;
					activeEnemies.push(enemyEntity);
				}
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
						addBool = isEmptyTile(grid[x][y]) && grid[x][y].deletable;
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

		public function updateRunSpeed():void {
			char.speed = Util.speed;
			for (var x:int = 0; x < gridWidth; x++) {
				for (var y:int = 0; y < gridHeight; y++) {
					if (entityGrid[x][y] is Enemy) {
						var enemy:Enemy = entityGrid[x][y] as Enemy;
						enemy.speed = Util.speed;
					}
				}
			}

			for (var i:int = 0; i < removedEntities.length; i++) {
				if (removedEntities[i] is Enemy) {
					var removedEnemy:Enemy = removedEntities[i] as Enemy;
					removedEnemy.speed = Util.speed;
				}
			}
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
			if (entity && entity.deletable) {
				removeChild(entity);
				entityGrid[entity.grid_x][entity.grid_y] = null;
				removeEnemyFromActive(entity);
				Util.logger.logAction(12, {
					"deleted":"entity",
					"costOfDeleted":entity.cost
				});
				return true;
			} else if (isEmptyTile(tile) && tile.deletable) {
				removeChild(tile);
				grid[tile.grid_x][tile.grid_y] = null;
				Util.logger.logAction(12, {
					"deleted":"tile",
					"costOfTile":tile.cost
				} );
				return true;
			}
			return false;
		}

		// Removes the enemy from activeEnemies because there isn't a basic
		// remove from array function
		private function removeEnemyFromActive(entity:Entity):void {
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
			if(tutorialImage && tutorialDisplaying) {
				addChild(tutorialImage);
			}

			var keyCode:uint;
			var cgx:int; var cgy:int;
			var charTile:Tile; var nextTile:Tile;

			if (char.moving) {
				return;
			}

			if (grid[char.grid_x][char.grid_y] is ExitTile && !completed) {
				dispatchEvent(new GameEvent(GameEvent.ARRIVED_AT_EXIT, char.grid_x, char.grid_y));
			}

			for each (keyCode in pressedKeys) {
				cgx = Util.real_to_grid(char.x);
				cgy = Util.real_to_grid(char.y);

				if(!grid[cgx][cgy]) {
					continue; // empty tile, invalid state
				}

				charTile = grid[cgx][cgy];
				if ((keyCode == Keyboard.UP || keyCode == Util.UP_KEY) && cgy > 0) {
					if(!grid[cgx][cgy-1]) {
						continue;
					}

					nextTile = grid[cgx][cgy-1];
					if (charTile.north && nextTile.south) {
						char.move(Util.NORTH);
					}
				} else if ((keyCode == Keyboard.DOWN || keyCode == Util.DOWN_KEY) && cgy < gridHeight - 1) {
					if(!grid[cgx][cgy+1]) {
						continue;
					}

					nextTile = grid[cgx][cgy+1];
					if (charTile.south && nextTile.north) {
						char.move(Util.SOUTH);

					}
				} else if ((keyCode == Keyboard.LEFT || keyCode == Util.LEFT_KEY) && cgx > 0) {
					if(!grid[cgx-1][cgy]) {
						continue;
					}

					nextTile = grid[cgx-1][cgy];
					if (charTile.west && nextTile.east) {
						char.move(Util.WEST);
					}
				} else if ((keyCode == Keyboard.RIGHT || keyCode == Util.RIGHT_KEY) && cgx < gridWidth - 1) {
					if(!grid[cgx+1][cgy]) {
						continue;
					}

					nextTile = grid[cgx+1][cgy];
					if (charTile.east && nextTile.west) {
						char.move(Util.EAST);
					}
				}
			}
		}

		private function moveAllEnemies():void {
			for each (var enemy:Enemy in activeEnemies) {
				if (enemy.stationary) {
					continue;
				}
				if (char.grid_x == enemy.grid_x && char.grid_y == enemy.grid_y) {
					continue;
				}

				// Determine which moves are legal for the Enemy.
				var possibleDirections:Array = new Array();
				// North
				if (enemy.grid_y > 0
					&& grid[enemy.grid_x][enemy.grid_y-1]
					&& grid[enemy.grid_x][enemy.grid_y-1].south
					&& entityGrid[enemy.grid_x][enemy.grid_y-1] == null) {
					possibleDirections.push(Util.NORTH);
				}
				// South
				if (enemy.grid_y < gridHeight - 1
					&& grid[enemy.grid_x][enemy.grid_y+1]
					&& grid[enemy.grid_x][enemy.grid_y+1].north
					&& entityGrid[enemy.grid_x][enemy.grid_y+1] == null) {
					possibleDirections.push(Util.SOUTH);
				}
				// East
				if (enemy.grid_x < gridWidth - 1
					&& grid[enemy.grid_x+1][enemy.grid_y]
					&& grid[enemy.grid_x+1][enemy.grid_y].west
					&& entityGrid[enemy.grid_x+1][enemy.grid_y] == null) {
					possibleDirections.push(Util.EAST);
				}
				// West
				if (enemy.grid_x > 0
					&& grid[enemy.grid_x-1][enemy.grid_y]
					&& grid[enemy.grid_x-1][enemy.grid_y].east
					&& entityGrid[enemy.grid_x-1][enemy.grid_y] == null) {
					possibleDirections.push(Util.WEST);
				}

				// If the enemy has no options, then stay put.
				if (possibleDirections.length == 0) {
					continue;
				}

				// Pick a random direction for the enemy to move to.
				var direction:int = possibleDirections[Util.randomRange(0, possibleDirections.length - 1)];

				// If the character is already at that location, then don't move
				// (this prevents the enemies from being too tricky to corner)
				if (direction == Util.NORTH
					&& enemy.grid_x == char.grid_x
					&& enemy.grid_y - 1 == char.grid_y) {
					continue;
				}
				if (direction == Util.SOUTH
					&& enemy.grid_x == char.grid_x
					&& enemy.grid_y + 1 == char.grid_y) {
					continue;
				}
				if (direction == Util.EAST
					&& enemy.grid_x + 1 == char.grid_x
					&& enemy.grid_y == char.grid_y) {
					continue;
				}
				if (direction == Util.WEST
					&& enemy.grid_x - 1== char.grid_x
					&& enemy.grid_y == char.grid_y) {
					continue;
				}

				// Move the entity's position in the entityGrid.
				entityGrid[enemy.grid_x][enemy.grid_y] = null;
				switch (direction) {
					case Util.NORTH:
						entityGrid[enemy.grid_x][enemy.grid_y - 1] = enemy;
						break;
					case Util.SOUTH:
						entityGrid[enemy.grid_x][enemy.grid_y + 1] = enemy;
						break;
					case Util.EAST:
						entityGrid[enemy.grid_x + 1][enemy.grid_y] = enemy;
						break;
					case Util.WEST:
						entityGrid[enemy.grid_x - 1][enemy.grid_y] = enemy;
						break;
				}
				// Command the enemy to move.
				enemy.move(direction);
			}
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if(!char.runState) {
				return;
			}

			Util.logger.logAction(16, {
				"keyPressedCode":event.keyCode
			});

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

		// When the character's new direction is set, we will move all of the
		// enemies.
		private function onCharMoving(e:GameEvent):void {
			moveAllEnemies();
		}

		// When a character arrives at a tile, it fires an event up to Floor.
		// Find the tile it arrived at and call its handleChar() function.
		private function onCharArrived(e:GameEvent):void {
			preHealth = char.hp;
			runSummary.distanceTraveled++;

			if (goldGrid[char.grid_x][char.grid_y]) {
				dispatchEvent(new GameEvent(GameEvent.GAIN_GOLD, char.grid_x, char.grid_y));
			}

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
			//winBox.x = (Util.STAGE_WIDTH - winBox.width) / 2 - this.parent.x;
			//winBox.y = (Util.STAGE_HEIGHT - winBox.height) / 2 - this.parent.y;

			var nC:Clickable = new Clickable(0, 0, onCompleteCallback, winBox);
			addChild(nC);
		}

		// Called after the character defeats an enemy entity.
		public function onCombatSuccess(enemy:Enemy):void {
			removeEnemyFromActive(enemy);
			removedEntities.push(enemy);
			entityGrid[enemy.grid_x][enemy.grid_y] = null;
			removeChild(enemy);
			char.inCombat = false;
			Util.logger.logAction(17, {
				"characterHealthLeft":char.hp,
				"characterHealthMax":char.maxHp,
				"characterStaminaLeft":char.stamina,
				"characterStaminaMax":char.maxStamina,
				"characterAttack":char.attack,
				"enemyHealth":enemy.hp,
				"enemyAttack":enemy.attack,
				"reward":enemy.reward
			});

			runSummary.enemiesDefeated++;
			runSummary.damageTaken += preHealth - char.hp;
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

			runSummary.amountHealed += char.hp - preHealth;
		}

		private function onRoomReveal(event:GameEvent):void {
			mixer.play(Util.COMBAT_FAILURE);

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
