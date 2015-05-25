package {
	import cgs.server.NtpTimeService;
	import cgs.server.logging.CGSServerConstants;
	import cgs.server.logging.CGSServerProps;
	import cgs.server.logging.CgsServerApi;
	import cgs.server.logging.GameServerData;
	import cgs.server.logging.ICgsServerApi;
	import cgs.server.logging.actions.IClientAction;
	import cgs.server.logging.actions.QuestAction;
	import cgs.server.requests.IUrlRequestHandler;
	import cgs.server.requests.UrlRequestHandler;
	import cgs.server.responses.QuestLogResponseStatus;
	import cgs.server.responses.UidResponseStatus;
	import cgs.user.CgsUser;
	import cgs.user.CgsUserProperties;
	import cgs.user.ICgsUser;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Logger
	{
		private var server:ICgsServerApi;
		private var levelStartTime:Number;
		private var canLog:Boolean;

		private static function loadUrl(req:URLRequest, callback:Function):void {
			var loader:URLLoader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);

			try {
				loader.load(req);
			} catch (e:Error) {
				callback(null);
			}

			function onLoad(e:Event):void {
				loader.removeEventListener(Event.COMPLETE, onLoad);
				callback((e.target as URLLoader).data);
			}

			function onError(e:IOErrorEvent):void {
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				//Let the callback know we've failed with a null argument
				callback(null);
			}
		}

		/**
		 * Creates the logger given game data.
		 *
		 * gid, name, and skey should been provided to you and are unique to your game.
		 *
		 * The data object can be an arbitrary AS object, which will be
		 * converted to JSON and stored with the pageload log.
		 *
		 * The system will also automatically log system information such
		 * as their OS, language settings, etc.
		 *
		 * Returns the logger, which is available for immediate use.
		 *
		 * @param cid: The category id to use for this session. All logs will
		 * have this cid attached, and the logs can be later be filtered by cid.
		 * Usually, a cid denotes a "version" and is used to figure out which data
		 * came from which version of the game on what website after the fact.
		 * @param useDev: Log to the development server if true, else log to production.
		 */
		public static function initialize(gid:int, name:String, skey:String, cid:int, data:Object, useDev:Boolean=true):Logger
		{
			if (gid <= 0 || name == null || skey == null) throw new ArgumentError("invalid game info");

			var logger:Logger = new Logger();

			//The DOLOG_URL allows us to change a server to turn off logging for any individual game in case the game is pirated and hammers our servers
			//This still allows initial events to fire, but turns off future events once the link resolves
			var DOLOG_URL:String = "http://games.cs.washington.edu/cgs/py/cse481d/dolog.py?gid=" + gid.toString() + "&code=296589243658621";
			var handler:IUrlRequestHandler = new UrlRequestHandler();
			logger.server = new CgsServerApi(handler, new NtpTimeService(handler, false));
			var props:CgsUserProperties = new CgsUserProperties(skey, 0, name, gid, 1, cid, useDev ? CGSServerProps.DEVELOPMENT_SERVER : CGSServerProps.PRODUCTION_SERVER);
			var user:ICgsUser = new CgsUser(logger.server);
			logger.server.initializeUser(user, props);


			var request:URLRequest = new URLRequest(DOLOG_URL);
			request.method = "GET";
			loadUrl(request, function(result:String):void {
				if (result == null || result.charAt(0) != "1") {
					trace("Disabling future logging due to server setting.");
					logger.server.disableLogging();
					logger.logLevelStart(12,null)
				}
			});

			return logger;
		}

		/**
		 * Logs the start of a level with the given level qid.
		 * You should guarantee each level in you game has a distict qid.
		 * The data object can be an arbitrary AS object, which will be
		 * converted to JSON and stored with the log.
		 * A dqid will be automatically generated for this trace.
		 * Call logLevelEnd once the trace is over (though this isn't necessary
		 * for logging purposes so everyting is still logged if the player,
		 * say, closes the browser during the level).
		 */
		public function logLevelStart(qid:int, data:Object):void
		{
			if (qid <= 0) throw new ArgumentError("qid must be positive");
			server.logQuestStart(qid, null, data, function f(q:QuestLogResponseStatus):void {
				trace("Logging quest with dqid: " + q.dqid);
			});
			levelStartTime = new Date().time;
			canLog = true;
		}

		/**
		 * Logs an action of the given action type aid.
		 * The action will be associated with the current trace,
		 * so make sure to call logLevelStart before logging actions.
		 * The data object can be an arbitrary AS object, which will be
		 * converted to JSON and stored with the log.
		 */
		public function logAction(aid:int, data:Object):void
		{
			if(!canLog) {
				return;
			}
			if (aid <= 0) throw new ArgumentError("aid must be positive");
			var action:QuestAction = new QuestAction(aid, new Date().time - levelStartTime);
			action.setDetail(data);
			server.logQuestAction(action);
		}

		/**
		 * Logs the end of a level, which ends the trace.
		 * You must have first called logLevelStart.
		 * The data object can be an arbitrary AS object, which will be
		 * converted to JSON and stored with the log.
		 */
		public function logLevelEnd(data:Object):void
		{
			server.logQuestEnd(data);
			canLog = false;
		}
	}
}
