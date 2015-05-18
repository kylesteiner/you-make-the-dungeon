package tiles {
    import starling.display.*;
    import starling.events.*;
    import starling.textures.Texture;
	import starling.text.TextField;
	import starling.utils.Color;

    import ai.EnemyState;

    import flash.utils.Dictionary;

    public class EnemyTile extends Tile {
        // Gameplay state
        public var state:EnemyState;
        public var initialHp:int;

        // Eye candy attributes (not used in gameplay)
        public var enemyName:String;    // Name is already in use by a superclass
        public var level:int;

        private var enemy:Image;
        private var enemySprite:Sprite;

        //private var baseSprite:Sprite;
        //private var textDisplay:TextField;

        public function EnemyTile(g_x:int,
                                  g_y:int,
                                  n:Boolean,
                                  s:Boolean,
                                  e:Boolean,
                                  w:Boolean,
                                  background:Texture,
                                  enemy:Texture,
                                  name:String,
                                  level:int,
                                  hp:int,
                                  attack:int,
                                  xpReward:int) {
            // Set up attributes before super constructor because they are used
            // by displayInformation
            // TODO: fix tile info hud to get rid of this workaround
            this.enemyName = name;
            this.level = level;
            initialHp = hp;
            state = new EnemyState(hp, attack, xpReward);

            super(g_x, g_y, n, s, e, w, background);



            /*baseSprite = new Sprite();
            addChild(baseSprite);
            textDisplay = new TextField(64, 32, hp + " | " + attack, Util.DEFAULT_FONT, Util.SMALL_FONT_SIZE);
            //th.y = enemy.height;
            textDisplay.x = Util.PIXELS_PER_TILE;
            baseSprite.addChild(textDisplay);*/

            var textures:Dictionary = Embed.setupTextures();

            enemySprite = new Sprite();

            this.enemy = new Image(enemy);
            enemySprite.addChild(this.enemy);

            var healthIcon:Image = new Image(textures[Util.ICON_HEALTH]);
            //healthIcon.x = -healthIcon.width;
            //healthIcon.y = enemy.height;
            enemySprite.addChild(healthIcon);

            var healthText:TextField = new TextField(32, 32, hp.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            healthText.x = healthIcon.x + healthIcon.width;
            healthText.autoScale = true;
            //healthText.y = healthIcon.height / 2;
            //healthText.y = healthIcon.y;
            enemySprite.addChild(healthText);

            var attackIcon:Image = new Image(textures[Util.ICON_ATK]);
            attackIcon.y = enemy.height / 2;
            enemySprite.addChild(attackIcon);

            var attackText:TextField = new TextField(32, 32, attack.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
            attackText.x = attackIcon.x + attackIcon.width;
            attackText.y = attackIcon.y;
            attackText.autoScale = true;
            enemySprite.addChild(attackText);

            addChild(enemySprite);
            //this.enemy = new Image(enemy);
            //addChild(this.enemy);

            displayInformation();
        }

        public function removeImage():void {
            //removeChild(enemy);
            removeChild(enemySprite);
            //removeChild(textDisplay);
            //enemy.alpha = Util.VISITED_ALPHA;
        }

        override public function handleChar(c:Character):void {
            // Let Floor handle the combat. Bounce it back up with an event.
            if (state.hp > 0) {
                dispatchEvent(new TileEvent(TileEvent.COMBAT, grid_x, grid_y));
            }
        }

        override public function reset():void {
            //addChild(enemy);
            addChild(enemySprite);
            //addChild(textDisplay);
            state.hp = initialHp;
        }

		override public function displayInformation():void {
			var info:String = "Enemy Tile\nLevel: " + level;
            info += "\nHP: " + state.hp;
            info += "\nAttack: " + state.attack;
            info += "\nxp: " + state.xpReward;
			setUpInfo(info);
		}
    }
}
