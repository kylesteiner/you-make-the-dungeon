package entities {
    import flash.utils.Dictionary;

    public class EntityDescriptions {
        public static const FIGHTER_NAME:String = "Fighter";
        public static const FIGHTER_FLAVOR:String = "The classic sword-and-board.";

        public static const MAGE_NAME:String = "Mage";
        public static const MAGE_FLAVOR:String = "His desire for power is rivalled only by his lack thereof.";

        public static const LIGHT_HEAL_NAME:String = "Small Cake";
        public static const LIGHT_HEAL_FLAVOR:String = "A small slice of cake that someone left behind.";

        public static const MODERATE_HEAL_NAME:String = "Medium Cake";
        public static const MODERATE_HEAL_FLAVOR:String = "Contains just enough fruit that you don't feel bad eating it.";

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

            var lightHealArray:Array = new Array();
            lightHealArray.push(LIGHT_HEAL_NAME);
            lightHealArray.push(LIGHT_HEAL_FLAVOR);
            tDescriptions[EntityFactory.LIGHT_HEALING] = lightHealArray;

            var moderateHealArray:Array = new Array();
            moderateHealArray.push(MODERATE_HEAL_NAME);
            moderateHealArray.push(MODERATE_HEAL_FLAVOR);
            tDescriptions[EntityFactory.MODERATE_HEALING] = moderateHealArray;

            return tDescriptions;
        }
    }

}
