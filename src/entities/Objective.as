package entities {
	import starling.textures.Texture;

	public class Objective extends Entity {
		// Unique identifier for this objective
		public var key:String;
		// Objectives that must be completed before this objective can be
		// completed.
		public var prereqs:Array;
		// Hold onto the texture name so we can use it when saving the game.
		public var textureName:String;

		public function Objective(g_x:int,
								  g_y:int,
								  texture:Texture,
								  key:String,
								  prereqs:Array,
								  textureName:String) {
			super(g_x, g_y, texture);
			this.key = key;
			this.prereqs = prereqs;
			this.textureName = textureName;
		}

		override public function handleChar(c:Character):void {
			dispatchEvent(new GameEvent(GameEvent.OBJ_COMPLETED,
										grid_x,
										grid_y));
		}
	}
}
