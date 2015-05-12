package tiles {
    import starling.textures.Texture;
    import starling.text.TextField;
	import starling.utils.Color;
	import starling.text.TextField;



    import Util;

    public class EntryTile extends Tile {
        public var label:TextField;

        public function EntryTile(g_x:int,
                                  g_y:int,
                                  n:Boolean,
                                  s:Boolean,
                                  e:Boolean,
                                  w:Boolean,
                                  texture:Texture) {
            super(g_x, g_y, n, s, e, w, texture);
            label = new TextField(Util.PIXELS_PER_TILE,
                                  Util.PIXELS_PER_TILE,
                                  "Start",
                                  "Bebas",
                                  Util.SMALL_FONT_SIZE);
            addChild(label);
        }
		
		override public function displayInformation():void {
			setUpInfo("Starting Tile");
		}
    }
}
