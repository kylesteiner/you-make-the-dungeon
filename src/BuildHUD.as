package {
	import starling.display.*;
	import flash.utils.Dictionary;
	import starling.textures.*;
	import starling.events.*;
	import starling.text.TextField;
	import starling.utils.Color;

	import tiles.*;
	import entities.*;

	public class BuildHUD extends Sprite {
		public static const QUAD_BORDER_PIXELS:int = 2;
		public static const HUD_MARGIN:int = 8;
		public static const TOP:int = HUD_MARGIN;
		public static const LEFT:int = HUD_MARGIN;
		public static const COLOR_TRUE:uint = 0x00ff00;
		public static const COLOR_FALSE:uint = 0xff0000;
		public static const COLOR_SELECTED:uint = 0x00ff00;
		public static const COLOR_DESELECTED:uint = 0x666666;
		public static const COLOR_DESELECTED_ENTITY:uint = Color.WHITE;
		public static const ENTITIES_PER_LINE:int = 4;
		public static const SELECT_BUTTON_WIDTH:int = 48;
		public static const SELECT_BUTTON_HEIGHT:int = 16;
		public static const SELECT_BUTTON_MARGIN:int = 12;
		public static const DELETE_BUTTON_SIZE:int = 52;

		public static const STATE_TILE:String = "state_tile";
		public static const STATE_ENTITY:String = "state_entity";
		public static const STATE_DELETE:String = "state_delete";
		public static const STATE_NONE:String = "state_none";

		private var textures:Dictionary;

		/***** Overall HUD *****/
		// sprites that contain the tile and entity selection
		// will be used when we have real textures
		private var tileBlock:Sprite;
		private var entityBlock:Sprite;
		// image to display beneath mouse cursor
		public var currentImage:Image;
		// true if entity should be shown, false if tile is shown
		//public var isEntityDisplay:Boolean;
		public var hudState:String;
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
		private var toggleClickables:Array;
		private var nButton:Quad;
		private var sButton:Quad;
		private var wButton:Quad;
		private var eButton:Quad;
		private var tileSelectButton:Clickable;
		private var tileGoldCost:Sprite;

		private var entityQuad:Quad; // Rect drawn for background of entity select
		private var popup:Sprite;
		private var entityClickables:Array;
		private var entityHighlights:Array;
		private var entityColoredRegions:Array;
		private var entitySelectButtons:Array;
		private var entityGoldCosts:Array;

		private var deleteQuad:Quad;
		private var deleteButton:Clickable;

		private var entityFactory:EntityFactory;

		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/

		public function BuildHUD(textureDict:Dictionary) {
			super();
			this.entityFactory = new EntityFactory(textureDict);
			this.textures = textureDict;

			tileBlock = new Sprite();
			entityBlock = new Sprite();
			addChild(tileBlock);
			addChild(entityBlock);
			currentImage = null;

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

			hudState = STATE_NONE;

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

			/*toggleButtons = new Array();
			nButton = new Quad(Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - 2*tileNWCorner.height, tileCornerSize, COLOR_FALSE);
			sButton = new Quad(Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - 2*tileNWCorner.height, tileCornerSize, COLOR_FALSE);
			eButton = new Quad(tileCornerSize, Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - 2*tileNWCorner.width, COLOR_FALSE);
			wButton = new Quad(tileCornerSize, Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - 2*tileNWCorner.width, COLOR_FALSE);
			toggleButtons.push(nButton);
			toggleButtons.push(sButton);
			toggleButtons.push(eButton);
			toggleButtons.push(wButton);*/
			/*northToggle = new Clickable(tileNWCorner.x + tileNWCorner.width, tileNWCorner.y, toggleNorth, nButton);
			southToggle = new Clickable(tileSWCorner.x + tileSWCorner.width, tileSWCorner.y, toggleSouth, sButton);
			eastToggle = new Clickable(tileNECorner.x, tileNECorner.y + tileNWCorner.height, toggleEast, eButton);
			westToggle = new Clickable(tileNWCorner.x, tileNWCorner.y + tileNWCorner.height, toggleWest, wButton);*/
			toggleClickables = new Array();
			var sample:Image = new Image(textures[Util.TILE_UP_ACTIVE]);
			//northToggle = new Clickable(tileNWCorner.x + tileNWCorner.width, tileNWCorner.y, toggleNorth, null, textures[Util.TILE_UP_INACTIVE]);
			northToggle = new Clickable(interiorTQ.x + (interiorTQ.width - sample.width) / 2, tileNWCorner.y - 8, toggleNorth, null, textures[Util.TILE_UP_INACTIVE]);
			southToggle = new Clickable(interiorTQ.x + (interiorTQ.width - sample.width) / 2, tileSWCorner.y, toggleSouth, null, textures[Util.TILE_DOWN_INACTIVE]);
			eastToggle = new Clickable(tileNECorner.x, interiorTQ.y + (Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - sample.height) / 2, toggleEast, null, textures[Util.TILE_RIGHT_INACTIVE]);
			westToggle = new Clickable(tileNWCorner.x - 8, interiorTQ.y + (Util.PIXELS_PER_TILE - 2*QUAD_BORDER_PIXELS - sample.height) / 2, toggleWest, null, textures[Util.TILE_LEFT_INACTIVE]);
			toggleClickables.push(northToggle);
			toggleClickables.push(southToggle);
			toggleClickables.push(eastToggle);
			toggleClickables.push(westToggle);

			tileGoldCost = createTileGoldCost();

			entityQuad = new Quad(Util.PIXELS_PER_TILE * (entityList.length > 0 ? entityList.length : 1),
								  Util.PIXELS_PER_TILE + SELECT_BUTTON_MARGIN + SELECT_BUTTON_HEIGHT, 0x000000);
			entityQuad.x = tileQuad.x + tileQuad.width + HUD_MARGIN;
			entityQuad.y = tileQuad.y;
			var interiorEQ:Quad = new Quad(entityQuad.width - 2*QUAD_BORDER_PIXELS,
										   entityQuad.height - 2*QUAD_BORDER_PIXELS);
			interiorEQ.x = entityQuad.x + QUAD_BORDER_PIXELS;
			interiorEQ.y = entityQuad.y + QUAD_BORDER_PIXELS;

			var menuButtons:Array = new Array(Util.ENEMY_MENU, Util.HEALING_MENU, Util.TRAP_MENU);

			entityClickables = new Array();
			entitySelectButtons = new Array();
			entityGoldCosts = new Array();
			entityHighlights = new Array();
			entityColoredRegions = new Array();
			var i:int; var entityX:int; var entityY:int;
			var entitySprite:Sprite;
			var entityPopupButton:Clickable;

			var entityName:String;
			var entityConstructor:Function;
			var entityTexture:Texture;
			var entityCost:int;
			var entityCategory:int;

			var selectEntityButton:Clickable;
			var selectEntityTexture:Texture;
			var entityImage:Image;

			for(i = 0; i < entityList.length; i++) {
				entityName = entityList[i][entityDisplayList[i]];
				entityConstructor = entityMap[entityList[i][entityDisplayList[i]]][0];
				entityTexture = entityMap[entityList[i][entityDisplayList[i]]][1];
				entityCost = entityMap[entityList[i][entityDisplayList[i]]][2];
				entityCategory = entityMap[entityList[i][entityDisplayList[i]]][3];

				entityX = QUAD_BORDER_PIXELS + Util.PIXELS_PER_TILE * i + entityQuad.x;
				entityY = QUAD_BORDER_PIXELS * 2;
				entitySprite = entityConstructor().generateOverlay();
				entityPopupButton = new Clickable(entityX, entityY, selectEntityClickable, entitySprite, entityTexture);
				entityPopupButton.addParameter("index", i);
				entityClickables.push(entityPopupButton);

				var eQ:Quad = new Quad(entityPopupButton.width - 3 * HUD_MARGIN,
									   entityPopupButton.height - 3 * HUD_MARGIN,
									   Color.WHITE);
				eQ.x = entityX + (1.5) * HUD_MARGIN;
				eQ.y = entityY + 2 * HUD_MARGIN;
				entityColoredRegions.push(eQ);

				var oQ:Quad = new Quad(eQ.width + 2, eQ.height + 2, Color.BLACK);
				oQ.x = eQ.x - 1;
				oQ.y = eQ.y - 1;
				entityHighlights.push(oQ);

				selectEntityTexture = textures[menuButtons[entityCategory]];
				entityImage = new Image(selectEntityTexture);
				selectEntityButton = new Clickable(entityX + (entityPopupButton.width - entityImage.width) / 2,
				 								   entityY + entityPopupButton.height + SELECT_BUTTON_MARGIN - 2,
													createPopupClickable, entityImage);
				selectEntityButton.addParameter("index", i);
				entitySelectButtons.push(selectEntityButton);

				//var entityGoldCost:Sprite = createGoldCost(entityMap[entityList[i][entityDisplayList[i]]][2]);
				var entityGoldCost:Sprite = createGoldCost(entityCost);
				entityGoldCost.x = entityPopupButton.x + entityPopupButton.width - (3*entityGoldCost.width / 4);
				entityGoldCost.y = -4;
				entityGoldCosts.push(entityGoldCost);
			}

			deleteQuad = new Quad(DELETE_BUTTON_SIZE, DELETE_BUTTON_SIZE, 0x000000);
			deleteQuad.x = entityQuad.x + entityQuad.width + HUD_MARGIN;
			deleteQuad.y = TOP;
			var interiorDQ:Quad = new Quad(deleteQuad.width - 2*QUAD_BORDER_PIXELS,
										   deleteQuad.height - 2*QUAD_BORDER_PIXELS);
			interiorDQ.x = deleteQuad.x + QUAD_BORDER_PIXELS;
			interiorDQ.y = deleteQuad.y + QUAD_BORDER_PIXELS;
			deleteButton = new Clickable(deleteQuad.x + QUAD_BORDER_PIXELS,
										 deleteQuad.y + QUAD_BORDER_PIXELS,
										 deleteClickable, null, textures[Util.ICON_DELETE]);

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

			addChild(tileGoldCost);

			addChild(entityQuad);
			addChild(interiorEQ);

			for(i = 0; i < entityClickables.length; i++) {
				addChild(entityHighlights[i]);
				addChild(entityColoredRegions[i]);
				addChild(entityClickables[i]);
				addChild(entitySelectButtons[i]);
				addChild(entityGoldCosts[i]);
			}

			addChild(deleteQuad);
			addChild(interiorDQ);
			addChild(deleteButton);
		}

		public function updateUI():void {
			for(var i:int = 0; i < entityClickables.length; i++) {
				var selectEB:Clickable = entityClickables[i];
				var selectOverlay:Sprite = entityMap[entityList[i][entityDisplayList[i]]][0]().generateOverlay();
				selectEB.updateImage(selectOverlay, entityMap[entityList[i][entityDisplayList[i]]][1]);
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

				var entitySprite:Sprite = entityMap[key][0]().generateOverlay();
				var entityTexture:Texture = entityMap[key][1];
				var renderEntity:Clickable = new Clickable(entityX, entityY, pageEntityClickable, entitySprite, entityTexture);

				renderEntity.addParameter("index", index);
				renderEntity.addParameter("change", i);
				popupEntities.push(renderEntity);

				var coinCost:Sprite = createGoldCost(entityMap[key][2]);
				coinCost.x = entitySprite.x + entitySprite.width + (coinCost.width / 4);
				//coinCost.y = -coinCost.height / 4;
				entitySprite.addChild(coinCost);
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
			var replacementQuad:Quad = new Quad(tileSelectButton.baseImage.width,
												tileSelectButton.baseImage.height,
												hudState == STATE_TILE ? COLOR_SELECTED : COLOR_DESELECTED);
			tileSelectButton.updateImage(replacementQuad);

			var i:int;
			for(i = 0; i < entityColoredRegions.length; i++) {
				entityColoredRegions[i].color = Color.WHITE;
			}

			if(hudState == STATE_ENTITY) {
				entityColoredRegions[currentEntityIndex].color = COLOR_SELECTED;
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
			if (hudState == STATE_ENTITY) {
				var catIndex:int = entityDisplayList[currentEntityIndex];
				var entityKey:String = entityList[currentEntityIndex][catIndex];
				return entityMap[entityKey][2];
			} else if(hudState == STATE_TILE) {
				return getTileCost();
			} else {
				// What do we do here?
				return 0;
			}
		}

		public function deselect():void {
            currentImage = null;
            currentEntityIndex = -1;
			hudState = STATE_NONE;
            updateSelectButtons();
			dispatchEvent(new GameEvent(GameEvent.BUILD_HUD_IMAGE_CHANGE, 0, 0));
        }

		public function buildTileFromImage(worldX:int, worldY:int):Tile {
			var newTile:Tile = new Tile(0, 0, directions[Util.NORTH], directions[Util.SOUTH],
											  directions[Util.EAST], directions[Util.WEST],
											  currentImage.texture);
			// Realigns the new tile on the Floor.
			newTile.x = Util.grid_to_real(Util.real_to_grid(currentImage.x - worldX + Util.PIXELS_PER_TILE / 2));
			newTile.y = Util.grid_to_real(Util.real_to_grid(currentImage.y - worldY + Util.PIXELS_PER_TILE / 2));
			newTile.grid_x = Util.real_to_grid(newTile.x + Util.PIXELS_PER_TILE / 2);
			newTile.grid_y = Util.real_to_grid(newTile.y + Util.PIXELS_PER_TILE / 2);
			newTile.cost = getCost();
			newTile.deletable = true;
			return newTile;
		}

		public function buildEntityFromImage(currentTile:Tile):Entity {
			var catIndex:int = entityDisplayList[currentEntityIndex];
			var entityKey:String = entityList[currentEntityIndex][catIndex];
			var entity:Entity = entityMap[entityKey][0](currentTile.grid_x, currentTile.grid_y);
			entity.cost = getCost();
			entity.deletable = true;
			return entity;
		}

		public function deleteClickable():void {
			deselect();
			hudState = STATE_DELETE;
			currentImage = new Image(textures[Util.ICON_DELETE]);
			currentImage.touchable = false;
			closePopup();
			dispatchEvent(new GameEvent(GameEvent.BUILD_HUD_IMAGE_CHANGE, 0, 0));
		}

		public function getRefundForDelete(tile:Tile, entity:Entity):int {
			if (entity) {
				return entity.cost * Util.REFUND_PERCENT / 100
			} else if (tile) {
				return tile.cost * Util.REFUND_PERCENT / 100;
			} else {
				return 0;
			}
		}

		/**********************************************************************************
		 *  Tile Block API
		 **********************************************************************************/

		public function selectTile(toggle:Boolean = false):void {
			dispatchEvent(new GameEvent(GameEvent.BUILD_HUD_IMAGE_CHANGE, 0, 0));

			if(hudState != STATE_TILE || toggle) {
				var tileTexture:Texture = textures[Util.getTextureString(directions[Util.NORTH], directions[Util.SOUTH], directions[Util.EAST], directions[Util.WEST])];
				currentTile = new Image(tileTexture);
				currentImage = new Image(tileTexture);
				currentImage.touchable = false;
				hudState = STATE_TILE;
				currentEntityIndex = -1;
			} else {
				currentTile = null;
				currentImage = null;
				hudState = STATE_NONE; // might need to be STATE_ENTITY?
			}

			updateSelectButtons();
			closePopup();
		}

		public function toggleDirection(direction:int):void {
			directions[direction] = !directions[direction];
			//var imageString:String = directions[direction] ? Util.TILE_HUD_ACTIVE : Util.TILE_HUD_INACTIVE;
			//toggleClickables[direction].updateImage(new Image(textures[imageString]));
			//toggleButtons[direction].color = directions[direction] ? COLOR_TRUE : COLOR_FALSE;
			//toggleButtons[direction].
			selectTile(true);

			removeChild(tileGoldCost);
			tileGoldCost = createTileGoldCost();
			addChild(tileGoldCost);
		}

		public function toggleNorth():void {
			toggleDirection(Util.NORTH);
			var imageString:String = directions[Util.NORTH] ? Util.TILE_UP_ACTIVE : Util.TILE_UP_INACTIVE;
			toggleClickables[Util.NORTH].updateImage(new Image(textures[imageString]));
			//var imageString
			//northToggle.updateImage(new Image())
		}

		public function toggleSouth():void {
			toggleDirection(Util.SOUTH);
			var imageString:String = directions[Util.SOUTH] ? Util.TILE_DOWN_ACTIVE : Util.TILE_DOWN_INACTIVE;
			toggleClickables[Util.SOUTH].updateImage(new Image(textures[imageString]));
		}

		public function toggleEast():void {
			toggleDirection(Util.EAST);
			var imageString:String = directions[Util.EAST] ? Util.TILE_RIGHT_ACTIVE : Util.TILE_RIGHT_INACTIVE;
			toggleClickables[Util.EAST].updateImage(new Image(textures[imageString]));
		}

		public function toggleWest():void {
			toggleDirection(Util.WEST);
			var imageString:String = directions[Util.WEST] ? Util.TILE_LEFT_ACTIVE : Util.TILE_LEFT_INACTIVE;
			toggleClickables[Util.WEST].updateImage(new Image(textures[imageString]));
		}

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
				hudState = STATE_NONE;
			} else {
				selectEntity(values["index"]);
				currentEntity = new Image(entityClickables[currentEntityIndex].textureImage.texture);
				currentImage = new Image(currentEntity.texture);
				currentImage.touchable = false;
				hudState = STATE_ENTITY;
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
			hudState = STATE_ENTITY;
			updateSelectButtons();
			updateEntityGoldCosts();
		}

		public function createGoldCost(cost:int):Sprite {
			var base:Sprite = new Sprite();

			var goldImage:Image = new Image(textures[Util.ICON_GOLD]);
			var costText:TextField = new TextField(goldImage.width, goldImage.height, cost.toString(), Util.DEFAULT_FONT, Util.MEDIUM_FONT_SIZE);
			costText.autoScale = true;

			base.addChild(goldImage);
			base.addChild(costText);

			base.touchable = false;

			return base;
		}

		public function createTileGoldCost():Sprite {
			var base:Sprite = createGoldCost(getTileCost());
			base.x = tileQuad.x + tileQuad.width - (base.width / 2);
			base.y = -4;
			return base;
		}

		public function updateEntityGoldCosts():void {
			var i:int;
			var newCost:Sprite;
			for(i = 0; i < entityGoldCosts.length; i++) {
				removeChild(entityGoldCosts[i]);
				newCost = createGoldCost(entityMap[entityList[i][entityDisplayList[i]]][2]);
				newCost.x = entityGoldCosts[i].x;
				newCost.y = entityGoldCosts[i].y;
				entityGoldCosts[i] = newCost;
				addChild(entityGoldCosts[i]);
			}
		}
	}
}
