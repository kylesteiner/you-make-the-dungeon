package clickable {
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class StartGame extends Clickable {
		private var floor:String;
		private var initialHealth:int;
		private var initialAttack:int;
		private var initialStamina:int;
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
								  initialAttack:int,
								  initialStamina:int,
								  initialLoS:int) {
			super(xPos, yPos, onClick, baseDisplay, baseTexture);
			this.transition = transition;
			this.floor = floor;
			this.initialHealth = initialHealth;
			this.initialAttack = initialAttack;
			this.initialStamina = initialStamina;
			this.initialLoS = initialLoS;
		}

		override public function callCallback():void {
            onClick(transition, floor, initialHealth, initialAttack, initialStamina, initialLoS);
		}
	}
}
