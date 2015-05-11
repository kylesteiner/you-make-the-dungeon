package ai {

	public class Heap {
		private var arr:Array;
		private var size:int;

		public function Heap() {
			arr = new Array();
			size = 0;
		}

		public function insert(data:Object, priority:int):void {
			var node:HeapNode = new HeapNode(data, priority);
			size++;
			var i:int = percolateUp(size, node);
			arr[i] = node;
		}

		public function popMin():Object {
			if (size == 0) {
				return null;
			}

			var result:Object = arr[1];
			var hole:int = percolateDown(1, arr[size]);
			arr[hole] = arr[size];
			size--;
			return result;
		}

		private function percolateUp(hole:int, node:HeapNode):int {
			while (hole > 1 && node.val < arr[hole/2].val) {
				arr[hole] = arr[hole/2];
				hole = hole/2
			}
			return hole;
		}

		private function percolateDown(hole:int, node:HeapNode):int {
			while (2 * hole <= size) {
				var left:int = 2 * hole;
				var right:int = left + 1;
				var target:int;
				if (arr[left].val < arr[right].val || right > size) {
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

class HeapNode {
	public var data:Object;
	public var val:int;
	public function HeapNode(data:Object, val:int) {
		this.data = data;
		this.val = val;
	}
}
