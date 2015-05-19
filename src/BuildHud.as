package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;

	import tiles.*;
	import Util;

	public class BuildHud extends Sprite {
		private var textures:Dictionary;
		private var highlightedLocations:Array;
		
		/***** Overall HUD *****/
		// sprites that contain the tile and entity selection
		private var tileBlock:Sprite;
		private var entityBlock:Sprite;
		// image to display beneath mouse cursor
		private var currentImage:Image;
		// true if entity should be shown, false if tile is shown
		private var isEntityDisplay:Boolean;
		// maps strings to arrays
		// array[0] is the constructor for the entity
		// array[1] is the image
		// array[2] is the cost
		private var entityMap:Dictionary;
		
		/***** Tile Block *****/
		// an array of Booleans, which indicate whether each direction is open or not
		private var directions:Array;
		// base tile image
		private var baseImage:Image;
		// toggle the corresponding field and change their image
		private var northClickable:Clickable;
		private var southClickable:Clickable;
		private var eastClickable:Clickable;
		private var westClickable:Clickable;
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


		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/
		
		public function BuildHud(textureDict:Dictionary, entityMap:Dictionary) {
			super();
			textures = textureDict;
			highlightedLocations = new Array();
			
			currentImage = null;
			isEntityDisplay = true;
			this.entityMap = entityMap;
			
			directions = new Array(4);
			baseImage = null;
			northClickable = null;
			southClickable = null;
			eastClickable = null;
			currentTile = null;
			
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
		}
		
		/**********************************************************************************
		 *  HUD API
		 **********************************************************************************/
		
		// return cost of currently selected item
		public function getCost():int {
			return 0;
		}
		
		public function reset():void {
			
		}
		
		/**********************************************************************************
		 *  Tile Block API
		 **********************************************************************************/
		
		public function toggleNorth():void {
			directions[Util.NORTH] = (directions[Util.NORTH] = true) ? false : true;
		}
		
		public function toggleSouth():void {
			directions[Util.SOUTH] = (directions[Util.SOUTH] = true) ? false : true;
		}
		
		public function toggleEast():void {
			directions[Util.EAST] = (directions[Util.EAST] = true) ? false : true;
		}
		
		public function toggleWest():void {
			directions[Util.WEST] = (directions[Util.WEST] = true) ? false : true;
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
			
		}
		
		public function pageEntity(index:int, change:int):void {
			
		}
		
		/**********************************************************************************
		 *  Utility functions
		 **********************************************************************************/
		
		

		/**********************************************************************************
		 *  Events
		 **********************************************************************************/
		
		private function onMouseEvent(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);

			if (!touch) {
				return
			}
			
			
		}
		
		/*
		public function setEntityPosition(index:int):void {
			availableEntities[index].x = HUD.x + Util.HUD_OFFSET_TILES + Util.HUD_PAD_LEFT +
				(Util.HUD_PIXELS_PER_TILE + Util.HUD_PAD_LEFT) * (index % Util.HUD_TAB_SIZE);
			availableEntities[index].y = HUD.y + Util.HUD_PAD_TOP;
		}
		public function removeAndReplaceTile(index:int):void {
			removeChild(availableTiles[index]);
			//getNextTile(index)
		}
		public function getTileByIndex(index:int):Tile {
			return availableTiles[index];
		}

		public function indexOfSelectedTile():int {
			for (var i:int; i < availableTiles.length; i++) {
				var tile:Tile = availableTiles[i];
				if (tile.selected) {
					return availableTiles.indexOf(tile);
				}
			}
			return -1;
		}
		
		public function lockTiles():void {
			for (var i:int; i < availableTiles.length; i++) {
				availableTiles[i].locked = true;
			}
		}

		public function unlockTiles():void {
			for (var i:int; i < availableTiles.length; i++) {
				availableTiles[i].locked = false;
			}
		}
		 
		public function getNextTile(index:int):void {
			var tile:Tile; var tN:Boolean; var tS:Boolean; var tE:Boolean;
			var tW:Boolean; var dir:int; var tTexture:Texture; var tType:String;
			var t2Texture:Texture; var enemyName:String; var level:int; var hp:int;
			var attack:int; var xpReward:int;

			// Create tile randomly influenced by tile rates for floor
			tType = tileRates[Util.randomRange(0, 99)];

			// Generate walls. 75% chance of having each direction open.
			var numSides:int = 0;
			while ((tType == "empty" && numSides < 2) || (tType != "empty" && numSides == 0)) {
				numSides = 0;
				tN = (Util.randomRange(0, 3) == 0) ? false : true;
				tS = (Util.randomRange(0, 3) == 0) ? false : true;
				tE = (Util.randomRange(0, 3) == 0) ? false : true;
				tW = (Util.randomRange(0, 3) == 0) ? false : true;
				numSides += tN ? 1 : 0;
				numSides += tS ? 1 : 0;
				numSides += tE ? 1 : 0;
				numSides += tW ? 1 : 0;
			}
			tTexture = textures[Util.getTextureString(tN, tS, tE, tW)];

			// Generate tile and add it to the HUD display
			if (tType == "enemy") {
				t2Texture = Util.randomRange(1, 2) == 1 ? textures[Util.MONSTER_1] : textures[Util.MONSTER_2];
				enemyName = "";
				level = Util.randomRange(1, 4);
				hp = level * Util.randomRange(2, 3);
				attack = level;
				xpReward = Util.randomRange(1, level);
				tile = new EnemyTile(0, 0, tN, tS, tE, tW, tTexture,
					t2Texture, enemyName, level, hp, attack, xpReward);
				eTile.locked = false;
				availableTiles[index] = eTile;
				setTileLocation(index);
				addChild(eTile);
				return;
			} else if (tType == "healing") {
				t2Texture = textures[Util.HEALING];
				hp = Util.randomRange(1, 10);
				tile = new HealingTile(0, 0, tN, tS, tE, tW, tTexture,
					t2Texture, hp);
			} else { // empty
				tile =  new Tile(0, 0, tN, tS, tE, tW, tTexture);
			}
			
			tile.locked = false;
			tile.width = Util.HUD_PIXELS_PER_TILE;
			tile.height = Util.HUD_PIXELS_PER_TILE;
			availableTiles[index] = tile;
			setTileLocation(index);
			addChild(tile);
		}*/

		/*private function parseTileRates(tileRatesBytes:ByteArray):void {
			var i:int; var j:int; var end:int; var pos:int;
			var lineData:Array; var tType:String; var tPercent:int;

			var tileRatesString:String =
				tileRatesBytes.readUTFBytes(tileRatesBytes.length);

			// Fill the tile rates array usng the given tile type and draw rate
			var tileRatesArray:Array = tileRatesString.split("\n");
			pos = 0;
			for (i = 0; i < tileRatesArray.length; i++) {
				if (tileRatesArray[i].length == 0) {
					continue;
				}
				lineData = tileRatesArray[i].split("\t");
				tType = lineData[0];
				tPercent = lineData[1];
				end = Math.min(pos + tPercent, tileRates.length)
				for (j = pos; j < end; j++) {
					tileRates[j] = tType
					pos++;
				}
			}
		}*/
	}
}
