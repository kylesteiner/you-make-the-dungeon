package tiles {
	import starling.display.Image;
	import starling.textures.Texture;

	public class HealingTile extends Tile {
		public var health:int;   // How much health is restored.
		public var used:Boolean; // Whether the character has used the tile.

		private var healthImage:Image;

		public function HealingTile(g_x:int,
									g_y:int,
									n:Boolean,
									s:Boolean,
									e:Boolean,
									w:Boolean,
									backgroundTexture:Texture,
									healthTexture:Texture,
									health:int) {
			super(g_x, g_y, n, s, e, w, backgroundTexture);
			healthImage = new Image(healthTexture);
			addChild(healthImage);

			this.health = health;
			this.used = false;
		}

		override public function handleChar(c:Character):void {
			if (used || c.hp == c.maxHp) {
				return;
			}
			used = true;
			removeChild(healthImage);
			c.hp += health;
			if (c.hp > c.maxHp) {
				c.hp = c.maxHp;
			}
		}

		override public function reset():void {
			addChild(healthImage);
			used = false;
		}
	}
}
