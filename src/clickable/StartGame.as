package clickable {
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class StartGame extends Clickable {
		private var floor:String;
		private var initialHealth:int;
		private var initialStamina:int;
		private var initialAttack:int;
		private var initialLoS:int;
		private var transition:Texture;

		public function StartGame(xPos:int,
                                  yPos:int,
                                  onClick:Function,
                                  baseDisplay:DisplayObject,
                                  baseTexture:Texture,
								  transition:Texture,
								  floor:String,
								  initialHealth:int,
								  initialStamina:int,
								  initialAttack:int,
								  initialLoS:int) {
			super(xPos, yPos, onClick, baseDisplay, baseTexture);
			this.transition = transition;
			this.floor = floor;
			this.initialHealth = initialHealth;
			this.initialStamina = initialStamina;
			this.initialAttack = initialAttack;
			this.initialLoS = initialLoS;
		}

		override public function callCallback():void {
            onClick(transition, floor, initialHealth, initialStamina, initialAttack, initialLoS);
		}
	}
}
