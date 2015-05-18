package {
    import starling.events.Event;
    import tiles.*;
    import ai.*;

    public class AnimationEvent extends Event {
        public static const COMBAT_BEGIN:String = "combat_begin";
        public static const COMBAT_END:String = "combat_end";
        public static const CHAR_ATTACKED:String = "char_attacked";
        public static const ENEMY_ATTACKED:String = "enemy_attacked";
        public static const CHAR_DIED:String = "char_died";
        public static const ENEMY_DIED:String = "enemy_died";
        public static const STAMINA_EXPENDED:String = "stamina_expended";

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
