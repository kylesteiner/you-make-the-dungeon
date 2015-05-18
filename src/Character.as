// Character.as
// In-game representation of the character.

package {
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.text.TextField;

	import ai.CharState;
	import tiles.*;
	import Util;
	import flash.utils.Dictionary;

	// Class representing the Character rendered in game.
	public class Character extends Sprite {
		public static const PIXELS_PER_FRAME:int = 4;

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

		public var runState:Boolean;
		//private var dispField:TextField;

		public var maxStamina:int;
		public var currentStamina:int;

		public var attackImage:Image;
		public var attackText:TextField;

		public var los:int;

		// Constructs the character at the provided grid position and with the
		// correct stats
		public function Character(g_x:int, g_y:int, level:int, xp:int,
								  stamina:int, lineOfSight:int,
								  animationDict:Dictionary, attackTexture:Texture) {
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

			maxStamina = stamina;
			currentStamina = stamina;
			los = lineOfSight;

			runState = false;

			attackImage = new Image(attackTexture);
			attackImage.y = currentAnimation.height - (attackImage.height / 2);

			attackText = new TextField(32, 32, attack.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			attackText.x = attackImage.width;
			attackText.y = attackImage.y;
			attackText.autoScale = true;
			//dispField = new TextField(128, 128, runState.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			//dispField.x = currentAnimation.x;
			//dispField.y = currentAnimation.height;

			addChild(currentAnimation);

			//addChild(dispField);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function toggleRun():void {
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
		// When the move animation is completed, the tile that the character
		// moved into will receive an event.
		// If the Character is currently moving, this method will do nothing.
		public function move(direction:int):void {
			trace("character.move(" + direction + ")");
			if (moving || inCombat) {
				return;
			}

			if(Util.DIRECTIONS.indexOf(direction) == -1) {
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

		private function onEnterFrame(e:EnterFrameEvent):void {
			currentAnimation.advanceTime(e.passedTime);
			attackText.text = state.attack.toString();

			//dispField.text = runState.toString();

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

					currentStamina -= 1;

					if(currentStamina <= 0) {
						dispatchEvent(new GameEvent(GameEvent.STAMINA_EXPENDED));
					}
				}
			}
		}
	}
}
