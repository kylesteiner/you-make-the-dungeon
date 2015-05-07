package ai {
	public class Successor {
		public var state:GameState;
		public var action:int;
		public var cost:int;

		public SearchNode(state:GameState, action:int, cost:int) {
			this.state = state;
			this.action = action;
			this.cost = cost;
		}
	}
}
