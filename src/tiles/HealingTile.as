package tiles {
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	import ai.HealingState;

	public class HealingTile extends Tile {
		public var state:HealingState;
		public var used:Boolean;

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

			state = new HealingState(health);
			used = false;
		}

		override public function handleChar(c:Character):void {
			if (used || c.state.hp == c.state.maxHp) {
				dispatchEvent(new TileEvent(TileEvent.CHAR_HANDLED,
											Util.real_to_grid(x),
											Util.real_to_grid(y),
											c));
				return;
			}
			used = true;
			removeChild(healthImage);

			// TODO: refactor gameplay logic
			c.state.hp += state.health;
			if (c.state.hp > c.state.maxHp) {
				c.state.hp = c.state.maxHp;
			}

			dispatchEvent(new TileEvent(TileEvent.CHAR_HANDLED,
										Util.real_to_grid(x),
										Util.real_to_grid(y),
										c));
		}

		override public function reset():void {
			addChild(healthImage);
			used = false;
		}

		override public function displayInformation():void {
			setUpInfo("Healing Tile\n Gives back " + state.health + " health");
		}
	}
}
