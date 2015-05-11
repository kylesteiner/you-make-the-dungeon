package ai {
	import tiles.*;
	import Util;

	public class GameState {
		public var char:CharState;

		public var grid:Array;  // 2D array of TileStates.
		public var gridHeight:int;
		public var gridWidth:int;

		public var entities:Array; // 2D array of EntityStates, mapped to the grid.

		public var objState:Dictionary;

		public var exitX;
		public var exitY;

		public function GameState(floor:Floor) {
			// TODO: convert a floor into a GameState
		}

		public function GameState(char:CharState, grid:Array, entities:Array, objState:Dictionary, exitX:int, exitY:int) {
			this.char = char;
			this.grid = grid;
			this.entities = entities;
			gridWidth = grid.length;
			gridHeight = grid[0].length;
			this.objState = objState;
			this.exitX = exitX;
			this.exitY = exitY;
		}

		public function getLegalActions():Array {
			var actions:Array = new Array();
			var tile:Tile = grid[char.x][char.y];
			if (tile.north
				&& char.y > 0
				&& grid[char.x][char.y - 1]
				&& grid[char.x][char.y - 1].south) {
				array.push(Util.NORTH);
			}
			if (tile.south
				&& char.y < gridHeight - 1
				&& grid[char.x][char.y + 1]
				&& grid[char.x][char.y + 1].north) {
				array.push(Util.SOUTH);
			}
			if (tile.east
				&& char.x > 0
				&& grid[char.x - 1][char.y]
				&& grid[char.x - 1][char.y].west) {
				array.push(Util.EAST);
			}
			if (tile.west
				&& char.x < gridWidth
				&& grid[char.x + 1][char.y]
				&& grid[char.x + 1][char.y]) {
				array.push(Util.WEST);
			}
			return actions;
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

			// Make a deep copy of objState.
			var nextObj:Dictionary = new Dictionary();
			for (var o:Object in objState) {
    			var obj:String = String(o);
    			var val:Boolean = Boolean(objState[obj]);
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
