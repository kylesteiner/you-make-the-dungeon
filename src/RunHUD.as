package {
    import starling.display.*;
    import starling.text.TextField;

    import flash.utils.Dictionary;

    public class RunHUD extends Sprite {

        public var hud:Sprite;
        public var healthBar:Quad;
        public var staminaBar:Quad;
        public var healthText:TextField;
        public var staminaText:TextField;

        private var textures:Dictionary;


        public function RunHUD(textureDict:Dictionary) {
            textures = textureDict;

            hud = new Sprite();

            healthBar = new Quad(32, Util.STAGE_HEIGHT, 0xff0000); // (x, y) = (0, 0)
            hud.addChild(healthBar);

            staminaBar = new Quad(32, Util.STAGE_HEIGHT, 0x0000ff);
            staminaBar.x = healthBar.width;
            hud.addChild(staminaBar);

            healthText = new TextField(32, 128, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            healthText.y = Util.STAGE_HEIGHT - healthText.height;
            hud.addChild(healthText);

            staminaText = new TextField(32, 128, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            staminaText.y = Util.STAGE_HEIGHT - staminaText.height;
            staminaText.x = healthText.width;
            hud.addChild(staminaText);

            addChild(hud);
        }

        public function update(character:Character):void {
            hud.removeChild(healthBar);
            hud.removeChild(staminaBar);

            healthText.text = character.state.hp.toString();
            staminaText.text = character.currentStamina.toString();

            var healthHeight:int = Util.STAGE_HEIGHT * ((character.state.hp * 1.0) / character.state.maxHp);
            healthBar = new Quad(32, healthHeight, 0xff0000);
            healthBar.y = Util.STAGE_HEIGHT - healthHeight;

            var staminaHeight:int = Util.STAGE_HEIGHT * ((character.currentStamina * 1.0) / character.maxStamina);
            staminaBar = new Quad(32, staminaHeight, 0x0000ff);
            staminaBar.y = Util.STAGE_HEIGHT - staminaHeight;
            staminaBar.x = healthBar.width;

            hud.addChild(healthBar);
            hud.addChild(staminaBar);
            hud.addChild(healthText);
            hud.addChild(staminaText);
        }
    }
}
