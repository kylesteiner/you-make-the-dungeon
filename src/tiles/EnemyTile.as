package tiles {
    import starling.display.Image;
    import starling.events.*;
    import starling.textures.Texture;

    public class EnemyTile extends Tile {
        public var enemyName:String;    // Name is already in use by a superclass
        public var level:int;
        public var hp:int;
        public var attack:int;
        public var xpReward:int;

        public var enemy:Image;

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
            this.hp = hp;
            this.attack = attack;
            this.xpReward = xpReward;

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        override public function handleChar(c:Character):void {
            // Let Floor handle the combat. Bounce it back up with an event.
            dispatchEvent(new TileEvent(TileEvent.COMBAT, grid_x, grid_y, c));
        }

        public function onEnterFrame(e:Event):void {
            // TODO: Attack animations
        }
    }

}
