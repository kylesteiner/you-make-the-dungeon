package {
    import starling.display.*;
    import starling.events.*;
    import starling.text.TextField;

    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import flash.geom.Point;

    import tiles.*;

    public class RoomSet extends Sprite {

        // Map of string -> Array of Points (spaces and walls)
        public var rooms:Dictionary;

        // Map of string -> Array of Points (spaces)
        public var roomSpaces:Dictionary;

        // Map of string -> Array of Points (spaces player has filled)
        public var builtRoomTiles:Dictionary;

        // Map of string -> string of callback names
        public var roomToFunction:Dictionary;

		// Map of string -> callback function
		public var roomFunctions:Dictionary;

		// Map of string -> boolean of if fog has been cleared from a room
		public var roomsRevealed:Dictionary;

        // Map of string -> boolean of if the room callback has fired
        public var roomsComplete:Dictionary;

        public function RoomSet(roomData:Array, callbacks:Dictionary) {
            super();

			rooms = new Dictionary();
            roomSpaces = new Dictionary();
            builtRoomTiles = new Dictionary();
			roomToFunction = new Dictionary();
            roomsRevealed = new Dictionary();
            roomsComplete = new Dictionary();
            roomFunctions = callbacks;
            //seenTiles = new Array(); // only needed if tile could be added on location of existing tile
            buildRooms(roomData);
        }

        public function buildRooms(roomData:Array):void {
            // roomData is an Array of JSON objects
            var i:int; var j:int;
            var roomJSON:Object;
            var roomName:String;
            var roomCallback:String;
            var wallCoords:Array;
            var openCoords:Array;

            var allTiles:Array;
            var openTiles:Array;
            var tilePoint:Object;
            var currentPoint:Point;
            for(i = 0; i < roomData.length; i++) {
                roomJSON = roomData[i];
                roomName = roomJSON["name"];
                roomCallback = roomJSON["callback"];
                wallCoords = roomJSON["walls"]; // Set of (x, y) JSON objects
                openCoords = roomJSON["spaces"]; // Set of (x, y) JSON objects
                allTiles = new Array();
                openTiles = new Array();

                for (j = 0; j < openCoords.length; j++) {
                    tilePoint = openCoords[j];
                    currentPoint = new Point(tilePoint["x"], tilePoint["y"]);
                    allTiles.push(currentPoint);
                    openTiles.push(new Point(tilePoint["x"], tilePoint["y"]));
                }

                for (j = 0; j < wallCoords.length; j++) {
                    tilePoint = wallCoords[j];
                    currentPoint = new Point(tilePoint["x"], tilePoint["y"]);
                    allTiles.push(currentPoint);
                }

                rooms[roomName] = allTiles;
                roomSpaces[roomName] = openTiles;
                builtRoomTiles[roomName] = new Array();
                roomToFunction[roomName] = roomCallback;
                roomsRevealed[roomName] = false;
                roomsComplete[roomName] = false;
            }
        }

        public function addTile(tile:Tile):void {
            var tx:int = tile.grid_x;
            var ty:int = tile.grid_y;
            var tilePoint:Point = new Point(tx, ty);

            var key:String;
            var openSpaces:Array;
            var builtTiles:Array;
            var roomPoint:Point;
            var i:int;
            for (key in rooms) {
                openSpaces = roomSpaces[key];
                builtTiles = builtRoomTiles[key];
                for(i = 0; i < openSpaces.length; i++) {
                    roomPoint = openSpaces[i];
                    if(tilePoint.x == roomPoint.x && tilePoint.y == roomPoint.y) {
                        if(!roomsRevealed[key] && builtTiles.length == 0) {
							roomsRevealed[key] = true;
                            var revealData:Dictionary = new Dictionary();
                            revealData["revealed"] = rooms[key];
                            dispatchEvent(new GameEvent(GameEvent.REVEAL_ROOM, 0, 0, revealData));
                        }

                        if(builtTiles.indexOf(tilePoint) == -1) {
                            builtTiles.push(tilePoint);
                        }

                        if(!roomsComplete[key] && builtTiles.length == openSpaces.length) {
							roomsComplete[key] = true;
                            var completeData:Dictionary = new Dictionary();
                            completeData["completed"] = roomToFunction[key];
                            dispatchEvent(new GameEvent(GameEvent.COMPLETE_ROOM, 0, 0, completeData));
                            // complete room by calling function
							if (roomToFunction[key] && roomFunctions[roomToFunction[key]]) {
								roomFunctions[roomToFunction[key]]();
							}
                        }
                    }
                }
            }
        }
    }
}
