package ai {
	import Floor;

	public class SearchAgent {
		private var search:Function;
		private var heuristic:Function;

		private var path:Array;
		private var index:int;

		// Initializes a new SearchAgent. It will use the given search
		// algorithm and heuristic to do the search.
		public function SearchAgent(search:Function, heuristic:Function=null) {
			this.search = search;
			this.heuristic = heuristic;
		}

		// Computes a new path using floor as the initial state. The path can
		// be retrieved step by step using getAction().
		public function computePath(floor:Floor):void {
			var problem:SearchProblem = new SearchProblem(floor);
			path = search(problem, heuristic);
			index = 0;
		}

		// After the path is computed, this method can be called to get the next
		// action. Returns -1 if there is no path.
		public function getAction():int {
			if (index == path.length) {
				return -1;
			}
			var next:int = index;
			index++;
			return next;
		}

		public static function aStar(problem:SearchProblem, heuristic:Function):Array {
			var fringe:Heap = new Heap();
			// TODO: implement
			return null;
		}

		public static function heuristic(state:GameState):int {
			// TODO: implement
			return 0;
		}
	}
}
