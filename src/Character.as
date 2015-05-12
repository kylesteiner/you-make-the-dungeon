// Character.as
// In-game representation of the character.

package {
	import starling.core.Starling;
	import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import flash.ui.Keyboard;

	import tiles.*;
	import Util;
	import flash.utils.Dictionary;

	public class Character extends Sprite {
		public static const BASE_HP:int = 5;

		// Character attributes
		public var level:int;
		public var xp:int;
		public var maxHp:int;
		public var hp:int;
		public var attack:int;

		// Character movement state
		private var moving:Boolean;
		public var inCombat:Boolean;
		private var destX:int;
		private var destY:int;

		private var moveQueue:Array;

		private var animations:Dictionary;
		private var currentAnimation:MovieClip;

		// Constructs the character at the provided grid position and with the
		// correct stats
		public function Character(g_x:int, g_y:int, level:int, xp:int, animationDict:Dictionary) {
			super();
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);
			this.level = level;
			this.xp = xp;
			attack = level;
			maxHp = getMaxHp();
			hp = maxHp;

			moveQueue = new Array();
			animations = animationDict;
			currentAnimation = new MovieClip(animations[Util.CHAR_IDLE], Util.ANIM_FPS);
			currentAnimation.play();

			//var image:Image = new Image(texture);
			//addChild(image);

			addChild(currentAnimation);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		// Begins moving the Character from one tile to the next.
		// When the move animation is completed, the tile that the character
		// moved into will receive an event.
		// If the Character is currently moving, this method will do nothing.
		public function move(direction:int):void {
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

		public function moveThroughFloor(path:Array):void {
			moveQueue = moveQueue.concat(path);
			move(moveQueue.shift());
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

		public function continueMovement():void {
			if(moveQueue.length > 0) {
				move(moveQueue.shift());
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

				if (x == destX && y == destY) {
					moving = false;
					dispatchEvent(new TileEvent(TileEvent.CHAR_ARRIVED,
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

		// Attempt to level up the character. This affects all stats.
		public function tryLevelUp():void {
			while (xp >= level) {
				xp -= level;
				level++;
				maxHp = getMaxHp();
				hp = maxHp;
				attack = level;
			}
		}
	}
}
