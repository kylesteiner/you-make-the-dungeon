package ai {
	public class SearchNode {
		public var state:GameState;	// Search state.
		public var path:Array;		// The path leading to this state.
		public var cost:int;		// The cost of taking this path.

		public function SearchNode(state:GameState, path:Array, cost:int) {
			this.state = state;
			this.path = path;
			this.cost = cost;
		}
	}
}
