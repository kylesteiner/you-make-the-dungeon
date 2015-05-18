package tiles {
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	import ai.HealingState;

	public class HealingTile extends Tile {
		// Contains the amount of health restored, and game logic.
		public var state:HealingState;

		// Marks whether the health at this tile has been used. If so, hide the
		// image and prevent further healing.
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
			state = new HealingState(health);
			super(g_x, g_y, n, s, e, w, backgroundTexture);
			healthImage = new Image(healthTexture);
			addChild(healthImage);

			used = false;
			displayInformation();
		}

		override public function handleChar(c:Character):void {
			if (!used) {
				var healed:Boolean = state.healCharacter(c);
				if (healed) {
					used = true;
					removeChild(healthImage);
				}
			}

			dispatchEvent(new TileEvent(TileEvent.CHAR_HANDLED,
										Util.real_to_grid(x),
										Util.real_to_grid(y)));
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
