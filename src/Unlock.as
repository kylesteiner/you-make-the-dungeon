package {
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;

	public class Unlock extends Clickable {
		public static const TITLE:String = "Tile Unlocked!";
		public static const CONTINUE:String = "Click to continue";

		// The background of the popup.
		private var border:Quad;
		private var body:Sprite;

		private var titleText:TextField;
		private var closeText:TextField;

		private var entity:Sprite;
		private var entityTitle:TextField;
		private var entityText:TextField;
		private var entityType:TextField;

		public function Unlock(img:Image,
							   overlay:Sprite,
							   name:String,
							   description:String,
							   flavor:String,
							   onClick:Function) {
			super(Util.STAGE_WIDTH / 4, Util.STAGE_HEIGHT / 4, onClick);

			border = new Quad(Util.STAGE_WIDTH / 2, Util.STAGE_HEIGHT / 2, Color.BLACK);
			addChild(border);

			body = new Sprite();
			body.addChild(new Quad(border.width - 4, border.height - 4, Color.WHITE));
			body.x = 2;
			body.y = 2;
			addChild(body);

			titleText = new TextField(body.width,
									  Util.LARGE_FONT_SIZE,
									  TITLE,
									  Util.DEFAULT_FONT,
									  Util.LARGE_FONT_SIZE);
			titleText.x = (body.width - titleText.width) / 2;
			body.addChild(titleText);

			closeText = new TextField(body.width,
									  Util.SMALL_FONT_SIZE,
									  CONTINUE,
									  Util.DEFAULT_FONT,
									  Util.SMALL_FONT_SIZE);
			closeText.x = body.width - closeText.width;
			closeText.y = body.height - closeText.height;
			body.addChild(closeText);

			entity = new Sprite();
			entity.addChild(img);
			entity.addChild(overlay);
			entity.scaleX = 2;
			entity.scaleY = 2;
			entity.x = Util.PIXELS_PER_TILE / 4;
			entity.y = body.height / 4;
			body.addChild(entity);

			entityTitle = new TextField(body.width - entity.width - entity.x,
									   Util.MEDIUM_FONT_SIZE,
									   name,
									   Util.DEFAULT_FONT,
									   Util.MEDIUM_FONT_SIZE);
			entityTitle.autoScale = true;
			entityTitle.hAlign = HAlign.LEFT;
			entityTitle.x = entity.x + entity.width;
			entityTitle.y = entity.y;
			body.addChild(entityTitle);

			var openSpace:int = body.height - entity.y - closeText.height - entityTitle.height;

			entityText = new TextField(body.width - entity.width - entity.x,
									   openSpace * 2 / 3,
									   description,
									   Util.DEFAULT_FONT,
									   Util.MEDIUM_FONT_SIZE);
			entityText.autoScale = true;
			entityText.hAlign = HAlign.LEFT;
			entityText.x = entity.x + entity.width;
			entityText.y = entityTitle.y + entityTitle.height;
			addChild(entityText);

			entityType = new TextField(body.width - entity.width - entity.x,
									   openSpace / 3,
									   flavor,
									   Util.DEFAULT_FONT,
									   Util.MEDIUM_FONT_SIZE);
			entityType.autoScale = true;
			entityType.hAlign = HAlign.LEFT;
			entityType.x = entity.x + entity.width;
			entityType.y = entityText.y + entityText.height;
			addChild(entityType);
		}
	}
}
