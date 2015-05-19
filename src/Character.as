// Character.as
// In-game representation of the character.

package {
	import flash.ui.Keyboard;

	import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture

	import tiles.*;
	import Util;
	import flash.utils.Dictionary;

	// Class representing the player character.
	public class Character extends Sprite {
		public static const BASE_HP:int = 5;
		public static const PIXELS_PER_FRAME:int = 4;

		// Game mechanic stats
		public var grid_x:int;
		public var grid_y:int;
		public var maxHp:int;
		public var hp:int;
		public var stamina:int;
		public var attack:int;

		// Character movement state (for rendering).
		public var inCombat:Boolean;
		private var moving:Boolean;
		private var destX:int;
		private var destY:int;

		private var animations:Dictionary;
		private var currentAnimation:MovieClip;

		// Constructs the character at the provided grid position and with the
		// correct stats
		public function Character(g_x:int, g_y:int, hp:int, stamina:int, attack:int, animationDict:Dictionary) {
			super();
			// Set the real x/y positions.
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);

			grid_x = x;
			grid_y = y;
			this.maxHp = hp;
			this.hp = hp;
			this.stamina = stamina;
			this.attack = attack;

			animations = animationDict;
			currentAnimation = new MovieClip(animations[Util.CHAR_IDLE], Util.ANIM_FPS);
			currentAnimation.play();

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

			removeChild(currentAnimation);
			currentAnimation = new MovieClip(animations[Util.CHAR_MOVE], Util.ANIM_FPS);
			currentAnimation.play();
			addChild(currentAnimation);

			if (direction == Util.NORTH) {
				destX = x;
				destY = y - Util.PIXELS_PER_TILE;
			} else if (direction == Util.EAST) {
				destX = x + Util.PIXELS_PER_TILE;
				destY = y;
			} else if (direction == Util.SOUTH) {
				destX = x;
				destY = y + Util.PIXELS_PER_TILE;
			} else if (direction == Util.WEST) {
				destX = x - Util.PIXELS_PER_TILE;
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
					x -= PIXELS_PER_FRAME;
				}
				if (x < destX) {
					x += PIXELS_PER_FRAME;
				}
				if (y > destY) {
					y -= PIXELS_PER_FRAME;
				}
				if (y < destY) {
					y += PIXELS_PER_FRAME;
				}

				if (x == destX && y == destY && moving) {
					moving = false;
					removeChild(currentAnimation);
					currentAnimation = new MovieClip(animations[Util.CHAR_IDLE], Util.ANIM_FPS);
					currentAnimation.play();
					addChild(currentAnimation);
					dispatchEvent(new TileEvent(TileEvent.CHAR_ARRIVED,
												Util.real_to_grid(x),
												Util.real_to_grid(y)));
				}
			}
		}
	}
}
