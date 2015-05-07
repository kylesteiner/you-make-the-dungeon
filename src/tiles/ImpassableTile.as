package tiles {
	import starling.textures.Texture;

	public class ImpassableTile extends Tile {
		public function ImpassableTile(x:int, y:int, texture:Texture) {
			super(x, y, false, false, false, false, texture);
		}
	}
}
