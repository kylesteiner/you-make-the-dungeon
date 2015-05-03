// Level.as
// Stores the state of a single floor.

package {
	import flash.display.Sprite;
	import starling.core.Starling;
	import Util;
	import Tile;
	import Character;

	public class Level extends Sprite{
		// 2D Array of Tiles. Represents the current state of all tiles.
		public var grid:Array;
		public var char:Character;

		private var initialGrid:Array;
		private var initialXp:int;

		// grid: The initial layout of the floor.
		// xp: The initial XP of the character.
		public function Level(grid:Array, xp:int) {
			initialGrid = grid;
			initialXp = xp;
			grid = new Array(grid.length);
			resetGrid();
		}

		// Resets the character and grid state to their initial values.
		private function resetLevel() {
			// Remove all tiles from the display tree.
			for (var i:int = 0; i < grid.length; i++) {
				for (var j:int = 0; j < grid[i].length; j++) {
					// TODO: figure out it it is necessary to dispose of the
					// tile here.
					grid[i][j].removeFromParent();
				}
			}

			// Add all of the initial tiles to the grid and display tree.
			for (var i:int = 0; i < initialGrid.length; i++) {
				for (var j:int = 0; j < initialGrid[i].length; j++) {
					grid[i][j] = initialGrid[i][j];
					addChild(grid[i][j]);
				}
			}

			// TODO: figure out character's starting position.
			char = new Character(0, 0, initialXp);
		}
	}
}
