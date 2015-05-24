package entities {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

    import flash.utils.Dictionary;

	public class Reward extends Entity {
        public var parameter:String;
        public var reward:Function

		public function Reward(g_x:int, g_y:int, texture:Texture, rewardFunction:String, rewardParameter:String) {
			super(g_x, g_y, texture);
            this.parameter = rewardParameter;

            if (rewardFunction == "gold") {
                reward = rewardGold;
            } else if (rewardFunction == "tile") {
                reward = rewardTile;
            }
		}

		override public function handleChar(c:Character):void {
            reward(parameter);
		}

        public function rewardGold(amount:String):void {
            var rewardDict:Dictionary = new Dictionary();
            rewardDict["amount"] = parseInt(amount);
            dispatchEvent(new GameEvent(GameEvent.GAIN_GOLD, -1, -1, rewardDict));
        }

        public function rewardTile(type:String):void {

        }
	}
}
