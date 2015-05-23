package {
    import starling.display.*;
    import starling.text.TextField;

    import flash.utils.Dictionary;

    public class GoldHUD extends Sprite {
        public static const BORDER:int = 2;

        private var hud:Sprite;
        private var goldImage:Image;
        private var goldText:TextField;
        private var goldQuad:Quad;
        private var goldQuadInterior:Quad;

        public function GoldHUD(gold:int, textureDict:Dictionary) {
            hud = new Sprite();

            goldImage = new Image(textureDict[Util.ICON_GOLD]);
            goldImage.x = BORDER;
            goldText = new TextField(64, Util.MEDIUM_FONT_SIZE, gold.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            goldText.x = goldImage.width + goldImage.x;
            goldText.y = goldImage.y;
            goldQuad = new Quad(goldImage.width + goldText.width + BORDER * 2, goldImage.height, 0x000000);
            goldQuadInterior = new Quad(goldQuad.width - BORDER * 2, goldQuad.height - 2*BORDER, 0xffffff);
            goldQuadInterior.x = BORDER;
            goldQuadInterior.y = BORDER;
            hud.addChild(goldQuad);
            hud.addChild(goldQuadInterior);

            hud.addChild(goldImage);
            hud.addChild(goldText);

            addChild(hud);
        }

        public function update(gold:int):void {
            goldText.text = gold.toString();
        }
    }

}
