package ai {
	import Floor;

	public class SearchAgent {
		private var path:Array;
		private var index:int;

		// Initializes a new SearchAgent. The SearchAgent computes a path, and
		// then makes actions available from the getAction() method.
		public function SearchAgent(floor:Floor, search:Function, heuristic:Function=null) {
			searchProblem = new SearchProblem(floor);
			if (heuristic) {
				path = search(problem, heuristic);
			} else {
				path = search(problem);
			}
			index = 0;
		}

		// After the path is computed, this method can be called to get the next
		// action.
		public function getAction():int {
			var next:int = index;
			index++;
			return next;
		}

		public static function aStar(problem:SearchProblem, heuristic:Function):Array {
			// TODO: implement!!!
			return null;
		}
	}
}
