package entities {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EnterFrameEvent;
	import starling.text.TextField;
	import starling.utils.Color;
	import Util;

	public class Enemy extends Entity {
		public var maxHp:int;
		public var hp:int;
		public var attack:int;
		public var reward:int;

		public var stationary:Boolean;
		public var moving:Boolean;
		public var inCombat:Boolean;
		private var destX:int;
		private var destY:int;

		// initial x and y for resets
		public var initialGrid_x:int;
		public var initialGrid_y:int;
		public var initialX:int;
		public var initialY:int;

		public var enemyName:String;

		public var enemyHpTextField:TextField;
		public var enemyAtkTextField:TextField;

		public var speed:int;

		public function Enemy(g_x:int,
							  g_y:int,
							  enemyName:String,
							  texture:Texture,
							  maxHp:int,
							  attack:int,
							  reward:int,
							  stationary:Boolean = false) {
			super(g_x, g_y, texture);
			this.maxHp = maxHp;
			this.hp = maxHp;
			this.attack = attack;
			this.reward = reward;
			this.enemyName = enemyName;

			initialGrid_x = g_x;
			initialGrid_y = g_y;
			initialX = x;
			initialY = y;

			this.stationary = stationary;
			moving = false;
			inCombat = false;
			speed = Util.speed;

			addOverlay();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		// Begins moving the Enemy in the provided direction. The grid x/y are
		// set to the new position immediately, but the real x/y changes
		// continuously over many frames.
		public function move(direction:int):void {
			if (moving || inCombat) {
				return;
			}
			if (Util.DIRECTIONS.indexOf(direction) == -1) {
				return;
			}
			moving = true;

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
			grid_x = Util.real_to_grid(destX);
			grid_y = Util.real_to_grid(destY);
		}

		override public function handleChar(c:Character):void {
			Util.logger.logAction(5, {
				"characterHealthLeft": c.hp,
				"characterHealthMax": c.maxHp,
				"characterAttack": c.attack,
				"enemyAttack": attack,
				"enemyHealth": hp,
				"enemyReward": reward
			});
			c.inCombat = true;
			dispatchEvent(new GameEvent(GameEvent.ENTERED_COMBAT, grid_x, grid_y));
		}

		override public function generateOverlay():Sprite {
			var base:Sprite = new Sprite();

			// Aligned to top-left
			enemyHpTextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2, Util.SMALL_FONT_SIZE, hp.toString(), Util.SMALL_FONT_SIZE);
			enemyHpTextField.autoScale = true;
			enemyHpTextField.x = img.width - enemyHpTextField.width - Entity.INFO_MARGIN;
			enemyHpTextField.y = Entity.INFO_MARGIN;

			// Aligned to bottom-right
			enemyAtkTextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2, Util.SMALL_FONT_SIZE, attack.toString(), Util.SMALL_FONT_SIZE);
			enemyAtkTextField.autoScale = true;
			enemyAtkTextField.x = img.width - enemyAtkTextField.width - Entity.INFO_MARGIN;
			enemyAtkTextField.y = img.height - enemyAtkTextField.height - Entity.INFO_MARGIN;

			base.addChild(enemyHpTextField);
			base.addChild(enemyAtkTextField);

			return base;
		}

		// Reset the monsters to their initial positions.
		override public function reset():void {
			moving = false;
			inCombat = false;
			grid_x = initialGrid_x;
			grid_y = initialGrid_y;
			x = initialX;
			y = initialY;
			hp = maxHp;
		}

		// Animate movement between tiles.
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (moving) {
				if (x > destX) {
					x -= speed;
				}
				if (x < destX) {
					x += speed;
				}
				if (y > destY) {
					y -= speed;
				}
				if (y < destY) {
					y += speed;
				}

				if (x == destX && y == destY) {
					moving = false;
				}
			}
		}
	}
}
