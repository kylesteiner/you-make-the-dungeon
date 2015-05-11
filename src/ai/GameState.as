package ai {
	import tiles.*;
	import Util;

	public class GameState {
		public var char:CharState;

		// 2D array of TileStates.
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
			// TODO: convert a floor into a GameState
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
			var nextEntities = new Array(gridWidth);
			for (var i:int = 0; i < gridWidth; i++) {
				nextEntities[i] = new Array(gridHeight);
			}
			for (var j:int = 0; j < gridWidth; j++) {
				for (var k:int = 0; k < gridHeight; k++) {
					if (entities[j][k]) {
						var e:EntityState = entities[j][k];
						nextEntities[j][k] = new EntityState(e.type, e.hp, e.attack, e.xpReward, e.health, e.key);
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
					// TODO: write combat rules.
				}
				if (entity is HealingState) {
					var heal:HealingState = entity;
					heal.healCharacter(nextChar);
					nextEntities[nextChar.x][nextChar.y] = null;
				}
				if (entity is ObjectiveState) {
					var obj:ObjectiveState = entity;
					nextObj[obj.key] = true;
					nextEntities[nextChar.x][nextChar.y] = null;
				}
			}
		}
	}
}
