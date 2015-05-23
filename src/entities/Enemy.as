package entities {
	import starling.textures.Texture;

	public class Enemy extends Entity {
		public var maxHp:int;
		public var hp:int;
		public var attack:int;
		public var reward:int;
		public var enemyName:String;

		public function Enemy(g_x:int,
							  g_y:int,
							  enemyName:String,
							  texture:Texture,
							  maxHp:int,
							  attack:int,
							  reward:int) {
			super(g_x, g_y, texture);
			this.maxHp = maxHp;
			this.hp = maxHp;
			this.attack = attack;
			this.reward = reward;
			this.enemyName = enemyName;
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

		override public function reset():void {
			super.reset();
			hp = maxHp;
		}
	}
}
