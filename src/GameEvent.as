package {
    import starling.events.Event;

    public class GameEvent extends Event {
        public static const STAMINA_EXPENDED:String = "stamina_expended";

        public function GameEvent(type:String,
                                  bubbles:Boolean=true) {
            super(type, bubbles);
        }
    }
}
