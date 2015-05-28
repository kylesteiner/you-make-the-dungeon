package entities {
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;

    import flash.utils.Dictionary;

	public class Reward extends Entity {
        public var parameter:String;
        public var reward:Function
		public var rewardName:String;
        public var permanent:Boolean;

		public function Reward(g_x:int, g_y:int, texture:Texture, permanent:Boolean, rewardFunction:String, rewardParameter:String) {
			super(g_x, g_y, texture);
            this.parameter = rewardParameter;
            this.permanent = permanent;

			rewardName = rewardFunction;
            if (rewardFunction == "gold") {
                reward = rewardGold;
            } else if (rewardFunction == "tile") {
                reward = rewardTile;
            }
		}

		override public function handleChar(c:Character):void {
            Assets.mixer.play(Util.REWARD_COLLECT);
            reward(parameter);
		}

        public function rewardGold(amount:String):void {
            var rewardDict:Dictionary = new Dictionary();
            rewardDict["amount"] = parseInt(amount);
            rewardDict["entity"] = this;
            dispatchEvent(new GameEvent(GameEvent.GAIN_GOLD, -1, -1, rewardDict));
        }

        public function rewardTile(type:String):void {
			var rewardDict:Dictionary = new Dictionary();
			rewardDict["entity"] = this;
			rewardDict["type"] = type;
			dispatchEvent(new GameEvent(GameEvent.UNLOCK_TILE, -1, -1, rewardDict));
        }
	}
}
