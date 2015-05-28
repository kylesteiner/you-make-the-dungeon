package {
    import starling.display.*;
    import starling.text.TextField;
    import starling.utils.Color;
    import starling.events.*;

    import flash.utils.Dictionary;

    public class GoldHUD extends Sprite {
        public static const BORDER:int = 2;
        public static const MOVE_SPEED:int = 2;
        public static const COLOR_SPEND:uint = Color.BLACK;
        public static const COLOR_EARN:uint = Color.YELLOW;

        private var hud:Sprite;
        private var gold:int;
        private var goldImage:Image;
        private var goldText:TextField;
        private var goldQuad:Quad;
        private var goldQuadInterior:Quad;
        private var goldChangeTexts:Array;

        public function GoldHUD(gold:int) {
            this.gold = gold;
            goldChangeTexts = new Array();

            hud = new Sprite();

            goldImage = new Image(Assets.textures[Util.ICON_GOLD]);
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

            addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        }

        public function update(gold:int):void {
            goldText.text = gold.toString();
            var textColor:uint = COLOR_EARN;
            var modifier:String = "+";
            var soundString:String = Util.COIN_COLLECT;

            if(this.gold > gold) {
                soundString = Util.GOLD_SPEND;
                textColor = COLOR_SPEND;
                modifier = "-";
            }

            Assets.mixer.play(soundString);

            var newGoldChange:TextField = Util.defaultTextField(goldText.width, Util.MEDIUM_FONT_SIZE, modifier + Math.abs(this.gold - gold));
            newGoldChange.color = textColor;
            newGoldChange.x = goldText.x;
            newGoldChange.y = goldText.y + (goldText.height / 2);

            hud.addChild(newGoldChange);
            goldChangeTexts.push(newGoldChange);

            this.gold = gold;
        }

        public function onEnterFrame(event:EnterFrameEvent):void {
            var cut:Array = new Array();

            var i:int;
            for (i = 0; i < goldChangeTexts.length; i++) {
                goldChangeTexts[i].y += MOVE_SPEED;
                if (goldChangeTexts[i].y >= goldText.y + 2*goldText.height) {
                    cut.push(i);
                }
            }

            for (i = cut.length - 1; i >= 0; i--) {
                hud.removeChild(goldChangeTexts[i]);
                goldChangeTexts.splice(i, 1);
            }
        }
    }

}
