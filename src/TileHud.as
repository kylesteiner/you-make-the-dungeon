package {
	import starling.core.Starling;
	import starling.display.Sprite;
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
			
			parseFloorTiles(floorTiles);
			for (var i:int = 0; i < Util.NUM_AVAILABLE_TILES; i++) {
				availableTiles[i] = getNextTile();
			}
		}
		
		// TODO: Comment
		public function removeAndReplaceTile(index:int) {
			availableTiles[index] = getNextTile()
		}
		
		// TODO: Comment
		public function getNextTile():Tile {
			var type = tileRates[Util.randomRange(0, 100)];
			if (type == "monster") {
				return null; // new Tile();
			} else {
				return null; // new Tile();
			}
			// TODO: Add other tile types
		}
		
		// TODO: Comment
		private function parseFloorTiles(floorTiles:ByteArray) {
			for (var i:int = 0; i < 100; i++) {
				tileRates[i] = "blank"; // TODO: ACTUALLY PARSE FILE
			}
		}
	}
}