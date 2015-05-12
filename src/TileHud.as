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
		public var HUD:Image;

		// Used to represent percent chance of drawing tiles.
		private var tileRates:Array;

		// List of available tiles displayed on HUD
		private var availableTiles:Array;

		public function TileHud(tileRatesBytes:ByteArray,
								textureDict:Dictionary) {
			super();
			textures = textureDict;
			tileRates = new Array(100);
			availableTiles = new Array(Util.NUM_AVAILABLE_TILES);

			HUD = new Image(textures[Util.TILE_HUD]);
			HUD.x = (Util.STAGE_WIDTH - HUD.width) / 2;
			HUD.y = 0;
			addChild(HUD);

			parseTileRates(tileRatesBytes);
			for (var i:int = 0; i < Util.NUM_AVAILABLE_TILES; i++) {
				getNextTile(i);
			}
		}

		public function getTileByIndex(index:int):Tile {
			return availableTiles[index];
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

		public function setTileLocation(index:int):void {
			availableTiles[index].x = HUD.x + Util.HUD_PAD_LEFT +
				(Util.PIXELS_PER_TILE + Util.HUD_PAD_LEFT) * index;
			availableTiles[index].y = HUD.y + Util.HUD_PAD_TOP;
		}

		public function getNextTile(index:int):void {
			var tile:Tile; var tN:Boolean; var tS:Boolean; var tE:Boolean;
			var tW:Boolean; var dir:int; var tTexture:Texture; var tType:String;
			var t2Texture:Texture; var name:String; var level:int; var hp:int;
			var attack:int; var xpReward:int;

			// Create tile randomly influenced by tile rates for floor
			tType = tileRates[Util.randomRange(0, 100)];
			
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
				t2Texture = textures[Util.MONSTER_1];
				name = "";
				level = 1;
				hp = 1;
				attack = 1;
				xpReward = 1;
				tile = new EnemyTile(0, 0, tN, tS, tE, tW, tTexture,
					t2Texture, name, level, hp, attack, xpReward);
			} else if (tType == "healing") {
				t2Texture = textures[Util.HEALING],
				hp = 1
				tile = new HealingTile(0, 0, tN, tS, tE, tW, tTexture,
					t2Texture, hp);
			} else { // empty
				tile =  new Tile(0, 0, tN, tS, tE, tW, tTexture);
			}
			tile.locked = false;
			availableTiles[index] = tile;
			setTileLocation(index);
			addChild(tile);
		}

		private function parseTileRates(tileRatesBytes:ByteArray):void {
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
		}
	}
}
