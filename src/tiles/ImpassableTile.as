package tiles {
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.text.TextField;


	public class ImpassableTile extends Tile {
		public function ImpassableTile(x:int, y:int, texture:Texture) {
			super(x, y, false, false, false, false, texture);
		}
		
		override public function displayInformation():void {
				text = new TextField(100, 100, "Impassable Tile\n Impossible to travel over", "Bebas", 12, Color.BLACK);
				text.border = true;
				text.x = 0;
				text.y = 150;
				addChild(text);
				text.visible = false;
		}
	}
}
