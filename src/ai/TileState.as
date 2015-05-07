package ai {
	public class TileState {
		public var x:int;
		public var y:int;

		public var n:int;
		public var s:int;
		public var e:int;
		public var w:int;

		public function TileState(x:int, y:int, n:int, s:int, e:int, w:int) {
			this.x = x;
			this.y = y;
			this.n = n;
			this.s = s;
			this.e = e;
			this.w = w;
		}
	}
}
