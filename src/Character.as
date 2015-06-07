package {
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.text.TextField;

	import tiles.*;
	import Util;

	// Class representing the player character.
	public class Character extends Sprite {
		public static const BASE_HP:int = 5;

		public var grid_x:int;
		public var grid_y:int;
		public var initialX:int;
		public var initialY:int;

		public var maxHp:int;
		public var hp:int;
		public var maxStamina:int;
		public var stamina:int;
		public var attack:int;

		// Character movement state (for rendering).
		public var moveLock:Boolean; // Used by tutorial to hold char in place.
		public var inCombat:Boolean;
		public var moving:Boolean;
		private var destX:int;
		private var destY:int;

		private var animations:Dictionary;
		private var currentAnimation:MovieClip;

		public var runState:Boolean;

		public var attackImage:Image;
		public var attackText:TextField;

		public var los:int;
		public var speed:int;

		public function Character(g_x:int,
								  g_y:int,
								  hp:int,
								  stamina:int,
								  attack:int,
								  lineOfSight:int,
								  animationDict:Dictionary,
								  attackTexture:Texture) {
			super();
			x = Util.grid_to_real(g_x);
			y = Util.grid_to_real(g_y);
			grid_x = g_x;
			grid_y = g_y;
			initialX = g_x;
			initialY = g_y;

			this.maxHp = hp;
			this.hp = hp;
			this.maxStamina = stamina;
			this.stamina = stamina;
			this.attack = attack;

			animations = animationDict;
			currentAnimation = new MovieClip(animations[Util.CHAR_IDLE], Util.ANIM_FPS);
			currentAnimation.play();

			los = lineOfSight;
			speed = Util.speed;

			runState = false;

			attackImage = new Image(attackTexture);
			attackImage.y = currentAnimation.height - (attackImage.height / 2);

			attackText = new TextField(32, 32, attack.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			attackText.x = attackImage.width;
			attackText.y = attackImage.y;
			attackText.autoScale = true;

			addChild(currentAnimation);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}


		public function reset():void {
			moving = false;
			inCombat = false;
			hp = maxHp;
			stamina = maxStamina;
			grid_x = initialX;
			grid_y = initialY;
			x = Util.grid_to_real(initialX);
			y = Util.grid_to_real(initialY);
		}

		public function toggleRunUI():void {
			runState = !runState;
			if(runState) {
				addChild(attackImage);
				addChild(attackText);
			} else {
				removeChild(attackImage);
				removeChild(attackText);
			}
		}

		// Begins moving the Character from one tile to the next.
		// The grid x/y are set immediately, but the real x/y changes
		// continuously over many frames. Once the character arrives at the tile
		// an event is passed to floor.
		public function move(direction:int):void {
			if (moving || inCombat || moveLock) {
				return;
			}

			if (Util.DIRECTIONS.indexOf(direction) == -1) {
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
				Util.logger.logAction(11, { "directionMoved": "North" });
			} else if (direction == Util.EAST) {
				destX = x + Util.PIXELS_PER_TILE;
				destY = y;
				Util.logger.logAction(11, { "directionMoved": "East" });
			} else if (direction == Util.SOUTH) {
				destX = x;
				destY = y + Util.PIXELS_PER_TILE;
				Util.logger.logAction(11, { "directionMoved": "South" });
			} else if (direction == Util.WEST) {
				destX = x - Util.PIXELS_PER_TILE;
				destY = y;
				Util.logger.logAction(11, { "directionMoved": "West" });
			}
			grid_x = Util.real_to_grid(destX);
			grid_y = Util.real_to_grid(destY);

			dispatchEvent(new GameEvent(GameEvent.MOVING, grid_x, grid_y));
		}

		private function onEnterFrame(e:EnterFrameEvent):void {
			currentAnimation.advanceTime(e.passedTime);
			attackText.text = attack.toString();

			if (moving) {
				if (x > destX) {
					x -= speed;
					if (x < destX) {
						x = destX;
					}
				}
				if (x < destX) {
					x += speed;
					if (x > destX) {
						x = destX;
					}
				}
				if (y > destY) {
					y -= speed;
					if (y < destY) {
						y = destY;
					}
				}
				if (y < destY) {
					y += speed;
					if (y > destY) {
						y = destY;
					}
				}

				if (x == destX && y == destY && moving) {
					moving = false;

					removeChild(currentAnimation);
					currentAnimation = new MovieClip(animations[Util.CHAR_IDLE], Util.ANIM_FPS);
					currentAnimation.play();
					addChild(currentAnimation);

					stamina -= 1;
					dispatchEvent(new GameEvent(GameEvent.ARRIVED_AT_TILE,
												grid_x,
												grid_y));
				}
			}
		}
	}
}
