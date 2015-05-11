package ai {
	import tiles.*;
	import Util;

	public class GameState {
		public var char:CharState;

		// 2D array of TileStates. This doesn't change across GameStates, so we
		// will pass the same reference around.
		public var grid:Array;
		public var gridHeight:int;
		public var gridWidth:int;

		// 2D array of {Healing|Objective|Enemy}State, mapped to the grid.
		public var entities:Array;

		// Dictionary of visited objectives.
		public var visitedObj:Dictionary;

		// Location of the exit.
		public var exitX:int;
		public var exitY:int;

		public function GameState(floor:Floor) {
			char = floor.char.state;

			// Initialize the grids.
			gridHeight = floor.gridHeight;
			gridWidth = floor.gridWidth;
			grid = Util.initializeGrid(gridWidth, gridHeight);
			entities = Util.initializeGrid(gridWidth, gridHeight);

			// Copy and translate tiles into EntityState and GridState.
			for (var i:int = 0; i < gridWidth; i++) {
				for (var j:int = 0; i < gridHeight; j++) {
					var t:Tile = floor.grid[i][j]
					grid[i][j] = new TileState(t.grid_x, t.grid_y, t.north, t.south, t.east, t.west);
					if (t is EnemyTile) {
						var enemy:EnemyTile = t;
						entities[i][j] = new EnemyState(enemy.state.hp, enemy.state.attack, enemy.state.xpReward);
					}
					if (t is HealingTile) {
						var heal:HealingTile = t;
						entities[i][j] = new HealingState(heal.state.health);
					}
					if (t is ObjectiveTile) {
						var obj:ObjectiveTile = t;
						// Need to deep copy the prereqs array.
						var prereqs:Array = new Array();
						for (var k:int = 0; k < obj.state.prereqs.length; k++) {
							prereqs.push(obj.state.prereqs[k]);
						}
						entities[i][j] = new ObjectiveState(obj.state.key, prereqs);
					}
				}
			}

			visitedObj = new Dictionary();

			var exit:Tile = floor.getExit();
			exitX = exit.grid_x;
			exitY = exit.grid_y;
		}

		public function GameState(char:CharState, grid:Array, entities:Array, visitedObj:Dictionary, exitX:int, exitY:int) {
			this.char = char;
			this.grid = grid;
			this.entities = entities;
			gridWidth = grid.length;
			gridHeight = grid[0].length;
			this.visitedObj = visitedObj;
			this.exitX = exitX;
			this.exitY = exitY;
		}

		public function getLegalActions():Array {
			var actions:Array = new Array();
			var tile:TileState = grid[char.x][char.y];
			if (tile.north
				&& char.y > 0
				&& grid[char.x][char.y - 1]
				&& grid[char.x][char.y - 1].south
				&& satisfiedObjectives(char.x, char.y - 1)) {
				array.push(Util.NORTH);
			}
			if (tile.south
				&& char.y < gridHeight - 1
				&& grid[char.x][char.y + 1]
				&& grid[char.x][char.y + 1].north
				&& satisfiedObjectives(char.x, char.y + 1)) {
				array.push(Util.SOUTH);
			}
			if (tile.east
				&& char.x > 0
				&& grid[char.x - 1][char.y]
				&& grid[char.x - 1][char.y].west
				&& satisfiedObjectives(char.x - 1, char.y)) {
				array.push(Util.EAST);
			}
			if (tile.west
				&& char.x < gridWidth
				&& grid[char.x + 1][char.y]
				&& grid[char.x + 1][char.y]
				&& satisfiedObjectives(char.x + 1, char.y)) {
				array.push(Util.WEST);
			}
			return actions;
		}

		// Returns whether the character has satisfied the prerequisites for
		// the objective at (x,y). If there is no objective at (x,y), returns
		// true.
		private function satisfiedObjectives(x:int, y:int):Boolean {
			var entity:Object = entities[x][y];
			// Check if the objective exists first.
			if (!entity || !(entity is ObjectiveState)) {
				return true;
			}

			// Loop through the objective's prereqs and make sure they have
			// all been visited.
			var obj:ObjectiveState = entity;
			for (var i:int = 0; i < obj.prereqs.length; i++) {
				var prereq:String = obj.prereqs[i];
				if (!visitedObj[prereq]) {
					return false;
				}
			}
			return true;
		}

		// Assumes that action is a legal action.
		public function generateSuccessor(action:int):GameState {
			// Make a copy of char.
			var nextChar:CharState = new CharState(char.x, char.y, char.xp, char.level, char.maxHp, char.hp, char.attack);

			// Make a deep copy of entities.
			var nextEntities = Util.initializeGrid(gridWidth, gridHeight);
			for (var i:int = 0; i < gridWidth; i++) {
				for (var k:int = 0; j < gridHeight; j++) {
					if (entities[i][j]) {
						var e:Object = entities[i][j];
						if (e is HealingState) {
							var heal:HealingState = e;
							nextEntities[i][j] = new HealingState(heal.health);
						}
						if (e is ObjectiveState) {
							var obj:ObjectiveState = e;
							// Need to deep copy the prereqs array.
							var prereqs:Array = new Array();
							for (var k:int = 0; k < obj.prereqs.length; k++) {
								prereqs.push(obj.state.prereqs[k]);
							}
							entities[i][j] = new ObjectiveState(obj.key, prereqs);
						}
						if (e is EnemyState) {
							var enemy:EnemyState = e;
							entities[i][j] = new EnemyState(enemy.hp, enemy.attack, enemy.xpReward);
						}
					}
				}
			}

			// Make a deep copy of visitedObj.
			var nextObj:Dictionary = new Dictionary();
			for (var o:Object in visitedObj) {
    			var obj:String = String(o);
    			var val:Boolean = Boolean(visitedObj[obj]);
				nextObj[obj] = val;
			}

			// Set the next character position.
			switch (action) {
				case Util.NORTH:
					nextChar.y--;
				case Util.SOUTH:
					nextChar.y++;
				case Util.EAST:
					nextChar.x--;
				case Util.WEST:
					nextChar.x++;
			}

			// Calculate character-entity interaction
			if (nextEntities[nextChar.x][nextChar.y]) {
				var entity:Object = nextEntities[nextChar.x][nextChar.y];
				if (entity is EnemyState) {
					var enemy:EnemyState = entity;
					// Run combat loop until someone dies.
					while (nextChar.hp > 0 && enemy.hp > 0) {
						Combat.charAttacksEnemy(nextChar, enemy);
						if (nextChar.hp <= 0) {
							break;
						}
						Combat.enemyAttacksChar(nextChar, enemy);
					}
					if (enemy.hp <= 0) {
						// Remove enemy entity if char won.
						nextEntities[nextChar.x][nextChar.y] == null;
					}
				}
				if (entity is HealingState) {
					var heal:HealingState = entity;
					var healed:Boolean = heal.healCharacter(nextChar);
					if (healed) {
						// Only remove the healing entity if it was used.
						nextEntities[nextChar.x][nextChar.y] = null;
					}
				}
				if (entity is ObjectiveState) {
					var obj:ObjectiveState = entity;
					nextObj[obj.key] = true;
					nextEntities[nextChar.x][nextChar.y] = null;
				}
			}

			// The grid and exits won't change. Only the character, entities,
			// and objective log will change.
			return new GameState(nextChar, grid, nextEntities, nextObj, exitX, exitY);
		}
	}
}
