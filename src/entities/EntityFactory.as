package entities {
    // Creates pre-set entities for the game
    import flash.utils.Dictionary;

    public class EntityFactory {
        public static const ENEMY_CATEGORY:int = 0;
        public static const HEALING_CATEGORY:int = 1;
        public static const TRAP_CATEGORY:int = 2;

        public static const LIGHT_HEALING:String = "entity_light_healing";
        public static const FIGHTER:String = "entity_fighter";
        public static const MAGE:String = "entity_mage";

        private var textures:Dictionary;

        public var entitySet:Dictionary;

        public function EntityFactory(textures:Dictionary) {
            this.textures = textures;
            this.entitySet = constructEntitySet();
        }

        public function updateFactory():void {
            // Do some other update-thing here to update an
            // internal resource of what strings are used.
            // check for those strings in constructEntitySet
            entitySet = constructEntitySet();
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

            var fighter:Array = new Array();
            fighter.push(constructFighter);
            fighter.push(textures[Util.ENEMY_FIGHTER]);
            fighter.push(5);
            fighter.push(ENEMY_CATEGORY);
            enemyDict[FIGHTER] = fighter;

            var mage:Array = new Array();
            mage.push(constructMage);
            mage.push(textures[Util.ENEMY_MAGE]);
            mage.push(8);
            mage.push(ENEMY_CATEGORY);
            enemyDict[MAGE] = mage;

            return enemyDict;
        }

        public function constructHealingEntities():Dictionary {
            var healingDict:Dictionary = new Dictionary();

            var lightHealing:Array = new Array();
            lightHealing.push(constructLightHealing);
            lightHealing.push(textures[Util.HEALING]);
            lightHealing.push(10);
            lightHealing.push(HEALING_CATEGORY);
            healingDict[LIGHT_HEALING] = lightHealing;

            return healingDict;
        }

        public function constructTrapEntities():Dictionary {
            var trapDict:Dictionary = new Dictionary();

            return trapDict;
        }

        public function constructLightHealing():Healing {
            var healing:int = 3;

            return new Healing(0, 0, textures[Util.HEALING], healing);
        }

        public function constructFighter():Enemy {
            var hp:int = 5;
            var atk:int = 1;
            var reward:int = 3;

            return new Enemy(0, 0, Util.ENEMY_FIGHTER, textures[Util.ENEMY_FIGHTER], hp, atk, reward);
        }

        public function constructMage():Enemy {
            var hp:int = 8;
            var atk:int = 2;
            var reward:int = 7;

            return new Enemy(0, 0, Util.ENEMY_MAGE, textures[Util.ENEMY_MAGE], hp, atk, reward);
        }
    }
}
