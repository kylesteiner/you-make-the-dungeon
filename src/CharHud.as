package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;
	import starling.text.TextField;

	import tiles.*;
	import Util;

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

			var image:Image = new Image(textures[Util.CHAR_HUD]);
			x = Util.STAGE_WIDTH - image.width - 2;
			y = Util.STAGE_HEIGHT - image.height - 2;
			addChild(image);

			levelImage = new TextField(48, 20, "Level:", Util.DEFAULT_FONT, 20);
			levelImage.y = 8;
			addChild(levelImage);

			health = new Image(textures[Util.ICON_HEALTH]);
			health.y = image.height / 4;
			addChild(health);

			attack = new Image(textures[Util.ICON_ATK]);
			attack.y = image.height / 2;
			addChild(attack);

			xpImage = new TextField(32, 20, "Exp:", Util.DEFAULT_FONT, 20);
			xpImage.y = (3*image.height) / 4 + 8;
			addChild(xpImage);

			level = new TextField(32, 20, char.state.level.toString(), Util.DEFAULT_FONT, 20);
			//level.y = image.height / 8;
			level.x = levelImage.width;
			level.y = 8;
			addChild(level);

			hp = new TextField(64, 20, char.state.hp + " / " + char.state.maxHp, Util.DEFAULT_FONT, 20);
			addChild(hp);
			//hp.y = image.height / 4;
			hp.y = health.y + (health.height / 2) - (hp.height / 2);
			hp.x = health.width;

			atk = new TextField(64, 20, char.state.attack.toString(), Util.DEFAULT_FONT, 20);
			atk.y = attack.y + (attack.height / 2) - (atk.height / 2); //image.height / 2;
			atk.x = attack.width;
			addChild(atk);

			xp = new TextField(64, 20, char.state.xp + " / " + char.state.level, Util.DEFAULT_FONT, 20);
			xp.y = (3*image.height) / 4 + 8;// + (image.height / 8);
			xp.x = xpImage.width;
			addChild(xp);

			addEventListener(EnterFrameEvent.ENTER_FRAME, onFrameBegin);
		}

		private function onFrameBegin(event:EnterFrameEvent):void {
			level.text = char.state.level.toString();
			hp.text = char.state.hp + " / " + char.state.maxHp;
			atk.text = char.state.attack.toString();
			xp.text = char.state.xp + " / " + char.state.level;
		}
	}
}
