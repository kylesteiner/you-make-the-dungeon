package tiles {
    import starling.display.Image;
    import starling.events.*;
    import starling.textures.Texture;
	import starling.text.TextField;
	import starling.utils.Color;

    import ai.EnemyState;

    public class EnemyTile extends Tile {
        // Gameplay state
        public var state:EnemyState;
        public var initialHp:int;

        // Eye candy attributes (not used in gameplay)
        public var enemyName:String;    // Name is already in use by a superclass
        public var level:int;

        private var enemy:Image;

        public function EnemyTile(g_x:int,
                                  g_y:int,
                                  n:Boolean,
                                  s:Boolean,
                                  e:Boolean,
                                  w:Boolean,
                                  background:Texture,
                                  enemy:Texture,
                                  name:String,
                                  level:int,
                                  hp:int,
                                  attack:int,
                                  xpReward:int) {
            // Set up attributes before super constructor because they are used
            // by displayInformation
            // TODO: fix tile info hud to get rid of this workaround
            this.enemyName = name;
            this.level = level;
            initialHp = hp;
            state = new EnemyState(hp, attack, xpReward);

            super(g_x, g_y, n, s, e, w, background);

            this.enemy = new Image(enemy);
            addChild(this.enemy);

            displayInformation();
        }

        public function removeImage():void {
            removeChild(enemy);
        }

        override public function handleChar(c:Character):void {
            // Let Floor handle the combat. Bounce it back up with an event.
            if (state.hp > 0) {
                dispatchEvent(new TileEvent(TileEvent.COMBAT, grid_x, grid_y, c));
            }
        }

        override public function reset():void {
            addChild(enemy);
            state.hp = initialHp;
        }

		override public function displayInformation():void {
			var info:String = "Enemy Tile\nLevel: " + level;
            info += "\nHP: " + state.hp;
            info += "\nAttack: " + state.attack;
            info += "\nxp: " + state.xpReward;
			setUpInfo(info);
		}
    }
}
