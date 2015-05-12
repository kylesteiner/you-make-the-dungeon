package {
    import starling.events.Event;

    public class AnimationEvent extends Event {
        public static const CHAR_ATTACKED:String = "char_attacked";
        public static const ENEMY_ATTACKED:String = "enemy_attacked";
        public static const CHAR_DIED:String = "char_died";
        public static const ENEMY_DIED:String = "enemy_died";

        public var character:Character;
        public var enemy:EnemyTile;

        public function AnimationEvent(type:String,
                                       c:Character,
                                       enemyTile:EnemyTile,
                                       bubbles:Boolean=true) {
            super(type, bubbles);
            character = c;
            enemy = enemyTile;
        }
    }
}
