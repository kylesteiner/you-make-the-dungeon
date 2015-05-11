package ai {
	public class Successor {
		public var state:GameState;	// The successor state.
		public var action:int;		// The action required to move to the successor.
		public var cost:int;		// Cost of taking the action.

		public function Successor(state:GameState, action:int, cost:int) {
			this.state = state;
			this.action = action;
			this.cost = cost;
		}
	}
}
