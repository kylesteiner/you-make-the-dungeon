package entities {
    import flash.utils.Dictionary;

    public class EntityDescriptions {
        public static const FIGHTER_NAME:String = "Fighter";
        public static const FIGHTER_FLAVOR:String = "The classic sword-and-board.";

        public static const MAGE_NAME:String = "Mage";
        public static const MAGE_FLAVOR:String = "His desire for power is rivalled only by his lack thereof.";

        public static const ARCHER_NAME:String = "Archer";
        public static const ARCHER_FLAVOR:String = "Not the sort of person you want shooting apples off your head.";

        public static const NINJA_NAME:String = "Ninja";
        public static const NINJA_FLAVOR:String = "Her shivs strike with surgical precision.";

        public static const LIGHT_HEAL_NAME:String = "Small Cake";
        public static const LIGHT_HEAL_FLAVOR:String = "A small slice of cake that someone left behind.";

        public static const MODERATE_HEAL_NAME:String = "Medium Cake";
        public static const MODERATE_HEAL_FLAVOR:String = "Contains just enough fruit that you don't feel bad eating it.";

        public static const LIGHT_STAMINA_HEAL_NAME:String = "Small Stamina Boost";
        public static const LIGHT_STAMINA_HEAL_FLAVOR:String = "For a little extra pep in your step.";

        public static const MODERATE_STAMINA_HEAL_NAME:String = "Medium Stamina Boost";
        public static const MODERATE_STAMINA_HEAL_FLAVOR:String = "The sugar-free energy solution.";

        public static function setupDescriptions():Dictionary {
            var tDescriptions:Dictionary = new Dictionary();

            var fighterArray:Array = new Array();
            fighterArray.push(FIGHTER_NAME);
            fighterArray.push(FIGHTER_FLAVOR);
            tDescriptions[EntityFactory.FIGHTER] = fighterArray;

            var mageArray:Array = new Array();
            mageArray.push(MAGE_NAME);
            mageArray.push(MAGE_FLAVOR);
            tDescriptions[EntityFactory.MAGE] = mageArray;

            var archerArray:Array = new Array();
            archerArray.push(ARCHER_NAME);
            archerArray.push(ARCHER_FLAVOR);
            tDescriptions[EntityFactory.ARCHER] = archerArray;

            var ninjaArray:Array = new Array();
            ninjaArray.push(NINJA_NAME);
            ninjaArray.push(NINJA_FLAVOR);
            tDescriptions[EntityFactory.NINJA] = ninjaArray;

            var lightHealArray:Array = new Array();
            lightHealArray.push(LIGHT_HEAL_NAME);
            lightHealArray.push(LIGHT_HEAL_FLAVOR);
            tDescriptions[EntityFactory.LIGHT_HEALING] = lightHealArray;

            var moderateHealArray:Array = new Array();
            moderateHealArray.push(MODERATE_HEAL_NAME);
            moderateHealArray.push(MODERATE_HEAL_FLAVOR);
            tDescriptions[EntityFactory.MODERATE_HEALING] = moderateHealArray;

            var lightStaminaHealArray:Array = new Array();
            lightStaminaHealArray.push(LIGHT_STAMINA_HEAL_NAME);
            lightStaminaHealArray.push(LIGHT_STAMINA_HEAL_FLAVOR);
            tDescriptions[EntityFactory.LIGHT_STAMINA_HEAL] = lightStaminaHealArray;

            var moderateStaminaHealArray:Array = new Array();
            moderateStaminaHealArray.push(MODERATE_STAMINA_HEAL_NAME);
            moderateStaminaHealArray.push(MODERATE_STAMINA_HEAL_FLAVOR);
            tDescriptions[EntityFactory.MODERATE_STAMINA_HEAL] = moderateStaminaHealArray;

            return tDescriptions;
        }
    }

}
