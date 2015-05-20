package {
    //import starling.display.*;
    import starling.events.*;

    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import flash.geom.Point;

    import mx.utils.StringUtil;

    import tiles.*;

    public class RoomSet extends EventDispatcher {

        public var rooms:Dictionary;
        public var buildableRooms:Dictionary;
        public var builtRooms:Dictionary;
        public var roomToFunction:Dictionary;
        //public var roomFunctions:Dictionary;
        public var roomsRevealed:Dictionary;
        public var roomsComplete:Dictionary;

        //public var seenTiles:Array;

        public function RoomSet(roomJSON:Object) {
            super();

            rooms = new Dictionary();
            buildableRooms = new Dictionary();
            builtRooms = new Dictionary();
            roomToFunction = new Dictionary();
            roomsRevealed = new Dictionary();
            roomsComplete = new Dictionary();
            //roomFunctions = callbacks;
            //seenTiles = new Array(); // only needed if tile could be added on location of existing tile
            buildRooms(roomJSON);
        }

        public function buildRooms(roomJSON:Object):void {
            return;

            var roomDataString:String = roomData.readUTFBytes(roomData.length);
            var roomDataArray:Array = roomDataString.split("\n");

            var i:int; var j:int;
            var isOpen:Boolean;
            var splitData:Array;
            var coordData:Array;
            var roomName:String;
            var callbackString:String;
            var roomCoords:Array;
            var buildCoords:Array;
            var currCoord:Point;
            for(i = 0; i < roomDataArray.length; i++) {
                splitData = roomDataArray[i].split("\t");
                roomName = StringUtil.trim(splitData[0]);
                //roomName = "hh";
                callbackString = StringUtil.trim(splitData[1]);
                //callbackString = "h";
                isOpen = StringUtil.trim(splitData[2]) == "0" ? false : true;
                isOpen = false;
                roomCoords = rooms[roomName] ? rooms[roomName] : new Array();
                buildCoords = buildableRooms[roomName] ? buildableRooms[roomName] : new Array();

                // Does not protect against non-unique tile entries
                for(j = 3; j < splitData.length; j++) {
                    coordData = StringUtil.trim(splitData[j]).split(",");
                    currCoord = new Point(parseInt(coordData[0]), parseInt(coordData[1]));
                    roomCoords.push(currCoord);
                    if(isOpen) {
                        buildCoords.push(currCoord);
                    }
                }

                if(!rooms[roomName]) {
                    rooms[roomName] = roomCoords;
                    buildableRooms[roomName] = buildCoords;
                    builtRooms[roomName] = new Array();
                    roomToFunction[roomName] = callbackString;
                    roomsRevealed[roomName] = false;
                    roomsComplete[roomName] = false;
                }
            }
        }

        public function tileAdd(tile:Tile):void {
            var tx:int = tile.grid_x;
            var ty:int = tile.grid_y;
            var tilePoint:Point = new Point(tx, ty);

            var key:String;
            var buildCoords:Array;
            var builtCoords:Array;
            var roomPoint:Point;
            dispatchEvent(new GameEvent(GameEvent.COMPLETE_ROOM, 0, 0));
            for each (key in rooms) {
                buildCoords = buildableRooms[key];
                builtCoords = builtRooms[key];
                for each (roomPoint in buildCoords) {
                    if(tilePoint == roomPoint) {
                        if(!roomsRevealed[key] && builtCoords.length == 0) {
                            roomsRevealed[key] = true;
                            // reveal room function goes here
                            var revealData:Array = new Array();
                            revealData.push(rooms[key]);
                            dispatchEvent(new GameEvent(GameEvent.REVEAL_ROOM, 0, 0, revealData));
                        }

                        if(builtCoords.indexOf(tilePoint) == -1) {
                            builtCoords.push(tilePoint);
                        }

                        if(!roomsComplete[key] && builtCoords.length == buildCoords.length) {
                            roomsComplete[key] = true;
                            var completeData:Array = new Array();
                            completeData.push(roomToFunction[key]);
                            dispatchEvent(new GameEvent(GameEvent.COMPLETE_ROOM, 0, 0, completeData));
                            // complete room by calling function
                            // roomFunctions[roomToFunction[key]]();
                        }
                    }
                }
            }
        }
    }
}
