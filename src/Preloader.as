package {
	//import starling.core.Starling;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.text.TextField;
	import flash.text.TextFormat;

	[SWF(width="640", height="480", backgroundColor="#FFFFFF")]

	public class Preloader extends MovieClip {
		private var _starling:Object;
		private static const PROGRESS_BAR_HEIGHT:Number = 20;
		private static const TEXT_CHANGE_FREQUENCY:Number = 10;
		private var loadText:TextField;
		private var percentLoaded:TextField;
		private var loadTexts:Array;
		private var lastChange:Number;

		public function Preloader() {
			stop();
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderInfo_progressHandler);
			loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			loadTexts = new Array();
			loadTexts.push("Server minions grabbing content...");
			loadTexts.push("Recruiting adventurers...");
			loadTexts.push("Establishing darkness...");
			loadTexts.push("Baking cakes...");
			loadTexts.push("Earmarking gold expenditures...");
			loadTexts.push("Training mages...");
			loadTexts.push("Stashing loot...");
			loadTexts.push("Accumulating dust...");
			loadTexts.push("Composing music...");
			loadTexts.push("Writing thesis...");
			loadTexts.push("And on the seventh day...");
			loadTexts.push("Spreading rumors...");
			loadTexts.push("Lobbying adventurer's guild...");
			loadTexts.push("Enumerating tiles...");
			loadTexts.push("Hiring minions...");
			loadTexts.push("Accentuating shadows...");
			loadTexts.push("Is it wrong to hit people in dungeons?");
			loadTexts.push("Ensnaring trapmakers...");
			loadTexts.push("Laying brick...");

			percentLoaded = new TextField();
			percentLoaded.width = stage.stageWidth;
			percentLoaded.defaultTextFormat = new TextFormat("Arial", 24);
			percentLoaded.x = (stage.stageWidth - percentLoaded.width) / 2;
			percentLoaded.y = (stage.stageHeight - percentLoaded.height) / 2;


			loadText = new TextField();
			loadText.width = stage.stageWidth;
			loadText.defaultTextFormat = new TextFormat("Arial", 30);
			loadText.appendText(loadTexts[randInt(0, loadTexts.length - 1)]);
			loadText.x = (stage.stageWidth - loadText.width) / 2;
			loadText.y = percentLoaded.y - loadText.height + 32;

			lastChange = 0;

			addChild(loadText);
			addChild(percentLoaded);
		}

		private function randInt(min:int, max:int):int {
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}


		private function loaderInfo_progressHandler(event:ProgressEvent):void {
			//this example draws a basic progress bar
			this.graphics.clear();
			this.graphics.beginFill(0xcccccc);
			this.graphics.drawRect(0, (this.stage.stageHeight - PROGRESS_BAR_HEIGHT) / 2,
  									   this.stage.stageWidth * event.bytesLoaded / event.bytesTotal, PROGRESS_BAR_HEIGHT);
			this.graphics.endFill();

			var dispString:String = new String((event.bytesLoaded / event.bytesTotal) * 100);
			dispString = dispString.substr(0, 5);
			percentLoaded.text = dispString + "%";

			if(((event.bytesLoaded / event.bytesTotal) * 100) - lastChange > TEXT_CHANGE_FREQUENCY) {
				lastChange = (event.bytesLoaded / event.bytesTotal) * 100;
				loadText.text = loadTexts[randInt(0, loadTexts.length - 1)];
			}

			loadText.x = (stage.stageWidth - loadText.width) / 2;
			percentLoaded.x = (stage.stageWidth - percentLoaded.width) / 2;
		}

		private function loaderInfo_completeHandler(event:Event):void {
			graphics.clear();
			removeChild(loadText);
			removeChild(percentLoaded);
			gotoAndStop(2);

			var RootType:Class = getDefinitionByName("Main") as Class;
			var StarlingType:Class = getDefinitionByName("starling.core.Starling") as Class;
			_starling = new StarlingType(RootType, stage);
			_starling.start();
		}
	}
}
