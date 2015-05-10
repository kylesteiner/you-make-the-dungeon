package tiles {
    import starling.display.Image;
    import starling.events.*;
    import starling.textures.Texture;
	import starling.text.TextField;
	import starling.utils.Color;

    public class EnemyTile extends Tile {
        public var enemyName:String;    // Name is already in use by a superclass
        public var level:int;
        public var initialHp:int;
        public var hp:int;
        public var attack:int;
        public var xpReward:int;

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
            super(g_x, g_y, n, s, e, w, background);

            this.enemy = new Image(enemy);
            addChild(this.enemy);

            this.enemyName = name;
            this.level = level;
            initialHp = hp;
            this.hp = hp;
            this.attack = attack;
            this.xpReward = xpReward;
        }

        public function removeImage():void {
            removeChild(enemy);
        }

        override public function handleChar(c:Character):void {
            // Let Floor handle the combat. Bounce it back up with an event.
            if (hp > 0) {
                dispatchEvent(new TileEvent(TileEvent.COMBAT, grid_x, grid_y, c));
            }
        }

        override public function reset():void {
            addChild(enemy);
            hp = initialHp;
        }
		
		override public function displayInformation():void {
			var info:String = "Enemy Tile\nLevel: " + level + "\nHP: " + hp + "\nAttack: " + attack + "\nxp: " + xpReward;
			setUpInfo(info);
		}
    }
}
