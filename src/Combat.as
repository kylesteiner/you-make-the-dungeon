package {
    import starling.display.*;
    import starling.events.*;
    import flash.utils.Dictionary;
    import starling.text.*;

    import tiles.EnemyTile;

    public class Combat extends Sprite {
        private var char:Character;
        private var enemy:EnemyTile;
        private var textures:Dictionary;
        private var animations:Dictionary;

        private var charAnim:MovieClip;
        private var enemyAnim:MovieClip;
        private var charAttackAnim:MovieClip;
        private var enemyAttackAnim:MovieClip;
        private var charDamagedText:TextField;
        private var enemyDamagedText:TextField;
        private var charShadow:Image;
        private var enemyShadow:Image;

        private var background:Image;

        private static const CHAR_X:int = Util.STAGE_WIDTH / 4;
        private static const CHAR_Y:int = 2 * (Util.STAGE_HEIGHT / 3);
        private static const ENEMY_X:int = 3 * (Util.STAGE_WIDTH / 4);
        private static const ENEMY_Y:int = 2 * (Util.STAGE_HEIGHT / 3);
        private static const SHADOW_Y_OFFSET:int = Util.PIXELS_PER_TILE * 2;

        public function Combat(textureDict:Dictionary,
                               animDict:Dictionary,
                               c:Character, e:EnemyTile) {
            super();
            char = c;
            enemy = e;
            textures = textureDict;
            animations = animDict;

            touchable = false;

            setStage();

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        public function setStage():void {
            background = new Image(textures[Util.COMBAT_BG]);
            background.x = 0;
            background.y = 0;
            background.alpha = Util.COMBAT_ALPHA;
            addChild(background);

            charShadow = new Image(textures[Util.COMBAT_SHADOW]);
            charShadow.x = CHAR_X - (charShadow.width / 2);
            charShadow.y = CHAR_Y + SHADOW_Y_OFFSET - (charShadow.height / 2);
            addChild(charShadow);

            enemyShadow = new Image(textures[Util.COMBAT_SHADOW]);
            enemyShadow.x = ENEMY_X - (charShadow.width / 2);
            enemyShadow.y = ENEMY_Y + SHADOW_Y_OFFSET - (charShadow.height / 2);
            addChild(enemyShadow);

            charAnim = new MovieClip(animations[Util.CHARACTER][Util.CHAR_COMBAT_IDLE], Util.ANIM_FPS);
            charAnim.x = CHAR_X - (charAnim.width / 2);
            charAnim.y = CHAR_Y - (charAnim.height / 2);
            charAnim.loop = true;
            addChild(charAnim);

            enemyAnim = new MovieClip(animations[Util.CHARACTER][Util.CHAR_COMBAT_IDLE], Util.ANIM_FPS);
            enemyAnim.x = ENEMY_X - (enemyAnim.width / 2);
            enemyAnim.y = ENEMY_Y - (enemyAnim.height / 2);
            enemyAnim.loop = true;
            addChild(enemyAnim);
        }

        public function onEnterFrame(e:EnterFrameEvent):void {
            charAnim.advanceTime(e.passedTime);
            enemyAnim.advanceTime(e.passedTime);
        }

    }

}
