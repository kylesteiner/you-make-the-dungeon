package {
    import starling.display.*;
    import starling.events.*;
    import flash.utils.Dictionary;
    import starling.text.*;
    import starling.utils.*;

    import tiles.EnemyTile;
    import ai.*;

    public class CombatHUD extends Sprite {
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

        private var charState:String;
        private var enemyState:String;

        private var background:Image;

        private var logger:Logger;

        private static const CHAR_X:int = Util.STAGE_WIDTH / 4;
        private static const CHAR_Y:int = 2 * (Util.STAGE_HEIGHT / 3);
        private static const ENEMY_X:int = 3 * (Util.STAGE_WIDTH / 4);
        private static const ENEMY_Y:int = 2 * (Util.STAGE_HEIGHT / 3);
        private static const SHADOW_Y_OFFSET:int = Util.PIXELS_PER_TILE * 2;
        private static const DAMAGE_Y_OFFSET:int = -Util.PIXELS_PER_TILE / 2;
        private static const DAMAGE_TEXT_SHIFT:int = -2; // Pixels per frame

        public function CombatHUD(textureDict:Dictionary,
                               animDict:Dictionary,
                               c:Character, e:EnemyTile,
                               dataLogger:Logger) {
            super();
            char = c;
            enemy = e;
            textures = textureDict;
            animations = animDict;
            logger = dataLogger;

            touchable = false;

            //e.state.hp = 10;
            //char.state.hp = 10;

            setStage();

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(AnimationEvent.ENEMY_ATTACKED, onNextAttack);
            addEventListener(AnimationEvent.CHAR_ATTACKED, onNextAttack);

            dispatchEvent(new AnimationEvent(AnimationEvent.ENEMY_ATTACKED, char, enemy));
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

            /*charAnim = new MovieClip(animations[Util.CHARACTER][Util.CHAR_COMBAT_IDLE], Util.ANIM_FPS);
            charAnim.x = CHAR_X - (charAnim.width / 2);
            charAnim.y = CHAR_Y - (charAnim.height / 2);
            charAnim.loop = true;
            addChild(charAnim);*/

            setCharIdle();
            setEnemyIdle();
        }

        public function onEnterFrame(e:EnterFrameEvent):void {
            charAnim.advanceTime(e.passedTime);
            enemyAnim.advanceTime(e.passedTime);

            if(charDamagedText) {
                charDamagedText.y += DAMAGE_TEXT_SHIFT;
            }

            if(enemyDamagedText) {
                enemyDamagedText.y += DAMAGE_TEXT_SHIFT;
            }

            if(charAnim.isComplete && charState == Util.CHAR_COMBAT_ATTACK) {
                dispatchEvent(new AnimationEvent(AnimationEvent.CHAR_ATTACKED, char, enemy));
            } else if(charAnim.isComplete && charState == Util.CHAR_COMBAT_FAINT) {
                dispatchEvent(new AnimationEvent(AnimationEvent.CHAR_DIED, char, enemy));
            } else if(enemyAnim.isComplete && enemyState == Util.CHAR_COMBAT_ATTACK) {
                dispatchEvent(new AnimationEvent(AnimationEvent.ENEMY_ATTACKED, char, enemy));
            } else if(enemyAnim.isComplete && enemyState == Util.CHAR_COMBAT_FAINT) {
                dispatchEvent(new AnimationEvent(AnimationEvent.ENEMY_DIED, char, enemy));
            }
        }

        public function setCharIdle():void {
            setCharAnim(Util.CHAR_COMBAT_IDLE);
            charAnim.loop = true;
        }

        public function setCharAttack():void {
            setCharAnim(Util.CHAR_COMBAT_ATTACK);
        }

        public function setCharFaint():void {
            setCharAnim(Util.CHAR_COMBAT_FAINT);
        }

        public function setCharAnim(animationString:String):void {
            removeChild(charAnim);
            charAnim = new MovieClip(animations[Util.CHARACTER][animationString], Util.ANIM_FPS);
            charAnim.x = CHAR_X - (charAnim.width / 2);
            charAnim.y = CHAR_Y - (charAnim.height / 2);
            charAnim.loop = false;
            addChild(charAnim);

            charState = animationString;
        }

        public function setEnemyIdle():void {
            setEnemyAnim(Util.CHAR_COMBAT_IDLE);
            enemyAnim.loop = true;
        }

        public function setEnemyAttack():void {
            setEnemyAnim(Util.CHAR_COMBAT_ATTACK);
        }

        public function setEnemyFaint():void {
            setEnemyAnim(Util.CHAR_COMBAT_FAINT);
        }

        public function setEnemyAnim(animationString:String):void {
            removeChild(enemyAnim);
            enemyAnim = new MovieClip(animations[Util.CHARACTER][animationString], Util.ANIM_FPS);
            enemyAnim.x = ENEMY_X - (enemyAnim.width / 2);
            enemyAnim.y = ENEMY_Y - (enemyAnim.height / 2);
            enemyAnim.loop = false;
            addChild(enemyAnim);

            enemyState = animationString;
        }

        public function createDamageText(baseAnimation:MovieClip, amount:int):TextField {
            var tDamage:TextField = new TextField(64, 64, amount.toString(), Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
            tDamage.color = Color.RED;
            tDamage.x = baseAnimation.x + (baseAnimation.width / 2) - (tDamage.width / 2);
            tDamage.y = baseAnimation.y + DAMAGE_Y_OFFSET;
            return tDamage;
        }

        public function onNextAttack(e:AnimationEvent):void {
            removeChild(charDamagedText);
            removeChild(enemyDamagedText);

            charDamagedText = null;
            enemyDamagedText = null;

            if(e.type == AnimationEvent.ENEMY_ATTACKED) {
                setEnemyIdle();

                if(char.state.hp <= 0) {
                    setCharFaint();
                    // Do something to fire floor-failure event
                } else {
                    // Character's turn to attack
                    setCharAttack();
                    Combat.charAttacksEnemy(char.state, enemy.state, false);

                    enemyDamagedText = createDamageText(enemyAnim, char.state.attack);
                    addChild(enemyDamagedText);

                }
            } else if(e.type == AnimationEvent.CHAR_ATTACKED) {
                setCharIdle();

                if(enemy.state.hp <= 0) {
                    setEnemyFaint();
                } else {
                    // Enemy's turn to attack
                    setEnemyAttack();
                    Combat.enemyAttacksChar(char.state, enemy.state, false);

                    charDamagedText = createDamageText(charAnim, enemy.state.attack);
                    addChild(charDamagedText);
                }
            }
        }

    }

}
