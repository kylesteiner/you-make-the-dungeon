package ai {
	public class TileState {
		public var x:int;
		public var y:int;

		public var north:Boolean;
		public var south:Boolean;
		public var east:Boolean;
		public var west:Boolean;

		public function TileState(x:int, y:int, n:Boolean, s:Boolean, e:Boolean, w:Boolean) {
			this.x = x;
			this.y = y;
			north = n;
			south = s;
			east = e;
			west = w;
		}
	}
}
