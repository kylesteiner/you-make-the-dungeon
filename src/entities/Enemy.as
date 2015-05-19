package entities {
	import starling.textures.Texture;

	public class Enemy extends Entity {
		public var maxHp:int;
		public var hp:int;
		public var attack:int;
		public var reward:int;

		public function Enemy(g_x:int, g_y:int, texture:Texture, maxHp:int, attack:int, reward:int) {
			super(g_x, g_y, texture);
			this.maxHp = maxHp;
			this.hp = maxHp;
			this.attack = attack;
			this.reward = reward;
		}
	}
}
