package ai {
	import flash.utils.Dictionary;

	import Floor;

	// Top level AI class. Create an instance with the desired search algorithm,
	// compute the path when ready, and then iterate through the actions.
	public class SearchAgent {
		// function(problem:SearchProblem, heuristic:Function)
		private var search:Function;
		// function(state:GameState)
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
			trace("Path: " + path + " length " + path.length);
		}

		// After the path is computed, this method can be called to get the next
		// action. Returns -1 if there is no path.
		public function getAction():int {
			trace("getAction(), current index = " + index);
			if (index == path.length) {
				return -1;
			}
			var next:int = path[index];
			index++;
			return next;
		}

		public static function aStar(problem:SearchProblem, heuristic:Function):Array {
			trace("Initializing heap");
			var fringe:Heap = new Heap(
				// Priority function for the heap (anonymous).
				function(node:SearchNode):int {
					return node.cost + heuristic(node.state);
				}
			);

			fringe.insert(new SearchNode(problem.getStartState(), new Array(), 0));
			var visited:Dictionary = new Dictionary();

			while (!fringe.isEmpty()) {
				var currentNode:SearchNode = fringe.pop();
				trace("Getting node from fringe - (" + currentNode.state.char.x + "," + currentNode.state.char.y + ")");
				if (visited[currentNode.state.hash()]) {
					trace("Node already visited");
					continue;
				}
				if (problem.isGoalState(currentNode.state)) {
					trace("Goal state reached");
					return currentNode.path;
				}

				visited[currentNode.state.hash()] = true;

				var successors:Array = problem.getSuccessors(currentNode.state);
				trace("Generated " + successors.length + " successors");
				for (var i:int = 0; i < successors.length; i++) {
					var successor:Successor = successors[i];
					var path:Array = new Array();
					for (var j:int = 0; j < currentNode.path.length; j++) {
						path.push(currentNode.path[j]);
					}
					path.push(successor.action);
					var node:SearchNode = new SearchNode(
						successor.state, path, successor.cost + currentNode.cost);
					trace("successor " + i + ": ("+ successor.state.char.x + "," + successor.state.char.y + "), " + successor.action);
					fringe.insert(node);
				}
			}
			return null;
		}

		public static function heuristic(state:GameState):int {
			// TODO: implement
			return 0;
		}
	}
}
