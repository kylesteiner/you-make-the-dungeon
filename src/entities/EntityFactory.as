package entities {
    // Creates pre-set entities for the game
    import flash.utils.Dictionary;

    public class EntityFactory {
        public static const ENEMY_CATEGORY:int = 0;
        public static const HEALING_CATEGORY:int = 1;
        public static const TRAP_CATEGORY:int = 2;

        // Enemy stats
        public static const FIGHTER_HP:int = 5;
        public static const FIGHTER_ATK:int = 1;
        public static const FIGHTER_REWARD:int = 6;
        public static const MAGE_HP:int = 8;
        public static const MAGE_ATK:int = 2;
        public static const MAGE_REWARD:int = 11;
        public static const ARCHER_HP:int = 13;
        public static const ARCHER_ATK:int = 3;
        public static const ARCHER_REWARD:int = 18;
        public static const NINJA_HP:int = 20;
        public static const NINJA_ATK:int = 4;
        public static const NINJA_REWARD:int = 26;

        // Healing stats
        public static const LIGHT_HEAL_AMOUNT:int = 4;
        public static const MEDIUM_HEAL_AMOUNT:int = 10;
        public static const LIGHT_STAMINA_HEAL_AMOUNT:int = 4;
        public static const MEDIUM_STAMINA_HEAL_AMOUNT:int = 10;

        // Trap stats
        public static const TRAP_DAMAGE:int = 8;
        public static const TRAP_RADIUS:int = 0;
        public static const SHOCK_TRAP_DAMAGE:int = 5;
        public static const SHOCK_TRAP_RADIUS:int = 4;
        public static const FLAME_TRAP_DAMAGE:int = 4;
        public static const FLAME_TRAP_RADIUS:int = 2;
        public static const BLUE_FLAME_TRAP_DAMAGE:int = 3;
        public static const BLUE_FLAME_TRAP_RADIUS:int = 5;

        public static const LIGHT_HEALING:String = "entity_light_healing";
        public static const MODERATE_HEALING:String = "entity_moderate_healing";
        public static const LIGHT_STAMINA_HEAL:String = "entity_light_stamina_heal";
        public static const MODERATE_STAMINA_HEAL:String = "entity_moderate_stamina_heal";

        public static const FIGHTER:String = "entity_fighter";
        public static const MAGE:String = "entity_mage";
        public static const ARCHER:String = "entity_archer";
        public static const NINJA:String = "entity_ninja";

        public static const BASIC_TRAP:String = "basic_trap";
        public static const FLAME_TRAP:String = "flame_trap";
        public static const FLAME_TRAP_BLUE:String = "flame_trap_blue";
        public static const SHOCK_TRAP:String = "shock_trap";

        public var entitySet:Dictionary;
        public var masterSet:Dictionary;
        public var entityText:Dictionary;

        public function EntityFactory() {
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
                entityDict[key] = enemyDict[key];
            }

            for (key in healingDict) {
                entityDict[key] = healingDict[key];
            }

            for (key in trapDict) {
                entityDict[key] = trapDict[key];
            }

            return entityDict;
        }

        public function constructEnemyEntities():Dictionary {
            var enemyDict:Dictionary = new Dictionary();

            var fighter:Dictionary = new Dictionary();
            fighter["constructor"] = constructFighter;
            fighter["texture"] = Assets.textures[Util.ENEMY_FIGHTER];
            fighter["cost"] = Util.ENEMY_FIGHTER_COST;
            fighter["category"] = ENEMY_CATEGORY;
            enemyDict[FIGHTER] = fighter;

            var mage:Dictionary = new Dictionary();
            mage["constructor"] = constructMage;
            mage["texture"] = Assets.textures[Util.ENEMY_MAGE];
            mage["cost"] = Util.ENEMY_MAGE_COST;
            mage["category"] = ENEMY_CATEGORY;
            enemyDict[MAGE] = mage;

            var archer:Dictionary = new Dictionary();
            archer["constructor"] = constructArcher;
            archer["texture"] = Assets.textures[Util.ENEMY_ARCHER];
            archer["cost"] = Util.ENEMY_ARCHER_COST;
            archer["category"] = ENEMY_CATEGORY;
            enemyDict[ARCHER] = archer;

            var ninja:Dictionary = new Dictionary();
            ninja["constructor"] = constructNinja;
            ninja["texture"] = Assets.textures[Util.ENEMY_NINJA];
            ninja["cost"] = Util.ENEMY_NINJA_COST;
            ninja["category"] = ENEMY_CATEGORY;
            enemyDict[NINJA] = ninja;

            return enemyDict;
        }

        public function constructHealingEntities():Dictionary {
            var healingDict:Dictionary = new Dictionary();

            var lightHealing:Dictionary = new Dictionary();
            lightHealing["constructor"] = constructLightHealing;
            lightHealing["texture"] = Assets.textures[Util.HEALING];
            lightHealing["cost"] = Util.LIGHT_HEALING_COST;
            lightHealing["category"] = HEALING_CATEGORY;
            healingDict[LIGHT_HEALING] = lightHealing;

            var moderateHealing:Dictionary = new Dictionary();
            moderateHealing["constructor"] = constructModerateHealing;
            moderateHealing["texture"] = Assets.textures[Util.HEALING];
            moderateHealing["cost"] = Util.MODERATE_HEALING_COST;
            moderateHealing["category"] = HEALING_CATEGORY;
            healingDict[MODERATE_HEALING] = moderateHealing;

            var lightStaminaHeal:Dictionary = new Dictionary();
            lightStaminaHeal["constructor"] = constructLightStaminaHeal;
            lightStaminaHeal["texture"] = Assets.textures[Util.STAMINA_HEAL];
            lightStaminaHeal["cost"] = Util.LIGHT_STAMINA_HEAL_COST;
            lightStaminaHeal["category"] = HEALING_CATEGORY;
            healingDict[LIGHT_STAMINA_HEAL] = lightStaminaHeal;

            var moderateStaminaHeal:Dictionary = new Dictionary();
            moderateStaminaHeal["constructor"] = constructModerateStaminaHeal;
            moderateStaminaHeal["texture"] = Assets.textures[Util.STAMINA_HEAL];
            moderateStaminaHeal["cost"] = Util.MODERATE_STAMINA_HEAL_COST;
            moderateStaminaHeal["category"] = HEALING_CATEGORY;
            healingDict[MODERATE_STAMINA_HEAL] = moderateStaminaHeal;

            return healingDict;
        }

        public function constructTrapEntities():Dictionary {
            var trapDict:Dictionary = new Dictionary();

            var basicTrap:Dictionary = new Dictionary();
            basicTrap["constructor"] = constructBasicTrap;
            basicTrap["texture"] = Assets.textures[Util.BASIC_TRAP];
            basicTrap["cost"] = Util.BASIC_TRAP_COST;
            basicTrap["category"] = TRAP_CATEGORY;
            trapDict[BASIC_TRAP] = basicTrap;

            var flameTrap:Dictionary = new Dictionary();
            flameTrap["constructor"] = constructRedFlameTrap;
            flameTrap["texture"] = Assets.textures[Util.FLAME_TRAP];
            flameTrap["cost"] = Util.FLAME_TRAP_COST;
            flameTrap["category"] = TRAP_CATEGORY;
            trapDict[FLAME_TRAP] = flameTrap;

            var blueFlameTrap:Dictionary = new Dictionary();
            blueFlameTrap["constructor"] = constructBlueFlameTrap;
            blueFlameTrap["texture"] = Assets.textures[Util.FLAME_TRAP_BLUE];
            blueFlameTrap["cost"] = Util.BLUE_FLAME_TRAP_COST;
            blueFlameTrap["category"] = TRAP_CATEGORY;
            trapDict[FLAME_TRAP_BLUE] = blueFlameTrap;

            var shockTrap:Dictionary = new Dictionary();
            shockTrap["constructor"] = constructShockTrap;
            shockTrap["texture"] = Assets.textures[Util.SHOCK_TRAP];
            shockTrap["cost"] = Util.SHOCK_TRAP_COST;
            shockTrap["category"] = TRAP_CATEGORY;
            trapDict[SHOCK_TRAP] = shockTrap;

            return trapDict;
        }

        public function constructLightHealing(x:int=0, y:int=0):Healing {
            return new Healing(x, y, Assets.textures[Util.HEALING], LIGHT_HEAL_AMOUNT);
        }

        public function constructModerateHealing(x:int=0, y:int=0):Healing {
            return new Healing(x, y, Assets.textures[Util.HEALING], MEDIUM_HEAL_AMOUNT);
        }

        public function constructLightStaminaHeal(x:int=0, y:int=0):StaminaHeal {
            return new StaminaHeal(x, y, Assets.textures[Util.STAMINA_HEAL], LIGHT_STAMINA_HEAL_AMOUNT);
        }

        public function constructModerateStaminaHeal(x:int=0, y:int=0):StaminaHeal {
            return new StaminaHeal(x, y, Assets.textures[Util.STAMINA_HEAL], MEDIUM_STAMINA_HEAL_AMOUNT);
        }

        public function constructFighter(x:int=0, y:int=0):Enemy {
            return new Enemy(x, y, Util.ENEMY_FIGHTER, Assets.textures[Util.ENEMY_FIGHTER], FIGHTER_HP, FIGHTER_ATK, FIGHTER_REWARD);
        }

        public function constructMage(x:int=0, y:int=0):Enemy {
            return new Enemy(x, y, Util.ENEMY_MAGE, Assets.textures[Util.ENEMY_MAGE], MAGE_HP, MAGE_ATK, MAGE_REWARD);
        }

        public function constructArcher(x:int=0, y:int=0):Enemy {
            return new Enemy(x, y, Util.ENEMY_ARCHER, Assets.textures[Util.ENEMY_ARCHER], ARCHER_HP, ARCHER_ATK, ARCHER_REWARD);
        }

        public function constructNinja(x:int=0, y:int=0):Enemy {
            return new Enemy(x, y, Util.ENEMY_NINJA, Assets.textures[Util.ENEMY_NINJA], NINJA_HP, NINJA_ATK, NINJA_REWARD);
        }

        public function constructBasicTrap(x:int=0, y:int=0):Trap {
            return new Trap(x, y, Assets.textures[Util.BASIC_TRAP], Util.BASIC_TRAP, TRAP_DAMAGE, 0);
        }

        public function constructRedFlameTrap(x:int=0, y:int=0):Trap {
			return new Trap(x, y, Assets.textures[Util.FLAME_TRAP], Util.FLAME_TRAP, FLAME_TRAP_DAMAGE, FLAME_TRAP_RADIUS);
        }

        public function constructBlueFlameTrap(x:int=0, y:int=0):Trap {
            return new Trap(x, y, Assets.textures[Util.FLAME_TRAP_BLUE], Util.FLAME_TRAP, BLUE_FLAME_TRAP_DAMAGE, BLUE_FLAME_TRAP_RADIUS);
        }

        public function constructShockTrap(x:int=0, y:int=0):Trap {
			return new Trap(x, y, Assets.textures[Util.SHOCK_TRAP], Util.SHOCK_TRAP, SHOCK_TRAP_DAMAGE, SHOCK_TRAP_RADIUS);
        }
    }
}
