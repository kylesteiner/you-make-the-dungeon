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
		
		// Used to represent percent chance of drawing tiles.
		private var tileRates:Array;
		
		// List of available tiles displayed on HUD
		private var availableTiles:Array;	
		
		// TODO: Comment
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
				availableTiles[i] = getNextTile(i);
			}
		}
		
		public function getTileByIndex(index:int):Tile {
			return availableTiles[index];
		}
		
		// TODO: Comment
		public function indexOfTileInUse():int {
			for (var i:int; i < availableTiles.length; i++) {
				var tile:Tile = availableTiles[i];
				if (tile.held) {
					return availableTiles.indexOf(tile);
				}
			}
			return -1;
		}
		
		public function returnTileInUse():void {
			var index:int = indexOfTileInUse()
			var tileInUse:Tile = availableTiles[index];
			tileInUse.held = false;
			tileInUse.x = HUD.x + Util.HUD_PAD_LEFT +
				(Util.PIXELS_PER_TILE + Util.HUD_PAD_LEFT) * index;
			tileInUse.y = HUD.y + Util.HUD_PAD_TOP;
		}
		
		// TODO: Comment
		public function removeAndReplaceTile(index:int):void {
			removeChild(availableTiles[index]);
			availableTiles[index] = getNextTile(index)
		}
		
		// TODO: Comment
		public function resetTileHud(): void {
			for (var i:int = 0; i < availableTiles.length; i++) {
				removeAndReplaceTile(i);
			}
		}
		
		// TODO: Comment
		public function getNextTile(index:int):Tile {
			var tile:Tile; var tN:Boolean; var tS:Boolean; var tE:Boolean;
			var tW:Boolean; var dir:int; var tTexture:Texture; var tType:String;
			var t2Texture:Texture; var name:String; var level:int; var hp:int;
			var attack:int; var xpReward:int;
			
			// 66% chance of having each direction open
			tN = (Util.randomRange(0, 2) == 0) ? false : true;
			tS = (Util.randomRange(0, 2) == 0) ? false : true;
			tE = (Util.randomRange(0, 2) == 0) ? false : true;
			tW = (Util.randomRange(0, 2) == 0) ? false : true;
			if (!tN && !tS && !tE && !tW) {
				dir = Util.randomRange(0, 3)
				tN = (dir == Util.NORTH) ? true : false;
				tS = (dir == Util.SOUTH) ? true : false;
				tE = (dir == Util.EAST) ? true : false;
				tW = (dir == Util.WEST) ? true : false;
			}
			
			// Create tile randomly influenced by tile rates for floor
			tTexture = textures[Util.getTextureString(tN, tS, tE, tW)];
			tType = tileRates[Util.randomRange(0, 100)];
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
			tile.x = HUD.x + Util.HUD_PAD_LEFT +
				(Util.PIXELS_PER_TILE + Util.HUD_PAD_LEFT) * index;
			tile.y = HUD.y + Util.HUD_PAD_TOP;
			tile.locked = false;
			addChild(tile);
			return tile;
		}
		
		// TODO: Comment
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