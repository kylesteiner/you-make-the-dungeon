// Level.as
// Stores the state of a single floor.

package {
	import starling.display.Sprite;
	import starling.core.Starling;

	import Character;
	import Util;
	import tiles.*;

	public class Level extends Sprite {
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
			char = new Character(0, 0, initialXp);
			resetLevel();
		}

		// Resets the character and grid state to their initial values.
		private function resetLevel():void {
			// Remove all tiles from the display tree.
			for (var i:int = 0; i < grid.length; i++) {
				for (var j:int = 0; j < grid[i].length; j++) {
					// TODO: figure out it it is necessary to dispose of the
					// tile here.
					grid[i][j].removeFromParent();
				}
			}

			// Add all of the initial tiles to the grid and display tree.
			for (var k:int = 0; i < initialGrid.length; k++) {
				for (var l:int = 0; j < initialGrid[k].length; l++) {
					grid[k][l] = initialGrid[k][l];
					addChild(grid[k][l]);
				}
			}

			// TODO: figure out character's starting position.
			char.removeFromParent(true);
			char = new Character(0, 0, initialXp);
			addChild(char);
		}
	}
}
