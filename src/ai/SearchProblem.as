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
		public function getSuccessors(state:GameState):Array {
			var successors:Array = new Array();
			var actions:Array = state.getLegalActions();
			for (var i:int = 0; i < actions.length; i++) {
				var newState:GameState = state.generateSuccessor(actions[i]);
				successors.push(new Successor(newState, actions[i], 1));
			}
			return successors;
		}
	}
}
