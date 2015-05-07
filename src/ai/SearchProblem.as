package ai {
	import Floor;

	public class SearchProblem {
		private var start:GameState;

		public function SearchProblem(floor:Floor) {
			start = new GameState(floor);
		}

		public function getStartState():GameState {
			return start;
		}

		public function isGoalState(state:GameState):Boolean {
			return state.char.x == state.exitX && state.char.y = state.exitY;
		}

		// Returns an array of search nodes
		public function getSuccessors(state:GameState):Array {
			var successors:Array = new Array()
			var actions:Array = state.getLegalActions();
			for (var i:int = 0; i < actions; i++) {
				// TODO: cost function - we are just passing 1 for now
				successors.push(new Successor(state.generateSuccessor(action[i]), action[i], 1));
			}
			return successors;
		}

		public function getCostOfActions(actions:Array) {}
	}
}
