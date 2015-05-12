package tiles {
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.text.TextField;


	public class ImpassableTile extends Tile {
		public function ImpassableTile(x:int, y:int, texture:Texture) {
			super(x, y, false, false, false, false, texture);
		}
		
		override public function displayInformation():void {
			setUpInfo("Impassable Tile\n Impossible to travel over");
		}
	}
}