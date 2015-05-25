package entities {
    // Creates pre-set entities for the game
    import flash.utils.Dictionary;

    public class EntityFactory {
        public static const ENEMY_CATEGORY:int = 0;
        public static const HEALING_CATEGORY:int = 1;
        public static const TRAP_CATEGORY:int = 2;

        public static const LIGHT_HEALING:String = "entity_light_healing";
        public static const MODERATE_HEALING:String = "entity_moderate_healing";
        public static const LIGHT_STAMINA_HEAL:String = "entity_light_stamina_heal";
        public static const FIGHTER:String = "entity_fighter";
        public static const MAGE:String = "entity_mage";

        private var textures:Dictionary;

        public var entitySet:Dictionary;
        public var masterSet:Dictionary;
        public var entityText:Dictionary;

        public function EntityFactory(textures:Dictionary) {
            this.textures = textures;
            this.masterSet = constructEntitySet();
            this.entitySet = new Dictionary();
            this.entityText = EntityDescriptions.setupDescriptions();
        }

        public function unlockTile(type:String):void {
            if (masterSet[type] != null && entitySet[type] == null) {
                entitySet[type] = masterSet[type];
            }
        }

        public function constructEntitySet():Dictionary {
            var entityDict:Dictionary = new Dictionary();

            var enemyDict:Dictionary = constructEnemyEntities();
            var healingDict:Dictionary = constructHealingEntities();
            var trapDict:Dictionary = constructTrapEntities();

            var key:String;
            for (key in enemyDict) {
                //keyS = String(key);
                entityDict[key] = enemyDict[key];
            }

            for (key in healingDict) {
                //keyS = String(key);
                entityDict[key] = healingDict[key];
            }

            for (key in trapDict) {
                //keyS = String(key);
                entityDict[key] = trapDict[key];
            }

            return entityDict;
        }

        public function constructEnemyEntities():Dictionary {
            var enemyDict:Dictionary = new Dictionary();

            var fighter:Dictionary = new Dictionary();
            fighter["constructor"] = constructFighter;
            fighter["texture"] = textures[Util.ENEMY_FIGHTER];
            fighter["cost"] = Util.ENEMY_FIGHTER_COST;
            fighter["category"] = ENEMY_CATEGORY;
            /*fighter.push(constructFighter);
            fighter.push(textures[Util.ENEMY_FIGHTER]);
            fighter.push(Util.ENEMY_FIGHTER_COST);
            fighter.push(ENEMY_CATEGORY);*/
            enemyDict[FIGHTER] = fighter;

            //var mage:Array = new Array();
            var mage:Dictionary = new Dictionary();
            mage["constructor"] = constructMage;
            mage["texture"] = textures[Util.ENEMY_MAGE];
            mage["cost"] = Util.ENEMY_MAGE_COST;
            mage["category"] = ENEMY_CATEGORY;
            /*mage.push(constructMage);
            mage.push(textures[Util.ENEMY_MAGE]);
            mage.push(Util.ENEMY_MAGE_COST);
            mage.push(ENEMY_CATEGORY);*/
            enemyDict[MAGE] = mage;

            return enemyDict;
        }

        public function constructHealingEntities():Dictionary {
            var healingDict:Dictionary = new Dictionary();

            /*var lightHealing:Array = new Array();
            lightHealing.push(constructLightHealing);
            lightHealing.push(textures[Util.HEALING]);
            lightHealing.push(Util.LIGHT_HEALING_COST);
            lightHealing.push(HEALING_CATEGORY);*/
            var lightHealing:Dictionary = new Dictionary();
            lightHealing["constructor"] = constructLightHealing;
            lightHealing["texture"] = textures[Util.HEALING];
            lightHealing["cost"] = Util.LIGHT_HEALING_COST;
            lightHealing["category"] = HEALING_CATEGORY;
            healingDict[LIGHT_HEALING] = lightHealing;

            /*var moderateHealing:Array = new Array();
            moderateHealing.push(constructModerateHealing);
            moderateHealing.push(textures[Util.HEALING]);
            moderateHealing.push(Util.MODERATE_HEALING_COST);
            moderateHealing.push(HEALING_CATEGORY);*/
            var moderateHealing:Dictionary = new Dictionary();
            moderateHealing["constructor"] = constructModerateHealing;
            moderateHealing["texture"] = textures[Util.HEALING];
            moderateHealing["cost"] = Util.MODERATE_HEALING_COST;
            moderateHealing["category"] = HEALING_CATEGORY;
            healingDict[MODERATE_HEALING] = moderateHealing;

            /*var lightStaminaHeal:Array = new Array();
            lightStaminaHeal.push(constructLightStaminaHeal);
            lightStaminaHeal.push(textures[Util.STAMINA_HEAL]);
            lightStaminaHeal.push(Util.LIGHT_STAMINA_HEAL_COST);
            lightStaminaHeal.push(HEALING_CATEGORY);*/
            var lightStaminaHeal:Dictionary = new Dictionary();
            lightStaminaHeal["constructor"] = constructLightStaminaHeal;
            lightStaminaHeal["texture"] = textures[Util.STAMINA_HEAL];
            lightStaminaHeal["cost"] = Util.LIGHT_STAMINA_HEAL_COST;
            lightStaminaHeal["category"] = HEALING_CATEGORY;
            healingDict[LIGHT_STAMINA_HEAL] = lightStaminaHeal;

            return healingDict;
        }

        public function constructTrapEntities():Dictionary {
            var trapDict:Dictionary = new Dictionary();

            return trapDict;
        }

        public function constructLightHealing(x:int=0, y:int=0):Healing {
            var healing:int = 3;

            return new Healing(x, y, textures[Util.HEALING], healing);
        }

        public function constructModerateHealing(x:int=0, y:int=0):Healing {
            var healing:int = 7;

            return new Healing(x, y, textures[Util.HEALING], healing);
        }

        public function constructLightStaminaHeal(x:int=0, y:int=0):StaminaHeal {
            var stamina:int = 3;

            return new StaminaHeal(x, y, textures[Util.STAMINA_HEAL], stamina);
        }

        public function constructFighter(x:int=0, y:int=0):Enemy {
            var hp:int = 5;
            var atk:int = 1;
            var reward:int = 7;

            return new Enemy(x, y, Util.ENEMY_FIGHTER, textures[Util.ENEMY_FIGHTER], hp, atk, reward);
        }

        public function constructMage(x:int=0, y:int=0):Enemy {
            var hp:int = 9;
            var atk:int = 3;
            var reward:int = 18;

            return new Enemy(x, y, Util.ENEMY_MAGE, textures[Util.ENEMY_MAGE], hp, atk, reward);
        }
    }
}
