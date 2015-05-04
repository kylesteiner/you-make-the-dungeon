// Character.as
// In-game representation of the character.

package {

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.*;

	import tiles.*;
	import Util;

	public class Character extends Sprite {
		public static const BASE_HP:int = 5;

		// Character attributes
		public var level:int;
		public var xp:int;
		public var maxHp:int;
		public var currentHp:int;
		public var attack:int;

		// Character movement state
		private var moving:Boolean;
		private var destX:int;
		private var destY:int;

		// Constructs the character at the provided grid position and with the
		// correct stats
		public function Character(g_x:int, g_y:int, experience:int) {
			super();
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);
			xp = experience;
			xpToLevel();
			attack = level;
			maxHp = getMaxHp();
			currentHp = maxHp;

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		// Begins moving the Character from one tile to the next.
		// When the move animation is completed, the tile that the character
		// moved into will receive an event.
		// If the Character is currently moving, this method will do nothing.
		public function move(direction:int):void {
			if (moving) {
				return;
			}

			moving = true;

			if (direction == Util.NORTH && y + Util.PIXELS_PER_TILE < stage.stageHeight) {
				destX = x;
				destY += Util.PIXELS_PER_TILE;
			} else if (direction == Util.EAST && x + Util.PIXELS_PER_TILE < stage.stageWidth) {
				destX += Util.PIXELS_PER_TILE;
				destY = y;
			} else if (direction == Util.SOUTH && y - Util.PIXELS_PER_TILE > 0) {
				destX = x;
				destY -= Util.PIXELS_PER_TILE;
			} else if (direction == Util.WEST && x - Util.PIXELS_PER_TILE > 0) {
				destX -= Util.PIXELS_PER_TILE;
				destY = y;
			}
		}

		private function onEnterFrame(e:Event):void {
			if (moving) {
				if (x > destX) {
					x--;
				}
				if (x < destX) {
					x++;
				}
				if (y > destY) {
					y--;
				}
				if (y < destY) {
					y++;
				}

				if (x == destX && y == destY) {
					moving = false;
					dispatchEvent(new TileEvent(TileEvent.CHAR_ENTRY,
												Util.real_to_grid(x),
												Util.real_to_grid(y),
												this));
				}
			}
		}

		// Returns the maximum HP of the character based on its level.
		private function getMaxHp():int {
			return ((level * (level + 1)) / 2) + BASE_HP - 1;
		}

		// Sets the character's level based on its XP.
		private function xpToLevel():void {
			var t_level:int = 1;
			var t_xp:int = xp;
			while(t_xp >= t_level) {
				t_xp -= t_level;
				t_level++;
			}
			level = t_level;
			xp = t_xp;
		}

	}
}
