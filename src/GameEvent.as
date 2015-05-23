package {
	import starling.events.Event;

	public class GameEvent extends Event {
		public static const ARRIVED_AT_TILE:String = "arrived_at_tile";
        public static const ARRIVED_AT_EXIT:String = "arrived_at_exit";
		public static const ENTERED_COMBAT:String = "entered_combat";
		public static const HEALED:String = "healed";
        public static const OBJ_COMPLETED:String = "obj_completed";
		public static const STAMINA_EXPENDED:String = "stamina_expended";
        public static const REVEAL_ROOM:String = "reveal_room";
        public static const COMPLETE_ROOM:String = "complete_room";
		public static const BUILD_HUD_IMAGE_CHANGE:String = "build_hud_image_change";

		public var x:int;
		public var y:int;

        public var hasData:Boolean;
        public var gameData:Array;

		public function GameEvent(type:String, x:int, y:int, eventData:Array=null, bubbles:Boolean=true) {
			super(type, bubbles);
			this.x = x;
			this.y = y;

            hasData = !(eventData == null);
            gameData = eventData;
		}
	}
}
