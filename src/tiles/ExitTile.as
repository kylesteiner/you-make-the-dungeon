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
            label = new TextField(32,32,"Exit","Verdana",8);
            addChild(label);
        }

        override public function handleChar(c:Character):void {
            dispatchEvent(new TileEvent(TileEvent.CHAR_EXITED,
                                        grid_x,
                                        grid_y,
                                        c,
                                        true));
        }
		
		override public function displayInformation():void {
				text = new TextField(100, 100, "Exit Tile \n get here to complete level", "Bebas", 12, Color.BLACK);
				text.border = true;
				text.x = 0;
				text.y = 150;
				addChild(text);
				text.visible = false;
		}
    }
}
