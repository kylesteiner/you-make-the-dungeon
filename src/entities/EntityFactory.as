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
            unlockTile(FLAME_TRAP);
            unlockTile(FLAME_TRAP_BLUE);
            unlockTile(SHOCK_TRAP);
            unlockTile(BASIC_TRAP);
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
            var healing:int = 3;

            return new Healing(x, y, Assets.textures[Util.HEALING], healing);
        }

        public function constructModerateHealing(x:int=0, y:int=0):Healing {
            var healing:int = 7;

            return new Healing(x, y, Assets.textures[Util.HEALING], healing);
        }

        public function constructLightStaminaHeal(x:int=0, y:int=0):StaminaHeal {
            var stamina:int = 3;

            return new StaminaHeal(x, y, Assets.textures[Util.STAMINA_HEAL], stamina);
        }

        public function constructFighter(x:int=0, y:int=0):Enemy {
            var hp:int = 5;
            var atk:int = 1;
            var reward:int = 7;

            return new Enemy(x, y, Util.ENEMY_FIGHTER, Assets.textures[Util.ENEMY_FIGHTER], hp, atk, reward);
        }

        public function constructMage(x:int=0, y:int=0):Enemy {
            var hp:int = 9;
            var atk:int = 3;
            var reward:int = 18;

            return new Enemy(x, y, Util.ENEMY_MAGE, Assets.textures[Util.ENEMY_MAGE], hp, atk, reward);
        }

        public function constructBasicTrap(x:int=0, y:int=0):Trap {
			var damage:int = 5;

            return new Trap(x, y, Assets.textures[Util.BASIC_TRAP], Util.BASIC_TRAP, damage, 0);
        }

        public function constructRedFlameTrap(x:int=0, y:int=0):Trap {
           	var damage:int = 3;
			var radius:int = 4;

			return new Trap(x, y, Assets.textures[Util.FLAME_TRAP], Util.FLAME_TRAP, damage, radius);
        }

        public function constructBlueFlameTrap(x:int=0, y:int=0):Trap {
            var damage:int = 5;
            var radius:int = 2;

            return new Trap(x, y, Assets.textures[Util.FLAME_TRAP_BLUE], Util.FLAME_TRAP, damage, radius);
        }

        public function constructShockTrap(x:int=0, y:int=0):Trap {
    		var damage:int = 5;
			var radius:int = 3;

			return new Trap(x, y, Assets.textures[Util.SHOCK_TRAP], Util.SHOCK_TRAP, damage, radius);
        }
    }
}
