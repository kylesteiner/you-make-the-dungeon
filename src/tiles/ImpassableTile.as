package tiles {
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class ImpassableTile extends Tile {
		public function ImpassableTile(x:int, y:int, texture:Texture) {
			super(x, y, false, false, false, false, texture);
		}
	}
}
