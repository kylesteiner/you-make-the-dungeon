// Character.as
// In-game representation of the character.

package {
	import starling.core.Starling;
	import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import flash.ui.Keyboard;

	import ai.CharState;
	import tiles.*;
	import Util;
	import flash.utils.Dictionary;

	// Class representing the Character rendered in game.
	public class Character extends Sprite {
		// Character gameplay state. Holds all information about the Character
		// that isn't relevant to how to render the Sprite.
		public var state:CharState;

		// Character movement state (for rendering).
		public var inCombat:Boolean;
		private var moving:Boolean;
		private var destX:int;
		private var destY:int;

		private var moveQueue:Array;

		private var animations:Dictionary;
		private var currentAnimation:MovieClip;

		// Constructs the character at the provided grid position and with the
		// correct stats
		public function Character(g_x:int, g_y:int, level:int, xp:int, animationDict:Dictionary) {
			super();
			// Set the real x/y positions.
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);

			moveQueue = new Array();
			animations = animationDict;
			currentAnimation = new MovieClip(animations[Util.CHAR_IDLE], Util.ANIM_FPS);
			currentAnimation.play();

			// Calculate character state from level.
			var attack:int = level;
			var maxHp:int = CharState.getMaxHp(level);
			var hp:int = maxHp;
			// Setup character game state.
			state = new CharState(g_x, g_y, xp, level, maxHp, hp, attack);

			addChild(currentAnimation);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		// Begins moving the Character from one tile to the next.
		// When the move animation is completed, the tile that the character
		// moved into will receive an event.
		// If the Character is currently moving, this method will do nothing.
		public function move(direction:int):void {
			trace("character.move(" + direction + ")");
			if (moving || inCombat) {
				return;
			}

			moving = true;

			if (direction == Util.NORTH && y - Util.PIXELS_PER_TILE > 0) {
				destX = x;
				destY -= Util.PIXELS_PER_TILE;
			} else if (direction == Util.EAST && x + Util.PIXELS_PER_TILE < Util.STAGE_WIDTH) {
				destX += Util.PIXELS_PER_TILE;
				destY = y;
			} else if (direction == Util.SOUTH && y + Util.PIXELS_PER_TILE < Util.STAGE_HEIGHT) {
				destX = x;
				destY += Util.PIXELS_PER_TILE;
			} else if (direction == Util.WEST && x - Util.PIXELS_PER_TILE > 0) {
				destX -= Util.PIXELS_PER_TILE;
				destY = y;
			}
		}

		private function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.UP) {
				move(Util.NORTH)
			} else if (e.keyCode == Keyboard.DOWN) {
				move(Util.SOUTH)
			} else if (e.keyCode == Keyboard.LEFT) {
				move(Util.WEST)
			} else if (e.keyCode == Keyboard.RIGHT) {
				move(Util.EAST)
			}
		}

		private function onEnterFrame(e:EnterFrameEvent):void {
			currentAnimation.advanceTime(e.passedTime);

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

				if (x == destX && y == destY && moving) {
					moving = false;
					dispatchEvent(new TileEvent(TileEvent.CHAR_ARRIVED,
												Util.real_to_grid(x),
												Util.real_to_grid(y)));
				}
			}
		}
	}
}
