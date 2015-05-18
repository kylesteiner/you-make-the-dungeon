package {
    import starling.display.*;
    import starling.text.TextField;

    import flash.utils.Dictionary;

    public class GoldHUD extends Sprite {
        private var hud:Sprite;
        private var goldImage:Image;
        private var goldText:TextField;

        public function GoldHUD(gold:int, textureDict:Dictionary) {
            hud = new Sprite();

            goldImage = new Image(textureDict[Util.ICON_GOLD]);
            goldText = new TextField(64, Util.MEDIUM_FONT_SIZE, gold.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            goldText.x = goldImage.width;
            addChild(goldImage);
            addChild(goldText);

            addChild(hud);
        }

        public function update(gold:int):void {
            goldText.text = gold.toString();
        }
    }

}
