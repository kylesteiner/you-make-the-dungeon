package {
	import cgs.fractionVisualization.fractionAnimators.strip.StripCompareSizeAnimator;
    import flash.ui.Mouse;
    import flash.utils.Dictionary;

    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;

	import menu.*;

    public class Main extends Sprite {
        private var mainMenu:Menu;
        private var game:Game;
        private var credits:Credits;
		private var detailedCredits:DetailedCredits;
		private var scores:Scores;

        // Logger
        private var cid:int;
        private var versionID:int;

        // Cursor
        private var cursorAnim:MovieClip;
		private var cursorReticle:Image;

        // Backgrounds
        private var menuBackgroundImage:Image;
		private var gameBackgroundImage:Image;

        // Sound
        private var bgmMuteButton:Clickable;
		private var sfxMuteButton:Clickable;

		// Kongregate API reference
		public static var kongregate:*;

        public function Main() {
            addEventListener(Event.ADDED_TO_STAGE, initialize);
        }
        public function initialize():void {
            // Set up asset dictionaries.
            Embed.setupTextures();
			Embed.setupFloors();
			Embed.setupAnimations();

            // Initialize the custom cursor.
            Mouse.hide();
            cursorReticle = new Image(Assets.textures[Util.CURSOR_RETICLE]);
			cursorReticle.touchable = false;
			addChild(cursorReticle);
			cursorAnim = new MovieClip(Assets.animations[Util.ICON_CURSOR][Util.ICON_CURSOR], Util.ANIM_FPS);
			cursorAnim.loop = true;
			cursorAnim.play();
			cursorAnim.touchable = false;
			addChild(cursorAnim);

            // Initialize the logger.
            var gid:uint = 115;
			var gname:String = "cgs_gc_YouMakeTheDungeon";
			var skey:String = "9a01148aa509b6eb4a3945f4d845cadb";
            // This is the current version. We'll treat 0 as the debugging
			// version, and release versions will be assigned unique cids.
			versionID = 0;
			cid = 0;
			Util.logger = Logger.initialize(gid, gname, skey, cid, null, false);

            // Initialize sound assets and mixer.
            var sfx:Dictionary = Embed.setupSFX();
			var bgm:Array = Embed.setupBGM();
			Assets.mixer = new Mixer(bgm, sfx);
			addChild(Assets.mixer);

            // Initialize sound controls.
            sfxMuteButton = new Clickable(0, 0, toggleSFXMute, null, Assets.textures[Util.ICON_SFX_PLAY]);
			sfxMuteButton.x = Util.STAGE_WIDTH - sfxMuteButton.width - Util.UI_PADDING;
			sfxMuteButton.y = Util.STAGE_HEIGHT - sfxMuteButton.height - Util.UI_PADDING;
			bgmMuteButton = new Clickable(0, 0, toggleBgmMute, null, Assets.textures[Util.ICON_BGM_PLAY]);
			bgmMuteButton.x = sfxMuteButton.x - bgmMuteButton.width - Util.UI_PADDING;
			bgmMuteButton.y = sfxMuteButton.y;

            menuBackgroundImage = new Image(Assets.textures[Util.MENU_BACKGROUND]);
			gameBackgroundImage = new Image(Assets.textures[Util.GAME_BACKGROUND]);

            // Display the main menu.
			mainMenu = new Menu(versionID, cid, bgmMuteButton, sfxMuteButton);
			addChild(menuBackgroundImage);
            addChild(mainMenu);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(TouchEvent.TOUCH, onTouchEvent);

            addEventListener(MenuEvent.NEW_GAME, function():void { startGame(false); });
            addEventListener(MenuEvent.CONTINUE_GAME, function():void { startGame(true); });
            addEventListener(MenuEvent.EXIT, returnToMenu);
            addEventListener(MenuEvent.CREDITS, displayCredits);
			addEventListener(MenuEvent.DETAILED_CREDITS, displayDetailedCredits);
			addEventListener(MenuEvent.SCORES, displayScores);
        }

        // Switches from the menu to the game.
        public function startGame(fromSave:Boolean):void {
            game = new Game(fromSave, sfxMuteButton, bgmMuteButton);
			removeChild(mainMenu);
			removeChild(menuBackgroundImage);
			addChild(gameBackgroundImage);
            addChild(game);
        }

        // Switches from the game/credits to the menu.
        public function returnToMenu():void {
            // Ok to remove both credits and game and scores - if either doesn't exist
            // nothing happens.
            removeChild(credits);
			removeChild(scores);
            removeChild(game, true);  // Dispose of all sprites in Game.
			removeChild(gameBackgroundImage);
			addChild(menuBackgroundImage);
            addChild(mainMenu);
        }

        // Switches from the credits to the menu.
        public function displayCredits():void {
            removeChild(mainMenu);
			removeChild(detailedCredits);
            credits = new Credits();
            addChild(credits);
        }

		public function displayDetailedCredits():void {
			removeChild(credits);
			detailedCredits = new DetailedCredits();
			addChild(detailedCredits);
		}

		public function displayScores():void {
			removeChild(mainMenu);
			scores = new Scores();
			addChild(scores);
		}

        // Sound controls.
        public function toggleBgmMute():void {
			Assets.mixer.togglePlay();
			Util.logger.logAction(15, {
				"buttonClicked":"BGM Mute"
			});
			var chosen:String = Assets.mixer.playing ? Util.ICON_BGM_PLAY : Util.ICON_BGM_MUTE;
			bgmMuteButton.updateImage(null, Assets.textures[chosen]);
		}

		public function toggleSFXMute():void {
			Assets.mixer.toggleSFXMute();
			Util.logger.logAction(15, {
				"buttonClicked":"SFX Mute"
			});
			var chosen:String = Assets.mixer.sfxMuted ? Util.ICON_SFX_MUTE : Util.ICON_SFX_PLAY;
			sfxMuteButton.updateImage(null, Assets.textures[chosen]);
		}

        public function onEnterFrame(event:EnterFrameEvent):void {
            cursorAnim.advanceTime(event.passedTime);

            addChild(cursorAnim);
            addChild(cursorReticle);
        }

        public function onTouchEvent(event:TouchEvent):void {
            var touch:Touch = event.getTouch(this);
			if(!touch) {
				return;
			}
            // TODO: make it so cursorAnim can move outside of the world
			cursorReticle.x = touch.globalX - cursorReticle.width / 2;
			cursorReticle.y = touch.globalY - cursorReticle.height / 2 - 2;
			cursorAnim.x = touch.globalX + Util.CURSOR_OFFSET_X;
			cursorAnim.y = touch.globalY + Util.CURSOR_OFFSET_Y;
        }
    }
}
