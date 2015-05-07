package ai {
	public class SearchNode {
		public var state:GameState;
		public var path:Array;
		public var cost:int;

		public SearchNode(state:GameState, path:Array, cost:int) {
			this.state = state;
			this.path = path;
			this.cost = cost;
		}
	}
}
