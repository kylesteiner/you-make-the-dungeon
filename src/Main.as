package {
    import flash.ui.Mouse;
    import flash.utils.Dictionary;

    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;

    public class Main extends Sprite {
        private var menu:Menu;
        private var game:Game;
        private var credits:Credits;

        // Assets
        private var textures:Dictionary;  // Map String -> Texture
		private var floors:Dictionary; // Map String -> String
		private var animations:Dictionary; // Map String -> Dictionary<String, Vector<Texture>>

        // Logger
        private var cid:int;
        private var versionID:int;

        // Cursor
        private var cursorAnim:MovieClip;
		private var cursorReticle:Image;

        // Background
        private var staticBackgroundImage:Image;

        // Sound
        private var bgm:Array;
        private var sfx:Dictionary; // Map String -> SFX
        private var mixer:Mixer;
        private var bgmMuteButton:Clickable;
		private var sfxMuteButton:Clickable;

        public function Main() {
            // Set up asset dictionaries.
            textures = Embed.setupTextures();
			floors = Embed.setupFloors();
			animations = Embed.setupAnimations();

            // Initialize the custom cursor.
            Mouse.hide();
            cursorReticle = new Image(textures[Util.CURSOR_RETICLE]);
			cursorReticle.touchable = false;
			addChild(cursorReticle);
			cursorAnim = new MovieClip(animations[Util.ICON_CURSOR][Util.ICON_CURSOR], Util.ANIM_FPS);
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
            sfx = Embed.setupSFX();
			bgm = Embed.setupBGM();
			mixer = new Mixer(bgm, sfx);
			addChild(mixer);
			Util.mixer = mixer;

            // Initialize sound controls.
            sfxMuteButton = new Clickable(0, 0, toggleSFXMute, null, textures[Util.ICON_SFX_PLAY]);
			sfxMuteButton.x = Util.STAGE_WIDTH - sfxMuteButton.width - Util.UI_PADDING;
			sfxMuteButton.y = Util.STAGE_HEIGHT - sfxMuteButton.height - Util.UI_PADDING;
			bgmMuteButton = new Clickable(0, 0, toggleBgmMute, null, textures[Util.ICON_BGM_PLAY]);
			bgmMuteButton.x = sfxMuteButton.x - bgmMuteButton.width - Util.UI_PADDING;
			bgmMuteButton.y = sfxMuteButton.y;

            staticBackgroundImage = new Image(textures[Util.STATIC_BACKGROUND]);
			addChild(staticBackgroundImage);

            // Display the main menu.
            menu = new Menu(versionID, cid, bgmMuteButton, sfxMuteButton);
            addChild(menu);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(TouchEvent.TOUCH, onTouchEvent);

            addEventListener(MenuEvent.NEW_GAME, function():void { startGame(false); });
            addEventListener(MenuEvent.CONTINUE_GAME, function():void { startGame(true); });
            addEventListener(MenuEvent.EXIT, returnToMenu);
            addEventListener(MenuEvent.CREDITS, displayCredits);
        }

        // Switches from the menu to the game.
        public function startGame(fromSave:Boolean):void {
            removeChild(menu);
            game = new Game(fromSave, textures, animations, floors, mixer, sfxMuteButton, bgmMuteButton, cursorReticle, cursorAnim);
            addChild(game);
        }

        // Switches from the game/credits to the menu.
        public function returnToMenu():void {
            // Ok to remove both credits and game - if either doesn't exist
            // nothing happens.
            removeChild(credits);
            removeChild(game, true);  // Dispose of all sprites in Game.
            addChild(menu);
        }

        // Switches from the credits to the menu.
        public function displayCredits():void {
            removeChild(menu);
            credits = new Credits();
            addChild(credits);
        }

        // Sound controls.
        public function toggleBgmMute():void {
			mixer.togglePlay();
			Util.logger.logAction(15, {
				"buttonClicked":"BGM Mute"
			});
			var chosen:String = mixer.playing ? Util.ICON_BGM_PLAY : Util.ICON_BGM_MUTE;
			bgmMuteButton.updateImage(null, textures[chosen]);
		}

		public function toggleSFXMute():void {
			mixer.toggleSFXMute();
			Util.logger.logAction(15, {
				"buttonClicked":"SFX Mute"
			});
			var chosen:String = mixer.sfxMuted ? Util.ICON_SFX_MUTE : Util.ICON_SFX_PLAY;
			sfxMuteButton.updateImage(null, textures[chosen]);
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
