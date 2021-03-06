package {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;

	[SWF(width="640", height="480", backgroundColor="#FFFFFF")]

	public class Preloader extends MovieClip {
		private var _starling:Object;
		private static const PROGRESS_BAR_HEIGHT:Number = 20;
		private static const TEXT_CHANGE_FREQUENCY:Number = 10;
		private var loadText:TextField;
		private var percentLoaded:TextField;
		private var progressBar:Sprite;
		private var loadTexts:Array;
		private var lastChange:Number;

		[Embed(source='assets/backgrounds/menu_bg.png')] private var menu_background:Class;
		private var preloaderBackground:Bitmap;

		private static const sitelock:Boolean = false;
		private static const allowedUrls:Array = new Array("uploads.ungrounded.net");

		public function Preloader() {
			stop();

			preloaderBackground = new menu_background();
			addChild(preloaderBackground);

			var isAllowed:Boolean = false;
			for each (var url:String in allowedUrls) {
				if (loaderInfo.url.indexOf(url) != -1) {
					isAllowed = true;
					break;
				}
			}
			if (!isAllowed && sitelock) {
				var t:TextField = new TextField();
				t.defaultTextFormat = new TextFormat("Arial", 30);
				t.width = stage.stageWidth;
				t.height = stage.stageHeight;
				t.x = 0;
				t.y = 0;
				t.text = "You Make The Dungeon is not supported\non this site! Click anywhere to\nplay this game on Kongregate!";
				addChild(t);

				addEventListener(MouseEvent.CLICK, navToKongregate);
				return;
			}

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
			percentLoaded.height = 35;
			percentLoaded.defaultTextFormat = new TextFormat("Arial", 24);
			percentLoaded.x = (stage.stageWidth - percentLoaded.width) / 2;
			percentLoaded.y = stage.stageHeight - percentLoaded.height - PROGRESS_BAR_HEIGHT;

			loadText = new TextField();
			loadText.width = stage.stageWidth;
			loadText.height = 40;
			loadText.defaultTextFormat = new TextFormat("Arial", 30);
			loadText.appendText(loadTexts[randInt(0, loadTexts.length - 1)]);
			loadText.x = (stage.stageWidth - loadText.width) / 2;
			loadText.y = percentLoaded.y - loadText.height;

			progressBar = new Sprite();
			lastChange = 0;

			addChild(loadText);
			addChild(percentLoaded);
			addChild(progressBar);
		}

		private function randInt(min:int, max:int):int {
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}


		private function loaderInfo_progressHandler(event:ProgressEvent):void {
			progressBar.graphics.clear();
			progressBar.graphics.beginFill(0x0f9dd1);
			progressBar.graphics.drawRect(0, stage.stageHeight - PROGRESS_BAR_HEIGHT,
										  stage.stageWidth * event.bytesLoaded / event.bytesTotal, PROGRESS_BAR_HEIGHT);
			progressBar.graphics.endFill();

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
			removeChild(loadText);
			removeChild(percentLoaded);
			removeChild(progressBar);
			removeChild(preloaderBackground);
			gotoAndStop(2);

			var RootType:Class = getDefinitionByName("Main") as Class;
			var StarlingType:Class = getDefinitionByName("starling.core.Starling") as Class;
			_starling = new StarlingType(RootType, stage);
			_starling.start();
		}

		private function navToKongregate(event:MouseEvent):void {
			var request:URLRequest = new URLRequest("http://www.kongregate.com/games/kingxia/you-make-the-dungeon");
			request.method = URLRequestMethod.GET;
			var target:String = "_blank";
			navigateToURL(request, target);
		}
	}
}
