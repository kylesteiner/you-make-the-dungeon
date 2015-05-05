package {
    import flash.media.*;
    import starling.events.*;
    import flash.display.*;

    public class Mixer extends Sprite {

        public var songList:Array;
        public var currentSound:Sound;
        public var player:SoundChannel;
        public var playing:Boolean;

        public function Mixer(songs:Array) {
            super();
            
            // TODO: do we need to check that songs is full of Sound?
            songList = songs;

            currentSound = pickRandomSong();
            player = currentSound.play();
            playing = true;
        }

        private function pickRandomSong():Sound {
            return songList[Math.floor(Math.random() * songList.length)];
        }

        public function togglePlay():void {
            if(playing) {
                player.stop();
                playing = false;
            } else {
                player = currentSound.play();
                playing = true;
            }
        }
    }
}
