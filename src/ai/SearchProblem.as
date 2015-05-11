package ai {
	import flash.utils.Dictionary;

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
			return (state.char.x == state.exitX) && (state.char.y == state.exitY);
		}

		// Returns an Dictionary mapping action->successor state
		public function getSuccessors(state:GameState):Dictionary {
			var successors:Dictionary = new Dictionary()
			var actions:Array = state.getLegalActions();
			for (var i:int = 0; i < actions.length; i++) {
				var newState:GameState = state.generateSuccessor(actions[i]);
				successors[actions[i]] = newState;
			}
			return successors;
		}
	}
}
