package ai {

	// A binary min-heap for sorting SearchNodes by priority. Used for the A*
	// algorithm for the game AI.
	public class Heap {
		private var arr:Array;
		private var size:int;
		private var priorityFn:Function;

		// Creates a new Heap, using the given function to assign priority to
		// nodes.
		public function Heap(priorityFn:Function) {
			arr = new Array();
			size = 0;
			this.priorityFn = priorityFn;
		}

		// Insert a search node into the heap.
		public function insert(searchNode:SearchNode):void {
			var node:HeapNode = new HeapNode(searchNode, priorityFn(searchNode));
			trace("Inserting node with char (" + searchNode.state.char.x + "," + searchNode.state.char.y + "), hp = "+ searchNode.state.char.hp + ", cost " + priorityFn(searchNode));
			size++;
			var i:int = percolateUp(size, node);
			arr[i] = node;
		}

		// Remove the highest priority search node.
		public function pop():SearchNode {
			if (size == 0) {
				return null;
			}

			var result:HeapNode = arr[1];
			var hole:int = percolateDown(1, arr[size]);
			arr[hole] = arr[size];
			size--;
			return result.data;
		}

		public function isEmpty():Boolean {
			return size == 0;
		}

		private function percolateUp(hole:int, node:HeapNode):int {
			while (hole > 1 && node.val < arr[int(hole/2)].val) {
				arr[hole] = arr[int(hole/2)];
				hole = int(hole/2);
			}
			return hole;
		}

		private function percolateDown(hole:int, node:HeapNode):int {
			while (2 * hole <= size) {
				var left:int = 2 * hole;
				var right:int = left + 1;
				var target:int;
				if (right > size || arr[left].val < arr[right].val) {
					target = left;
				} else {
					target = right;
				}
				if (arr[target].val < node.val) {
					arr[hole] = arr[target];
					hole = target;
				} else {
					break;
				}
			}
			return hole;
		}
	}
}

import ai.SearchNode;
class HeapNode {
	public var data:SearchNode;
	public var val:int;
	public function HeapNode(data:SearchNode, val:int) {
		this.data = data;
		this.val = val;
	}
}
