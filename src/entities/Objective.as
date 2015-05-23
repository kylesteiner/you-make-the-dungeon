package entities {
	import starling.textures.Texture;

	public class Objective extends Entity {
		// Unique identifier for this objective
		public var key:String;
		// Objectives that must be completed before this objective can be
		// completed.
		public var prereqs:Array;

		public function Objective(g_x:int, g_y:int, texture:Texture, key:String, prereqs:Array) {
			super(g_x, g_y, texture);
			this.key = key;
			this.prereqs = prereqs;
		}

		override public function handleChar(c:Character):void {
			dispatchEvent(new GameEvent(GameEvent.OBJ_COMPLETED,
										grid_x,
										grid_y));
		}
	}
}
