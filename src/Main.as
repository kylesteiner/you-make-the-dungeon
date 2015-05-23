package {
	//import starling.core.Starling;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	[SWF(width="640", height="480", backgroundColor="#FFFFFF")]

	public class Main extends MovieClip {
		private var _starling:Object;
		private static const PROGRESS_BAR_HEIGHT:Number = 20;

		public function Main() {
			stop();
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderInfo_progressHandler);
			loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}


		private function loaderInfo_progressHandler(event:ProgressEvent):void {
			//this example draws a basic progress bar
			trace("hello");
			this.graphics.clear();
			this.graphics.beginFill(0xcccccc);
			this.graphics.drawRect(0, (this.stage.stageHeight - PROGRESS_BAR_HEIGHT) / 2,
				this.stage.stageWidth * event.bytesLoaded / event.bytesTotal, PROGRESS_BAR_HEIGHT);
			this.graphics.endFill();
		}

		private function loaderInfo_completeHandler(event:Event):void {
			graphics.clear();
			gotoAndStop(2);

			var RootType:Class = getDefinitionByName("src.Game") as Class;
			var StarlingType:Class = getDefinitionByName("starling.core.Starling") as Class;
			//_starling = new Starling(Game, stage);
			_starling = new StarlingType(RootType, stage);
			_starling.start();
		}
	}
}
