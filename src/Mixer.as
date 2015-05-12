package {
    import flash.media.*;
    import starling.display.*;
    import flash.utils.Dictionary;
    import starling.events.*;

    public class Mixer extends Sprite {

        public var songList:Array;
        public var currentSound:Sound;
        public var player:SoundChannel;
        public var playing:Boolean;

        public var sfx:Dictionary;
        public var sfxMuted:Boolean;

        public function Mixer(songs:Array, sfxDict:Dictionary) {
            super();

            // TODO: do we need to check that songs is full of Sound?
            songList = songs;
            sfx = sfxDict;
            sfxMuted = false;

            currentSound = pickRandomSong();
            player = currentSound.play();
            playing = true;

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        public function play(s:String):void {
            if(!sfxMuted && s in sfx) {
                sfx[s].play();
            }
        }

        public function toggleSFXMute():void {
            sfxMuted = !sfxMuted;
        }

        private function pickRandomSong():Sound {
            return songList[Math.floor(Math.random() * songList.length)];
        }

        public function togglePlay():void {
            if(playing) {
                player.stop();
                playing = false;
            } else {
                currentSound = pickRandomSong();
                player = currentSound.play();
                playing = true;
            }
        }

        public function onEnterFrame(e:EnterFrameEvent):void {
            if(player.position >= currentSound.length - 1) {
                player.stop();
                currentSound = pickRandomSong();
                player = currentSound.play();
            }
        }
    }
}
