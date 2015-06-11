package {
    import starling.display.*;
    import starling.text.TextField;
    import starling.utils.Color;
    import starling.events.*;

    import flash.utils.Dictionary;

    public class GoldHUD extends Sprite {
        public static const BORDER:int = 2;
        public static const MOVE_SPEED:int = 2;
        public static const COLOR_SPEND:uint = Color.RED;
        public static const COLOR_EARN:uint = Color.YELLOW;
        public static const BORDER_COLOR:uint = Color.BLACK;
        public static const INTERIOR_COLOR:uint = Color.WHITE;
        public static const FLASH_COLOR:uint = Color.RED;
        public static const FLASH_DURATION:Number = 0.5;

        private var hud:Sprite;
        private var gold:int;
        private var goldImage:Image;
        private var goldText:TextField;
        private var goldQuad:Quad;
        private var goldQuadInterior:Quad;
        private var goldChangeTexts:Array;
        private var timeFlashed:Number;
        private var flashing:Boolean;

        public function GoldHUD(gold:int) {
            this.gold = gold;
            goldChangeTexts = new Array();

            hud = new Sprite();

            goldImage = new Image(Assets.textures[Util.ICON_GOLD]);
            goldImage.x = BORDER;
            goldText = new TextField(64, Util.MEDIUM_FONT_SIZE, gold.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            goldText.x = goldImage.width + goldImage.x;
            goldText.y = goldImage.y;
            goldText.autoScale = true;
            goldQuad = new Quad(goldImage.width + goldText.width + BORDER * 2, goldImage.height, BORDER_COLOR);
            goldQuadInterior = new Quad(goldQuad.width - BORDER * 2, goldQuad.height - 2*BORDER, INTERIOR_COLOR);
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

            if (this.gold > gold) {
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
            if (flashing) {
                timeFlashed += event.passedTime;
                if (timeFlashed > FLASH_DURATION) {
                    clearFlash();
                }
            }

            var cut:Array = new Array();

            var i:int;
            for (i = 0; i < goldChangeTexts.length; i++) {
                goldChangeTexts[i].y += MOVE_SPEED / (Math.pow(2, i));
                if (goldChangeTexts[i].y >= goldText.y + 2*goldText.height) {
                    cut.push(i);
                }
            }

            for (i = cut.length - 1; i >= 0; i--) {
                hud.removeChild(goldChangeTexts[i]);
                goldChangeTexts.splice(i, 1);
            }
        }

        public function setFlash():void {
            flashing = true;
            timeFlashed = 0;
            goldQuadInterior.color = FLASH_COLOR;
            Assets.mixer.play(Util.GOLD_DEFICIT);
        }

        public function clearFlash():void {
            flashing = false;
            goldQuadInterior.color = INTERIOR_COLOR;
        }
    }

}
