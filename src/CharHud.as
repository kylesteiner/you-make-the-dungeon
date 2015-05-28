package {
	import flash.utils.Dictionary;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.text.TextField;

	import tiles.*;

	public class CharHud extends Sprite {
		private var textures:Dictionary;
		public var char:Character;
		private var level:TextField;
		private var hp:TextField;
		private var atk:TextField;
		private var xp:TextField;

		private var health:Image;
		private var attack:Image;
		private var levelImage:TextField;
		private var xpImage:TextField;

		public function CharHud(currentChar:Character,
								textureDict:Dictionary) {
			super();
			char = currentChar;
			textures = textureDict;

			var image:Image = new Image(Assets.textures[Util.CHAR_HUD]);
			x = Util.STAGE_WIDTH - image.width - 2;
			y = Util.STAGE_HEIGHT - image.height - 2;
			addChild(image);

			health = new Image(Assets.textures[Util.ICON_HEALTH]);
			health.y = image.height / 4;
			addChild(health);

			attack = new Image(Assets.textures[Util.ICON_ATK]);
			attack.y = image.height / 2;
			addChild(attack);

			hp = new TextField(64, 20, char.hp + " / " + char.maxHp, Util.DEFAULT_FONT, 20);
			addChild(hp);
			//hp.y = image.height / 4;
			hp.y = health.y + (health.height / 2) - (hp.height / 2);
			hp.x = health.width;

			atk = new TextField(64, 20, char.attack.toString(), Util.DEFAULT_FONT, 20);
			atk.y = attack.y + (attack.height / 2) - (atk.height / 2); //image.height / 2;
			atk.x = attack.width;
			addChild(atk);

			addEventListener(EnterFrameEvent.ENTER_FRAME, onFrameBegin);
		}

		private function onFrameBegin(event:EnterFrameEvent):void {
			hp.text = char.hp + " / " + char.maxHp;
			atk.text = char.attack.toString();
		}
	}
}
