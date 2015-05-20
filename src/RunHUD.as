package {
    import flash.utils.Dictionary;

    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.text.TextField;

    public class RunHUD extends Sprite {

        public var hud:Sprite;
        public var healthBar:Quad;
        public var staminaBar:Quad;
        public var healthText:TextField;
        public var staminaText:TextField;
        public var healthIcon:Image;
        public var staminaIcon:Image;

        private var textures:Dictionary;

        public static const HEALTH_BAR_COLOR:uint = 0xff0000;
        public static const STAMINA_BAR_COLOR:uint = 0x0000ff;
        public static const HEALTH_BAR_WIDTH:int = 32;
        public static const STAMINA_BAR_WIDTH:int = 32;


        public function RunHUD(textureDict:Dictionary) {
            textures = textureDict;

            hud = new Sprite();

            healthBar = new Quad(HEALTH_BAR_WIDTH, Util.STAGE_HEIGHT, HEALTH_BAR_COLOR); // (x, y) = (0, 0)
            hud.addChild(healthBar);

            staminaBar = new Quad(STAMINA_BAR_WIDTH, Util.STAGE_HEIGHT, STAMINA_BAR_COLOR);
            staminaBar.x = healthBar.width;
            hud.addChild(staminaBar);

            healthIcon = new Image(textures[Util.ICON_HEALTH]);
            healthIcon.y = Util.STAGE_HEIGHT - healthIcon.height;
            hud.addChild(healthIcon);

            staminaIcon = new Image(textures[Util.ICON_STAMINA]);
            staminaIcon.y = Util.STAGE_HEIGHT - staminaIcon.height;
            staminaIcon.x = healthBar.width;
            hud.addChild(staminaIcon);

            healthText = new TextField(healthBar.width, Util.MEDIUM_FONT_SIZE, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            healthText.y = healthIcon.y - healthText.height;
            healthText.autoScale = true;
            hud.addChild(healthText);

            staminaText = new TextField(staminaBar.width, Util.MEDIUM_FONT_SIZE, "", Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            staminaText.y = staminaIcon.y - staminaText.height;
            staminaText.x = healthBar.width;
            staminaText.autoScale = true;
            hud.addChild(staminaText);

            addChild(hud);
        }

        public function update(character:Character):void {
            hud.removeChild(healthBar);
            hud.removeChild(staminaBar);

            healthText.text = character.hp.toString();
            staminaText.text = character.stamina.toString();

            var healthHeight:int = Util.STAGE_HEIGHT * ((character.hp * 1.0) / character.maxHp);
            healthBar = new Quad(HEALTH_BAR_WIDTH, healthHeight == 0 ? 1 : healthHeight, HEALTH_BAR_COLOR);
            healthBar.y = Util.STAGE_HEIGHT - healthHeight;

            var staminaHeight:int = Util.STAGE_HEIGHT * ((character.stamina * 1.0) / character.maxStamina);
            staminaBar = new Quad(STAMINA_BAR_WIDTH, staminaHeight == 0 ? 1 : staminaHeight, STAMINA_BAR_COLOR);
            staminaBar.y = Util.STAGE_HEIGHT - staminaHeight;
            staminaBar.x = healthBar.width;

            if(healthHeight > 0) {
                hud.addChild(healthBar);
            }

            if(staminaHeight > 0) {
                hud.addChild(staminaBar);
            }

            hud.addChild(healthIcon);
            hud.addChild(staminaIcon);
            hud.addChild(healthText);
            hud.addChild(staminaText);
        }
    }
}
