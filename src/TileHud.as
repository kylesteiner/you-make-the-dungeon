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
		
		// Used to represent percent chance of drawing tiles.
		private var tileRates:Array;
		
		// List of available tiles displayed on HUD
		private var availableTiles:Array;
		
		// TODO: Comment
		public function TileHud(floorTiles:ByteArray,
								textureDict:Dictionary) {
			super();
			textures = textureDict;
			tileRates = new Array(100);
			availableTiles = new Array(Util.NUM_AVAILABLE_TILES);
			
			var image:Image = new Image(textures[Util.TILE_HUD]);
			x = (Util.STAGE_WIDTH - image.width) / 2;
			y = 0;
			addChild(image);
			
			parseFloorTiles(floorTiles);
			for (var i:int = 0; i < Util.NUM_AVAILABLE_TILES; i++) {
				availableTiles[i] = getNextTile(i);
			}
		}
		
		// TODO: Comment
		public function removeAndReplaceTile(index:int):void {
			removeChild(availableTiles[index]);
			availableTiles[index] = getNextTile(index)
		}
		
		// TODO: Comment
		public function getNextTile(index:int):Tile {
			var tile:Tile;
			var tN:Boolean = (Util.randomRange(0, 2) == 0) ? false : true;
			var tS:Boolean = (Util.randomRange(0, 2) == 0) ? false : true;
			var tE:Boolean = (Util.randomRange(0, 2) == 0) ? false : true;
			var tW:Boolean = (Util.randomRange(0, 2) == 0) ? false : true;
			if (!tN && !tS && !tE && !tW) {
				var dir:int = Util.randomRange(0, 3)
				tN = (dir == Util.NORTH) ? true : false;
				tS = (dir == Util.SOUTH) ? true : false;
				tE = (dir == Util.EAST) ? true : false;
				tW = (dir == Util.WEST) ? true : false;
			}
			var tTexture:Texture = textures[Util.getTextureString(tN, tS, tE, tW)];

			// TODO: Enemy / Healing tiles
			var tType:String = tileRates[Util.randomRange(0, 100)];
			if (tType == "enemy") {
				tile =  new Tile(0, 0, tN, tS, tE, tW, tTexture);//tile = new EnemyTile(tX, tY, tN, tS, tE, tW, tTexture);
			} else if (tType == "healing") {
				tile =  new Tile(0, 0, tN, tS, tE, tW, tTexture);//tile = new HealingTile(tX, tY, tN, tS, tE, tW, tTexture);
			} else { // empty
				tile =  new Tile(0, 0, tN, tS, tE, tW, tTexture);
			}
			tile.x = Util.HUD_PAD_LEFT + (Util.PIXELS_PER_TILE + Util.HUD_PAD_LEFT) * index;
			tile.y = Util.HUD_PAD_TOP;
			addChild(tile);
			return tile;
		}
		
		// TODO: Comment
		private function parseFloorTiles(floorTiles:ByteArray):void {
			for (var i:int = 0; i < 100; i++) {
				tileRates[i] = "blank"; // TODO: ACTUALLY PARSE FILE
			}
		}
	}
}