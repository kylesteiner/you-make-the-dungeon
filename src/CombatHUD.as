package {
    import flash.utils.Dictionary;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.*;
    import starling.text.TextField;
    import starling.utils.*;

    import entities.Enemy;

    public class CombatHUD extends Sprite {
        private var char:Character;
        private var enemy:Enemy;
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

        private var xpText:TextField;

        private var charHealthImage:Image;
        private var enemyHealthImage:Image;
        private var charAttackImage:Image;
        private var enemyAttackImage:Image;
        private var charHealthText:TextField;
        private var enemyHealthText:TextField;
        private var charAttackText:TextField;
        private var enemyAttackText:TextField;

        private var attackAnimation:MovieClip;

        private var charState:String;
        private var enemyState:String;

        private var background:Image;

        private var mixer:Mixer;

        private var logger:Logger;

        private var charRetreating:Boolean;
        private var enemyRetreating:Boolean;

        public var skipping:Boolean;

        private static const CHAR_X:int = Util.STAGE_WIDTH / 4;
        private static const CHAR_Y:int = 3 * (Util.STAGE_HEIGHT / 4);
        private static const ENEMY_X:int = 3 * (Util.STAGE_WIDTH / 4);
        private static const ENEMY_Y:int = 3 * (Util.STAGE_HEIGHT / 4);
        //private static const SHADOW_Y_OFFSET:int = Util.PIXELS_PER_TILE * 2;
        //private static const HEALTH_Y_OFFSET:int = Util.PIXELS_PER_TILE * 3;
        //private static const ATTACK_Y_OFFSET:int = Util.PIXELS_PER_TILE * 4;
        private static const DAMAGE_Y_OFFSET:int = -Util.PIXELS_PER_TILE / 2;
        private static const DAMAGE_TEXT_SHIFT:int = -2; // Pixels per frame
        private static const XP_TEXT_SHIFT:int = -2;
        private static const RETREAT_SPEED:int = 8;

        public static const ACCEL_TIME:int = 100;

        public function CombatHUD(textureDict:Dictionary,
                               animDict:Dictionary,
                               c:Character,
                               e:Enemy,
                               skip:Boolean,
                               soundMixer:Mixer,
                               dataLogger:Logger) {
            super();
            char = c;
            enemy = e;
            textures = textureDict;
            animations = animDict;
            mixer = soundMixer;
            logger = dataLogger;

            touchable = false;
            skipping = skip;

            //e.state.hp = 10;
            //char.hp = 10;

            setStage();

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(AnimationEvent.ENEMY_ATTACKED, onNextAttack);
            addEventListener(AnimationEvent.CHAR_ATTACKED, onNextAttack);

            dispatchEvent(new AnimationEvent(AnimationEvent.ENEMY_ATTACKED, char, enemy));
        }

        public function toggleSkip():void {
            skipping = !skipping;
        }

        public function displayChild(dispChild:DisplayObject):void {
            // Currently unused, but used to skip combat
            // Also need to mute sounds.
            if(!skipping) {
                addChild(dispChild);
            }
        }

        public function setStage():void {
            background = new Image(textures[Util.COMBAT_BG]);
            background.x = 0;
            background.y = 0;
            background.alpha = Util.COMBAT_ALPHA;
            addChild(background);

            charShadow = new Image(textures[Util.COMBAT_SHADOW]);
            charShadow.x = CHAR_X - (charShadow.width / 2);
            charShadow.y = CHAR_Y - charShadow.height;
            addChild(charShadow);

            enemyShadow = new Image(textures[Util.COMBAT_SHADOW]);
            enemyShadow.x = ENEMY_X - (charShadow.width / 2);
            enemyShadow.y = ENEMY_Y - charShadow.height;
            addChild(enemyShadow);

            charHealthImage = new Image(textures[Util.ICON_HEALTH]);
            charHealthImage.x = charShadow.x;
            charHealthImage.y = CHAR_Y;
            addChild(charHealthImage);

            charHealthText = new TextField(96, charHealthImage.height, char.hp + " / " + char.maxHp, Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            charHealthText.x = charHealthImage.x + charHealthImage.width;
            charHealthText.y = charHealthImage.y;
            addChild(charHealthText);

            charAttackImage = new Image(textures[Util.ICON_ATK]);
            charAttackImage.x = charShadow.x;
            charAttackImage.y = CHAR_Y + charHealthImage.height;
            addChild(charAttackImage);

            charAttackText = new TextField(96, charAttackImage.height, char.attack.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            charAttackText.x = charAttackImage.x + charAttackImage.width;
            charAttackText.y = charAttackImage.y;
            addChild(charAttackText);

            enemyHealthImage = new Image(textures[Util.ICON_HEALTH]);
            enemyHealthImage.x = enemyShadow.x;
            enemyHealthImage.y = ENEMY_Y;
            addChild(enemyHealthImage);

            enemyAttackImage = new Image(textures[Util.ICON_ATK]);
            enemyAttackImage.x = enemyShadow.x;
            enemyAttackImage.y = ENEMY_Y + enemyHealthImage.height;
            addChild(enemyAttackImage);

            enemyHealthText = new TextField(128, enemyHealthImage.height, enemy.hp + " / " + enemy.maxHp, Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            enemyHealthText.x = enemyHealthImage.x + enemyHealthImage.width;
            enemyHealthText.y = enemyHealthImage.y;
            addChild(enemyHealthText);

            enemyAttackText = new TextField(128, enemyAttackImage.height, enemy.attack.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            enemyAttackText.x = enemyAttackImage.x + enemyAttackImage.width;
            enemyAttackText.y = enemyAttackImage.y;
            addChild(enemyAttackText);

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

            // for speeding up combat (as opposed to outright skipping it)

            if(skipping) {
                while(!charAnim.loop && !charAnim.isComplete) {
                    charAnim.advanceTime(ACCEL_TIME);
                }

                while(!enemyAnim.loop && !enemyAnim.isComplete) {
                    enemyAnim.advanceTime(ACCEL_TIME);
                }
            }


            if(attackAnimation) {
                attackAnimation.advanceTime(e.passedTime);
                addChild(attackAnimation);
            }

            charHealthText.text = char.hp + " / " + char.maxHp;
            enemyHealthText.text = enemy.hp + " / " + enemy.maxHp;

            if(charDamagedText) {
                charDamagedText.y += DAMAGE_TEXT_SHIFT;
            }

            if(enemyDamagedText) {
                enemyDamagedText.y += DAMAGE_TEXT_SHIFT;
            }

            if(charRetreating) {
                charAnim.x -= RETREAT_SPEED;
            } else if(enemyRetreating) {
                enemyAnim.x += RETREAT_SPEED;
            }

            if(xpText) {
                xpText.y += XP_TEXT_SHIFT;
            }

            if(charState == Util.CHAR_COMBAT_ATTACK && (skipping || (charAnim.isComplete && attackAnimation.isComplete))) {
                dispatchEvent(new AnimationEvent(AnimationEvent.CHAR_ATTACKED, char, enemy));
            } else if(charState == Util.CHAR_COMBAT_FAINT && (skipping || (charAnim.isComplete && charAnim.x <= -charAnim.width))) {
                dispatchEvent(new AnimationEvent(AnimationEvent.CHAR_DIED, char, enemy));
            } else if(enemyState == Util.ENEMY_COMBAT_ATTACK && (skipping || (enemyAnim.isComplete && attackAnimation.isComplete))) {
                dispatchEvent(new AnimationEvent(AnimationEvent.ENEMY_ATTACKED, char, enemy));
            } else if(enemyState == Util.ENEMY_COMBAT_FAINT && (skipping || (enemyAnim.isComplete && enemyAnim.x >= Util.STAGE_WIDTH))) {
                dispatchEvent(new AnimationEvent(AnimationEvent.ENEMY_DIED, char, enemy));
            }
        }

        public function setCharIdle():void {
            setCharAnim(Util.CHAR_COMBAT_IDLE);
            charAnim.loop = true;
            //charAnim.scaleX = -1;
        }

        public function setCharAttack():void {
            setCharAnim(Util.CHAR_COMBAT_ATTACK);
        }

        public function setCharFaint():void {
            setCharAnim(Util.CHAR_COMBAT_FAINT);
            charRetreating = true;
        }

        public function setCharAnim(animationString:String):void {
            removeChild(charAnim);
            charAnim = new MovieClip(animations[Util.CHARACTER][animationString], Util.ANIM_FPS);
            charAnim.x = CHAR_X - (charAnim.width / 2);
            charAnim.y = CHAR_Y - charAnim.height;
            charAnim.loop = false;
            addChild(charAnim);

            charState = animationString;
        }

        public function setEnemyIdle():void {
            setEnemyAnim(Util.ENEMY_COMBAT_IDLE);
            enemyAnim.loop = true;
        }

        public function setEnemyAttack():void {
            setEnemyAnim(Util.ENEMY_COMBAT_ATTACK);
        }

        public function setEnemyFaint():void {
            setEnemyAnim(Util.ENEMY_COMBAT_FAINT);
            enemyRetreating = true;
            // enemyAnim.scaleX *= -1;
            // Make enemies turn around when they leave battle
        }

        public function setEnemyAnim(animationString:String):void {
            removeChild(enemyAnim);
            // TODO: fix animations with new entities
            enemyAnim = new MovieClip(animations[enemy.enemyName][animationString], Util.ANIM_FPS);
            enemyAnim.x = ENEMY_X - (enemyAnim.width / 2);
            enemyAnim.y = ENEMY_Y - enemyAnim.height;
            enemyAnim.loop = false;
            addChild(enemyAnim);

            enemyState = animationString;
        }

        public function createDamageText(baseAnimation:MovieClip, amount:int):TextField {
            var tDamage:TextField = new TextField(64, 64, "-" + amount.toString(), Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
            tDamage.color = Color.RED;
            tDamage.x = baseAnimation.x + (baseAnimation.width / 2) - (tDamage.width / 2);
            tDamage.y = baseAnimation.y + DAMAGE_Y_OFFSET;
            return tDamage;
        }

        public function createXpText(amount:int):TextField {
            var tXp:TextField = new TextField(256, 128, "+" + amount + " GOLD", Util.DEFAULT_FONT, Util.LARGE_FONT_SIZE);
            tXp.color = Color.YELLOW;
            tXp.x = (Util.STAGE_WIDTH / 2) - (tXp.width / 2);
            tXp.y = (Util.STAGE_HEIGHT / 2) - tXp.height;
            return tXp;
        }

        public function createAttackAnimation(anim:MovieClip, flip:Boolean=false):void {
            attackAnimation = new MovieClip(animations[Util.GENERIC_ATTACK][Util.GENERIC_ATTACK], Util.ANIM_FPS * 5);
            attackAnimation.loop = false;
            attackAnimation.scaleX = anim.width / attackAnimation.width;
            attackAnimation.scaleY = attackAnimation.scaleX;
            attackAnimation.scaleX *= (flip ? -1 : 1);
            attackAnimation.x = anim.x + (anim.width / 2) - attackAnimation.width / 2 + (flip ? anim.width : 0);
            attackAnimation.y = anim.y + (anim.height / 2) - attackAnimation.height / 2;
            attackAnimation.play();
        }

        public function onNextAttack(e:AnimationEvent):void {
            removeChild(charDamagedText);
            removeChild(enemyDamagedText);

            charDamagedText = null;
            enemyDamagedText = null;

            if(e.type == AnimationEvent.ENEMY_ATTACKED) {
                removeChild(attackAnimation);
                attackAnimation = null;

                setEnemyIdle();

                if(char.hp <= 0) {
                    setCharFaint();

                    mixer.play(Util.COMBAT_FAILURE);
                    // Do something to fire floor-failure event
                } else {
                    // Character's turn to attack
                    setCharAttack();
                    mixer.play(Util.SFX_ATTACK);
                    Combat.charAttacksEnemy(char, enemy);

                    enemyDamagedText = createDamageText(enemyAnim, char.attack);
                    addChild(enemyDamagedText);

                    createAttackAnimation(enemyAnim);
                    addChild(attackAnimation);

                }
            } else if(e.type == AnimationEvent.CHAR_ATTACKED) {
                removeChild(attackAnimation);
                attackAnimation = null;

                setCharIdle();

                if(enemy.hp <= 0) {
                    setEnemyFaint();

                    if(!skipping) {
                        mixer.play(Util.COMBAT_SUCCESS);
                    }

                    //xpText = createXpText(enemy.reward);
                    //addChild(xpText);
                } else {
                    // Enemy's turn to attack
                    setEnemyAttack();
                    mixer.play(Util.SFX_ATTACK);
                    Combat.enemyAttacksChar(char, enemy);

                    charDamagedText = createDamageText(charAnim, enemy.attack);
                    addChild(charDamagedText);

                    createAttackAnimation(charAnim, true);
                    addChild(attackAnimation)
                }
            }
        }
    }
}
