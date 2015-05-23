package {
	import entities.Enemy;

	// This class encodes the rules for combat between the character and an
	// enemy. The class has no state itself - the functions modify CharState
	// and EnemyState appropriately.
	public class Combat {
		public static function charAttacksEnemy(char:Character, enemy:Enemy):void {
			enemy.hp -= char.attack;
		}

		public static function enemyAttacksChar(char:Character, enemy:Enemy):void {
			char.hp -= enemy.attack;
		}
	}
}
