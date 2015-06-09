package entities {
	import starling.textures.Texture;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.Color;
	import flash.utils.Dictionary;

	public class Objective extends Entity {
		public static const DEFAULT_COLOR:uint = Color.WHITE;
		public static const DEFAULT_COLOR_STRING:String = "white";

		// Unique identifier for this objective
		public var key:String;
		// Objectives that must be completed before this objective can be
		// completed.
		public var prereqs:Array;
		// Hold onto the texture name so we can use it when saving the game.
		public var textureName:String;
		public var objectiveColor:uint;

		public function Objective(g_x:int,
								  g_y:int,
								  texture:Texture,
								  key:String,
								  prereqs:Array,
								  textureName:String,
								  color:String) {
			super(g_x, g_y, texture);
			this.key = key;
			this.prereqs = prereqs;
			if (this.prereqs == null) {
				prereqs = new Array();
			}
			this.textureName = textureName;
			this.objectiveColor = getColor(color);

			addOverlay();
		}

		public function getColorDict():Dictionary {
			var colorDict:Dictionary = new Dictionary();
			colorDict["red"] = Color.RED;
			colorDict["blue"] = Color.BLUE;
			colorDict["yellow"] = Color.YELLOW;
			colorDict["green"] = Color.GREEN;
			colorDict["purple"] = Color.PURPLE;
			colorDict["maroon"] = Color.MAROON;
			colorDict["orange"] = 0xce8717;
			colorDict["aqua"] = Color.AQUA;
			colorDict["black"] = Color.BLACK;
			colorDict["gray"] = Color.GRAY;
			colorDict["fuchsia"] = Color.FUCHSIA;
			colorDict["aqua"] = Color.AQUA;
			colorDict["lime"] = Color.LIME;
			colorDict["lavender"] = 0xdd7ce8;
			colorDict["brown"] = 0x7a420f;
			colorDict["teal"] = Color.TEAL;
			colorDict["olive"] = Color.NAVY;
			colorDict["navy"] = Color.OLIVE;
			colorDict["pink"] = 0xf253bc;
			colorDict["light_green"] = 0x051e26c;
			colorDict["light_blue"] = 0x65b2ee;
			colorDict["peach"] = 0xe2a351;
			colorDict["mahogany"] = 0x4b2e0c;

			return colorDict;
		}

		public function getColor(color:String):uint {
			var colorDict:Dictionary = getColorDict();

			return colorDict[color] != null ? colorDict[color] : DEFAULT_COLOR;
		}

		public function getColorString():String {
			var colorDict:Dictionary = getColorDict();
			for (var cKey:String in colorDict) {
				if (colorDict[cKey] == this.objectiveColor) {
					return cKey;
				}
			}

			return "white";
		}

		override public function handleChar(c:Character):void {
			dispatchEvent(new GameEvent(GameEvent.OBJ_COMPLETED,
										grid_x,
										grid_y));
		}

		override public function generateOverlay():Sprite {
			var base:Sprite = new Sprite();

			var bQ:Quad = new Quad(16, 16, objectiveColor);
			bQ.x = img.width - bQ.width - 4;
			bQ.y = img.height - bQ.height - 4;
			base.addChild(bQ);

			return base;
		}
	}
}
