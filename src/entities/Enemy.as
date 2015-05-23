package entities {
	import starling.textures.Texture;
	import starling.text.TextField;
	import starling.utils.Color;
	import Util;
	public class Enemy extends Entity {
		public var maxHp:int;
		public var hp:int;
		public var attack:int;
		public var reward:int;

		public var currentDirection:int; // 0 is east, 1 is north, 2 is west, 3 is south
		public var stationary:Boolean; // for boss monsters
		public var moving:Boolean; // because apparently its clicked multiple times.
		public var inCombat:Boolean;

		// initial x and y for resets
		public var initialGrid_x:int;
		public var initialGrid_y:int;
		public var initialX:int;
		public var initialY:int;

		public var enemyName:String;

		public var enemyHpTextField:TextField;
		public var enemyAtkTextField:TextField;

		public function Enemy(g_x:int, g_y:int, enemyName:String, texture:Texture, maxHp:int, attack:int, reward:int, immobile:Boolean = false) {
			super(g_x, g_y, texture);
			this.maxHp = maxHp;
			this.hp = maxHp;
			this.attack = attack;
			this.reward = reward;
			this.enemyName = enemyName;
			this.enemyName = enemyName;
			initialGrid_x = g_x;
			initialGrid_y = g_y;
			initialX = x;
			initialY = y;
			stationary = immobile;
			currentDirection = Math.random() * 100 % Util.DIRECTIONS.length;

			enemyHpTextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2, Util.MEDIUM_FONT_SIZE, hp.toString());
			enemyHpTextField.color = Color.GREEN;
			enemyHpTextField.autoScale = true;
			enemyHpTextField.y = img.height / 2;

			enemyAtkTextField = Util.defaultTextField(Util.PIXELS_PER_TILE / 2, Util.MEDIUM_FONT_SIZE, attack.toString());
			enemyAtkTextField.color = Color.RED;
			enemyAtkTextField.autoScale = true;
			enemyAtkTextField.x = enemyHpTextField.x + enemyHpTextField.width;
			enemyAtkTextField.y = enemyHpTextField.y;

			addChild(enemyHpTextField);
			addChild(enemyAtkTextField);
		}

		public function move(destX:int, destY:int):void {
			trace("move");
			// movement code here, maybe nicer animations, for now i'll just physically change their positions
			trace(destX - grid_x);
			trace(destY - grid_y);
			// Should use Util.grid_to_real here
			x += (destX - grid_x) * Util.PIXELS_PER_TILE;
			y += (destY - grid_y) * Util.PIXELS_PER_TILE;
			grid_x = destX;
			grid_y = destY;
			trace("move done");
		}

		// reset function to reset the monsters onto
		// their initial positions.
		public function reset():void {
			grid_x = initialGrid_x;
			grid_y = initialGrid_y;
			x = initialX;
			y = initialY;
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
			dispatchEvent(new GameEvent(GameEvent.ENTERED_COMBAT, grid_x, grid_y));
		}
	}
}
