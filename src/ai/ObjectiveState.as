package ai {
	public class ObjectiveState {
		// Identifies this tile in Floor.objectiveState, prereqs
		public var key:String;
		// Objectives that must be completed before passing through this tile. Pathfinding/
		// movement rules need to check this field and Floor.objectiveState to see if the
		// tile is passable.
		public var prereqs:Array;

		public function ObjectiveState(key:String, prereqs:Array) {
			this.key = key;
			this.prereqs = prereqs;
		}
	}
}
