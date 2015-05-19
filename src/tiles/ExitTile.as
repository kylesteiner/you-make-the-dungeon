package tiles {
    import starling.textures.Texture;
    import starling.text.TextField;
	import starling.utils.Color;
	import starling.text.TextField;


    public class ExitTile extends Tile {
        public var label:TextField;

        public function ExitTile(g_x:int,
                                 g_y:int,
                                 n:Boolean,
                                 s:Boolean,
                                 e:Boolean,
                                 w:Boolean,
                                 texture:Texture) {
            super(g_x, g_y, n, s, e, w, texture);
            label = new TextField(Util.PIXELS_PER_TILE,
                                  Util.PIXELS_PER_TILE,
                                  "Exit",
                                  "Bebas",
                                  Util.SMALL_FONT_SIZE);
            addChild(label);
        }

        override public function handleChar(c:Character):void {
            dispatchEvent(new GameEvent(GameEvent.ARRIVED_AT_EXIT,
                                        grid_x,
                                        grid_y));
        }

		override public function displayInformation():void {
			setUpInfo("Exit Tile \n get here to complete floor");
		}
    }
}
