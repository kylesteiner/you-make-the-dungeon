package {
	import starling.events.Event;
	import flash.utils.Dictionary;

	public class GameEvent extends Event {
		public static const ARRIVED_AT_TILE:String = "arrived_at_tile";
        public static const ARRIVED_AT_EXIT:String = "arrived_at_exit";
		public static const ENTERED_COMBAT:String = "entered_combat";
		public static const HEALED:String = "healed";
		public static const STAMINA_HEALED:String = "stamina_healed";
		public static const MOVING:String = "moving";
		public static const ACTIVATE_TRAP:String = "activate_trap";
		public static const GET_TRAP_REWARD:String = "get_trap_reward";
        public static const OBJ_COMPLETED:String = "obj_completed";
		public static const STAMINA_EXPENDED:String = "stamina_expended";
        public static const REVEAL_ROOM:String = "reveal_room";
        public static const COMPLETE_ROOM:String = "complete_room";
		public static const BUILD_HUD_IMAGE_CHANGE:String = "build_hud_image_change";
		public static const GAIN_GOLD:String = "gain_gold";
		public static const SHOP_SPEND:String = "shop_spend";
		public static const TUTORIAL_COMPLETE:String = "tutorial_complete";
		public static const MOVE_CAMERA:String = "move_camera";
		public static const CINEMATIC_COMPLETE:String = "cinematic_complete";
		public static const UNLOCK_TILE:String = "unlock_tile";
		public static const CHARACTER_LOS_CHANGE:String = "character_los_change";

		public var x:int;
		public var y:int;

        public var gameData:Dictionary;

		public function GameEvent(type:String, x:int, y:int, eventData:Dictionary=null, bubbles:Boolean=true) {
			super(type, bubbles);
			this.x = x;
			this.y = y;

            gameData = eventData ? eventData : new Dictionary();
		}
	}
}
