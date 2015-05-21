package {
	import starling.display.*;
	import flash.utils.Dictionary;
	import starling.textures.*;
	import starling.events.*;

	import tiles.*;
	import entities.*;
	import clickable.*;

	public class BuildHUD extends Sprite {
		public static const QUAD_BORDER_PIXELS:int = 2;
		public static const HUD_MARGIN:int = 8;
		public static const TOP:int = HUD_MARGIN;
		public static const LEFT:int = HUD_MARGIN;
		public static const COLOR_TRUE:uint = 0x00ff00;
		public static const COLOR_FALSE:uint = 0xff0000;
		public static const COLOR_SELECTED:uint = 0x00ff00;
		public static const COLOR_DESELECTED:uint = 0x666666;
		public static const ENTITIES_PER_LINE:int = 4;
		public static const SELECT_BUTTON_WIDTH:int = 48;
		public static const SELECT_BUTTON_HEIGHT:int = 16;
		public static const SELECT_BUTTON_MARGIN:int = 4;

		private var textures:Dictionary;
		private var highlightedLocations:Array; // Why is this being managed in BuildHUD?

		/***** Overall HUD *****/
		// sprites that contain the tile and entity selection
		// will be used when we have real textures
		private var tileBlock:Sprite;
		private var entityBlock:Sprite;
		// image to display beneath mouse cursor
		public var currentImage:Image;
		// true if entity should be shown, false if tile is shown
		public var isEntityDisplay:Boolean;
		// maps strings to arrays
		// array[0] is the constructor for the entity
		// array[1] is the texture
		// array[2] is the cost
		// array[3] is the category (int)
		private var entityMap:Dictionary;

		/***** Tile Block *****/
		// an array of Booleans, which indicate whether each direction is open or not
		public var directions:Array;
		// base tile image
		// will be used when we have real textures
		private var baseImage:Image;
		// the resultant image given the base + directions
		private var currentTile:Image;

		/***** Entity Block *****/
		// list of unlocked entities (Array of Arrays, one array per category)
		// second level of arrays have strings in them which correspond to
		// keys in the entity map
		private var entityList:Array;
		// list of ints which correspond to indices within the array of arrays
		private var entityDisplayList:Array;
		// currently selected entity
		private var currentEntity:Image;
		// the array index being used
		private var currentEntityIndex:int;

		/***** UI Elements *****/
		private var tileQuad:Quad; // Rect drawn for background of tile select
		private var northToggle:Clickable;
		private var southToggle:Clickable;
		private var eastToggle:Clickable;
		private var westToggle:Clickable;
		private var toggleButtons:Array;
		private var nButton:Quad;
		private var sButton:Quad;
		private var wButton:Quad;
		private var eButton:Quad;
		private var tileSelectButton:Clickable;

		private var entityQuad:Quad; // Rect drawn for background of entity select
		private var popup:Sprite;
		private var entityClickables:Array;
		private var entitySelectButtons:Array;

		private var logger:Logger;
		private var entityFactory:EntityFactory;

		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/

		public function BuildHUD(textureDict:Dictionary, logger:Logger) {
			super();
			this.logger = logger;
			this.entityFactory = new EntityFactory(textureDict, logger);
			this.textures = textureDict;

			highlightedLocations = new Array();

			tileBlock = new Sprite();
			entityBlock = new Sprite();
			addChild(tileBlock);
			addChild(entityBlock);
			currentImage = null;

			isEntityDisplay = true;
			this.entityMap = entityFactory.entitySet;

			directions = new Array(Util.DIRECTIONS.length);
			baseImage = null;
			currentTile = null;

			entityList = buildEntityList();
			entityDisplayList = new Array();
			for(var i:int; i < entityList.length; i++) {
				entityDisplayList.push(0);
			}

			currentEntity = null;
			currentEntityIndex = -1;

			createUI();
		}

		public function buildEntityList():Array {
			var entityData:Array;

			var arrayLen:int = 2;
			var key:String;
			for (key in entityMap) {
				entityData = entityMap[key];
				if(entityData != null && entityData.length >= 4) {
					arrayLen = entityData[3] > arrayLen ? entityData[3] : arrayLen;
				}
			}

			var tempEL:Array = new Array();
			for(var i:int = 0; i < arrayLen; i++) {
				tempEL.push(new Array());
			}


			for (key in entityMap) {
				entityData = entityMap[key];
				if(entityData != null && entityData.length >= 4) {
					tempEL[entityData[3]].push(key);
				}
			}

			return tempEL;
		}

		public function createUI():void {
			tileQuad = new Quad(Util.PIXELS_PER_TILE, Util.PIXELS_PER_TILE + SELECT_BUTTON_HEIGHT + SELECT_BUTTON_MARGIN, 0x000000);
			tileQuad.x = LEFT;
			tileQuad.y = TOP;

			var interiorTQ:Quad = new Quad(tileQuad.width - 2*QUAD_BORDER_PIXELS,
									  	   tileQuad.height - 2*QUAD_BORDER_PIXELS);
			interiorTQ.x = tileQuad.x + QUAD_BORDER_PIXELS;
			interiorTQ.y = tileQuad.y + QUAD_BORDER_PIXELS;

			var tileCornerSize:int = 16;
			var tileCornerColor:uint = 0x666666;
			var tileNWCorner:Quad = new Quad(tileCornerSize, tileCornerSize, tileCornerColor);
			tileNWCorner.x = tileQuad.x + QUAD_BORDER_PIXELS;
			tileNWCorner.y = tileQuad.y + QUAD_BORDER_PIXELS;
			var tileNECorner:Quad = new Quad(tileCornerSize, tileCornerSize, tileCornerColor);
			tileNECorner.x = tileQuad.x + tileQuad.width - tileNECorner.width - QUAD_BORDER_PIXELS;
			tileNECorner.y = tileNWCorner.y;
			var tileSWCorner:Quad = new Quad(tileCornerSize, tileCornerSize, tileCornerColor);
			tileSWCorner.x = tileNWCorner.x;
			tileSWCorner.y = tileQuad.y + tileQuad.height - tileSWCorner.height - QUAD_BORDER_PIXELS - SELECT_BUTTON_HEIGHT - SELECT_BUTTON_MARGIN;
			var tileSECorner:Quad = new Quad(tileCornerSize, tileCornerSize, tileCornerColor);
			tileSECorner.x = tileNECorner.x;
			tileSECorner.y = tileSWCorner.y;

			var tileSelectQuad:Quad = new Quad(SELECT_BUTTON_WIDTH,
											   SELECT_BUTTON_HEIGHT,
											   COLOR_DESELECTED);
			tileSelectButton = new Clickable(tileQuad.x + (tileQuad.width - tileSelectQuad.width) / 2,
											 tileQuad.y + tileQuad.height - SELECT_BUTTON_HEIGHT - 2*QUAD_BORDER_PIXELS,
											 selectTile, tileSelectQuad);

			toggleButtons = new Array();
			nButton = new Quad(Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - 2*tileNWCorner.height, tileCornerSize, COLOR_FALSE);
			sButton = new Quad(Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - 2*tileNWCorner.height, tileCornerSize, COLOR_FALSE);
			eButton = new Quad(tileCornerSize, Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - 2*tileNWCorner.width, COLOR_FALSE);
			wButton = new Quad(tileCornerSize, Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - 2*tileNWCorner.width, COLOR_FALSE);
			toggleButtons.push(nButton);
			toggleButtons.push(sButton);
			toggleButtons.push(eButton);
			toggleButtons.push(wButton);
			northToggle = new Clickable(tileNWCorner.x + tileNWCorner.width, tileNWCorner.y, toggleNorth, nButton);
			southToggle = new Clickable(tileSWCorner.x + tileSWCorner.width, tileSWCorner.y, toggleSouth, sButton);
			eastToggle = new Clickable(tileNECorner.x, tileNECorner.y + tileNWCorner.height, toggleEast, eButton);
			westToggle = new Clickable(tileNWCorner.x, tileNWCorner.y + tileNWCorner.height, toggleWest, wButton);

			entityQuad = new Quad(Util.PIXELS_PER_TILE * (entityList.length > 0 ? entityList.length : 1),
								  Util.PIXELS_PER_TILE + SELECT_BUTTON_MARGIN + SELECT_BUTTON_HEIGHT, 0x000000);
			entityQuad.x = tileQuad.x + tileQuad.width + HUD_MARGIN;
			entityQuad.y = tileQuad.y;
			var interiorEQ:Quad = new Quad(entityQuad.width - 2*QUAD_BORDER_PIXELS,
											entityQuad.height - 2*QUAD_BORDER_PIXELS);
			interiorEQ.x = entityQuad.x + QUAD_BORDER_PIXELS;
			interiorEQ.y = entityQuad.y + QUAD_BORDER_PIXELS;

			entityClickables = new Array();
			entitySelectButtons = new Array();
			var i:int; var entityX:int; var entityY:int;
			var entityTexture:Texture;
			var entityPopupButton:Clickable;
			var selectEntityButton:Clickable;
			var selectEntityQuad:Quad;
			for(i = 0; i < entityList.length; i++) {
				entityX = QUAD_BORDER_PIXELS + Util.PIXELS_PER_TILE * i + entityQuad.x;
				entityY = QUAD_BORDER_PIXELS * 2;
				entityTexture = entityMap[entityList[i][entityDisplayList[i]]][1];
				entityPopupButton = new Clickable(entityX, entityY, createPopupClickable, null, entityTexture);
				entityPopupButton.addParameter("index", i);
				entityClickables.push(entityPopupButton);

				selectEntityQuad = new Quad(SELECT_BUTTON_WIDTH, SELECT_BUTTON_HEIGHT, COLOR_DESELECTED);
				selectEntityButton = new Clickable(entityX + (entityPopupButton.width - selectEntityQuad.width) / 2,
				 								   entityY + entityPopupButton.height + SELECT_BUTTON_MARGIN,
												   selectEntityClickable, selectEntityQuad);
				selectEntityButton.addParameter("index", i);
				entitySelectButtons.push(selectEntityButton);
			}

			addChild(tileQuad);
			addChild(interiorTQ);

			addChild(tileNWCorner);
			addChild(tileNECorner);
			addChild(tileSWCorner);
			addChild(tileSECorner);
			addChild(tileSelectButton);

			addChild(northToggle);
			addChild(southToggle);
			addChild(eastToggle);
			addChild(westToggle);

			addChild(entityQuad);
			addChild(interiorEQ);

			for(i = 0; i < entityClickables.length; i++) {
				addChild(entityClickables[i]);
				addChild(entitySelectButtons[i]);
			}
		}

		public function updateUI():void {
			for(var i:int = 0; i < entityClickables.length; i++) {
				var selectEB:Clickable = entityClickables[i];
				selectEB.removeChild(selectEB.textureImage);
				selectEB.textureImage = new Image(entityMap[entityList[i][entityDisplayList[i]]][1]);
				selectEB.addChild(selectEB.textureImage);
			}
		}

		public function createPopupClickable(values:Dictionary):void {
			createPopup(values["index"]);
		}

		public function createPopup(index:int):void {
			removeChild(popup);

			popup = new Sprite();
			popup.x = entityQuad.x;
			popup.y = entityQuad.y + entityQuad.height + HUD_MARGIN;

			var dispEntities:Array = entityList[index];
			var rows:int = ((dispEntities.length - 1) / ENTITIES_PER_LINE + 1);
			var cancelWidth:int = 16;
			var entityWidth:int = Util.PIXELS_PER_TILE;
			var entityHeight:int = Util.PIXELS_PER_TILE;

			var qWidth:int = QUAD_BORDER_PIXELS * 2 + HUD_MARGIN * (ENTITIES_PER_LINE + 1) + cancelWidth + ENTITIES_PER_LINE * entityWidth;
			var qHeight:int = QUAD_BORDER_PIXELS * 2 + HUD_MARGIN * (rows + 1) + entityHeight * rows;
			var borderQuad:Quad = new Quad(qWidth, qHeight, 0x000000);
			var interiorQuad:Quad = new Quad(qWidth - 2*QUAD_BORDER_PIXELS, qHeight - 2*QUAD_BORDER_PIXELS, 0xffffff);
			interiorQuad.x = QUAD_BORDER_PIXELS;
			interiorQuad.y = QUAD_BORDER_PIXELS;

			var i:int;
			var popupEntities:Array = new Array();
			for(i = 0; i < dispEntities.length; i++) {
				var key:String = dispEntities[i];
				var entityColumn:int = i % ENTITIES_PER_LINE;
				var entityRow:int = i / ENTITIES_PER_LINE;
				var entityX:int = QUAD_BORDER_PIXELS + HUD_MARGIN * (entityColumn + 1) + entityWidth * entityColumn;
				var entityY:int = QUAD_BORDER_PIXELS + HUD_MARGIN * (entityRow + 1) + entityHeight * entityRow;
				var entityTexture:Texture = entityMap[key][1];
				var renderEntity:Clickable = new Clickable(entityX, entityY, pageEntityClickable, null, entityTexture);
				renderEntity.addParameter("index", index);
				renderEntity.addParameter("change", i);
				popupEntities.push(renderEntity);
			}

			var exitQuad:Quad = new Quad(16, 16, 0xff0000);
			var exitButton:Clickable = new Clickable(interiorQuad.x + interiorQuad.width - exitQuad.width,
													 interiorQuad.y, closePopup, exitQuad);

			popup.addChild(borderQuad);
			popup.addChild(interiorQuad);
			popup.addChild(exitButton);

			for(i = 0; i < popupEntities.length; i++) {
				popup.addChild(popupEntities[i]);
			}

			addChild(popup);
		}

		public function closePopup():void {
			removeChild(popup);
			popup = null;
		}

		public function updateSelectButtons():void {
			tileSelectButton.removeChild(tileSelectButton.baseImage);
			tileSelectButton.baseImage = new Quad(tileSelectButton.baseImage.width,
												tileSelectButton.baseImage.height,
												isEntityDisplay ? COLOR_DESELECTED : COLOR_SELECTED);
			tileSelectButton.addChild(tileSelectButton.baseImage);

			var i:int; var color:uint;
			var currentButton:Clickable;
			for(i = 0; i < entitySelectButtons.length; i++) {
				currentButton = entitySelectButtons[i];
				currentButton.removeChild(currentButton.baseImage);

				color = COLOR_DESELECTED;
				if(isEntityDisplay && i == currentEntityIndex) {
					color = COLOR_SELECTED;
				}
				currentButton.baseImage = new Quad(currentButton.baseImage.width,
												   currentButton.baseImage.height,
												   color);
				currentButton.addChild(currentButton.baseImage);
			}
		}

		/**********************************************************************************
		 *  HUD API
		 **********************************************************************************/

		public function hasSelected():Boolean {
			return currentImage != null;
		}

		// return cost of currently selected item
		public function getCost():int {
			if (isEntityDisplay) {
				var catIndex:int = entityDisplayList[currentEntityIndex];
				var entityKey:String = entityList[currentEntityIndex][catIndex];
				return entityMap[entityKey][1];
			} else  {
				return getTileCost();
			}
		}
		
		public function deselect():void {
			dispatchEvent(new GameEvent(GameEvent.BUILD_HUD_IMAGE_CHANGE, 0, 0));
			
            currentImage = null;
            currentEntityIndex = -1;
            isEntityDisplay = true;
            updateSelectButtons();
        }

		/**********************************************************************************
		 *  Tile Block API
		 **********************************************************************************/

		public function selectTile(toggle:Boolean = false):void {
			dispatchEvent(new GameEvent(GameEvent.BUILD_HUD_IMAGE_CHANGE, 0, 0));

			if(isEntityDisplay || toggle) {
				var tileTexture:Texture = textures[Util.getTextureString(directions[Util.NORTH], directions[Util.SOUTH], directions[Util.EAST], directions[Util.WEST])];
				currentTile = new Image(tileTexture);
				currentImage = new Image(tileTexture);
				currentImage.touchable = false;
				isEntityDisplay = false;
				currentEntityIndex = -1;
			} else {
				currentTile = null;
				currentImage = null;
				isEntityDisplay = true;
			}

			updateSelectButtons();
			closePopup();
		}

		public function toggleDirection(direction:int):void {
			directions[direction] = !directions[direction];
			toggleButtons[direction].color = directions[direction] ? COLOR_TRUE : COLOR_FALSE;
			selectTile(true);
		}

		public function toggleNorth():void {
			toggleDirection(Util.NORTH);
		}

		public function toggleSouth():void {
			toggleDirection(Util.SOUTH);
		}

		public function toggleEast():void {
			toggleDirection(Util.EAST);
		}

		public function toggleWest():void {
			toggleDirection(Util.WEST);
		}

		// return cost of current generated tile
		public function getTileCost():int {
			var sum:int = (directions[Util.NORTH] ? 1 : 0) + (directions[Util.SOUTH] ? 1 : 0) +
						  (directions[Util.EAST] ? 1 : 0) + (directions[Util.WEST] ? 1 : 0);
			return Util.BASE_TILE_COST * sum;
		}

		/**********************************************************************************
		 *  Entity Block API
		 **********************************************************************************/

		public function selectEntity(index:int):void {
			// Update entity block
			var catIndex:int = entityDisplayList[index]
			var entityKey:String = entityList[index][catIndex];
			currentEntityIndex = index;
		}

		public function selectEntityClickable(values:Dictionary):void {
			dispatchEvent(new GameEvent(GameEvent.BUILD_HUD_IMAGE_CHANGE, 0, 0));

			if(currentEntityIndex == values["index"]) {
				// Toggle off
				currentEntity = null
				currentImage = null;
				currentEntityIndex = -1;
			} else {
				selectEntity(values["index"]);
				currentEntity = new Image(entityClickables[currentEntityIndex].textureImage.texture);
				currentImage = new Image(currentEntity.texture);
				currentImage.touchable = false;
				isEntityDisplay = true;
			}

			closePopup();
			updateUI();
			updateSelectButtons();
		}

		public function pageEntity(index:int, change:int):void {
			if(entityDisplayList.length <= index || entityList[index].length <= change) {
				return;
			}

			entityDisplayList[index] = change;
		}

		public function pageEntityClickable(values:Dictionary):void {
			dispatchEvent(new GameEvent(GameEvent.BUILD_HUD_IMAGE_CHANGE, 0, 0));

			pageEntity(values["index"], values["change"]);
			closePopup();
			updateUI();
			currentEntityIndex = values["index"];
			currentEntity = new Image(entityClickables[currentEntityIndex].textureImage.texture);
			currentImage = new Image(currentEntity.texture);
			currentImage.touchable = false;
			isEntityDisplay = true;
			updateSelectButtons();
		}

		// Realigns the selected tile from the tile HUD on the Floor.
		/*public function positionTileOnGrid(worldX:int, worldY:int):void {
			if (selected is Tile) {
				selected.x = Util.grid_to_real(Util.real_to_grid(selected.x - worldX + Util.PIXELS_PER_TILE / 2));
				selected.y = Util.grid_to_real(Util.real_to_grid(y - worldY + Util.PIXELS_PER_TILE / 2));
				(selected as Tile).grid_x = Util.real_to_grid(selected.x + Util.PIXELS_PER_TILE / 2);
				(selected as Tile).grid_y = Util.real_to_grid(selected.y + Util.PIXELS_PER_TILE / 2);
			}
		}*/

		/*
		public function setEntityPosition(index:int):void {
			availableEntities[index].x = HUD.x + Util.HUD_OFFSET_TILES + Util.HUD_PAD_LEFT +
				(Util.HUD_PIXELS_PER_TILE + Util.HUD_PAD_LEFT) * (index % Util.HUD_TAB_SIZE);
			availableEntities[index].y = HUD.y + Util.HUD_PAD_TOP;
		}*/
	}
}
