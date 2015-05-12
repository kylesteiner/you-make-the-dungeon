package ai {
	// This class encodes the rules for combat between the character and an
	// enemy. The class has no state itself - the functions modify CharState
	// and EnemyState appropriately.
	public class Combat {
		public static function charAttacksEnemy(char:CharState, enemy:EnemyState, originIsAI:Boolean=true):void {
			enemy.hp -= char.attack;
			if (enemy.hp <= 0 && originIsAI) {
				char.xp += enemy.xpReward;
				char.tryLevelUp();
			}
		}

		public static function enemyAttacksChar(char:CharState, enemy:EnemyState, originIsAI:Boolean=true):void {
			char.hp -= enemy.attack;
		}
	}
}
