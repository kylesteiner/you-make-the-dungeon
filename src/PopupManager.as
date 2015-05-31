package {
	import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;

	public class PopupManager extends Sprite {
		public var popup:Sprite; // Reward / Combat / Exit
		public var summary:Summary;
		
		public function PopupManager():void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function addPopup(popup:Sprite):void {
			addChild(popup);
			this.popup = popup;
		}
		
		public function removePopup():void {
			removeChild(popup);
			popup = null;
		}
		
		public function addSummary(summary:Summary):void {
			this.summary = summary;
		}
		
		public function removeSummary():void {
			removeChild(summary);
			this.summary = null;
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void {
			if (!popup && summary && getChildIndex(summary) == -1) {
				addChild(summary);
			}
		}
	}

}