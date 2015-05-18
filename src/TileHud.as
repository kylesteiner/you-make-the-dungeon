package {
	import starling.core.Starling;
	import starling.display.*;
	import flash.net.*;
	import flash.utils.*;
	import starling.events.*;
	import starling.textures.*;

	import tiles.*;
	import Util;

	public class TileHud extends Sprite {
		private var textures:Dictionary;
		private var HUD:Image;

		public var tiles:Array;
		public var tab:int;
		public var highlightedLocations:Array;

		/**********************************************************************************
		 *  Intialization
		 **********************************************************************************/
		
		public function TileHud(textureDict:Dictionary) {
			super();
			textures = textureDict;
			generateHudTiles();
			
			highlightedLocations = new Array(Util.HUD_TAB_SIZE);
			
			HUD = new Image(textures[Util.TILE_HUD]);
			HUD.x = Util.HUD_OFFSET;
			HUD.y = 0;
			addChild(HUD);

			tab = 0;
			loadTab(tab);
		}
		
		public function generateHudTiles():void {
			tiles = new Array();
			tiles.push(new Tile(0, 0, true, false, false, false, textures[Util.getTextureString(true, false, false, false)]));
			tiles.push(new Tile(0, 0, true, true, false, false, textures[Util.getTextureString(true, true, false, false)]));
			tiles.push(new Tile(0, 0, true, false, false, true, textures[Util.getTextureString(true, false, false, true)]));
			tiles.push(new Tile(0, 0, true, false, true, true, textures[Util.getTextureString(true, false, true, true)]));
			tiles.push(new Tile(0, 0, true, true, true, true, textures[Util.getTextureString(true, true, false, true)]));
			for (var i:int = 0; i < tiles.length; i++) {
				tiles[i].width = Util.HUD_PIXELS_PER_TILE;
				tiles[i].height = Util.HUD_PIXELS_PER_TILE;
				setTilePosition(i % Util.HUD_TAB_SIZE);
			}
		}
		
		/**********************************************************************************
		 *  Utility functions
		 **********************************************************************************/
		
		public function loadTab(newTab:int):void {
			var i:int;
			
			if (newTab < 0 || newTab > (tiles.length - 1) / Util.HUD_TAB_SIZE) {
				return;
			}
			
			for (i = 0; i < Util.HUD_TAB_SIZE; i++) {
				removeChild(tiles[tab * Util.HUD_TAB_SIZE]);
			}
			
			tab = newTab;
			
			for (i = 0; i < Util.HUD_TAB_SIZE; i++) {
				addChild(tiles[tab * Util.HUD_TAB_SIZE]);
			}
		}

		public function setTilePosition(index:int):void {
			tiles[tab * index].x = HUD.x + Util.HUD_OFFSET_TILES + Util.HUD_PAD_LEFT +
				(Util.HUD_PIXELS_PER_TILE + Util.HUD_PAD_LEFT) * index;
			tiles[tab * index].y = HUD.y + Util.HUD_PAD_TOP;
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

		public function returnSelectedTile():void {
			var index:int = indexOfSelectedTile()
			if (index != -1) {
				availableTiles[index].selected = false;
				availableTiles[index].width = Util.HUD_PIXELS_PER_TILE;
				availableTiles[index].height = Util.HUD_PIXELS_PER_TILE;
				setTileLocation(index);
			}
		}

		public function resetTileHud(): void {
			for (var i:int = 0; i < availableTiles.length; i++) {
				removeAndReplaceTile(i);
			}
		}

		public function removeAndReplaceTile(index:int):void {
			removeChild(availableTiles[index]);
			getNextTile(index)
		}

		/*
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
