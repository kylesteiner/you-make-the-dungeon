// MindJolt API Library
// ActionScript 3

package {
	
	import flash.display.Loader
	import flash.display.LoaderInfo
	import flash.net.URLRequest
	import flash.events.Event
	import flash.display.MovieClip
	import flash.system.Security

	public class MindJoltAPI {
		
		public static var service:Object = { connect: load_service }
		public static var ad:Object = { showPreGameAd: showPreGameAd }
		
		public static function showPreGameAd(options:Object=null):void {
			if (clip == null) {
				trace("[MindJoltAPI] You must call MindJoltAPI.service.connect before MindJoltAPI.ad.showPreGameAd.")
			}
			if (options == null) {
				options = {}
			}
			if (service.showPreGameAd != undefined) {
				service.showPreGameAd(options)
			} else {
				MindJoltAPI.options = options
				if (options["ad_started"] == null) {
					options["clip"].stop()
				}
			}
		}
		
		/*
			--------------
			nuts and bolts
			--------------
		*/
		
		private static var gameKey:String
		private static var clip:MovieClip
		private static var callback:Function
		private static var options:Object
		private static var version:String = "1.0.4"
		
		private static function load_service_complete(e:Event):void {
			if (e.currentTarget.content != null && e.currentTarget.content.service != null) {
				service = e.currentTarget.content.service
				trace ("[MindJoltAPI] service successfully loaded")
				service.connect(gameKey, clip, callback)
				if (options != null) {
					service.showPreGameAd(options)
				}
				service.getLogger().info("MindJoltAPI loader version [" + version + "]")
			} else {
				trace("[MindJoltAPI] failed to load")
			}
		}
		
		private static function load_service(gameKey:String, clip:MovieClip, callback:Function=null):void {
			MindJoltAPI.gameKey = gameKey
			MindJoltAPI.clip = clip
			MindJoltAPI.callback = callback
			if (service.submitScore == null) {
				Security.allowDomain("static.mindjolt.com")
				var game_params:Object = LoaderInfo(clip.root.loaderInfo).parameters
				var loader:Loader = new Loader()
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, load_service_complete)
				loader.load(new URLRequest(game_params.mjPath || "http://static.mindjolt.com/api/as3/api_local_as3.swf"))
				clip.addChild(loader)
			}
		}
	}
}