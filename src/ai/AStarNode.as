package ai {
    public class AStarNode {

        public var x:int;
        public var y:int;
        public var initial:int;
        public var visited:int;
        public var pathCost:int;
        public var pathScore:int;
        public var pathParent:AStarNode;
        public var id:int;
        public var north:Boolean;
        public var south:Boolean;
        public var east:Boolean;
        public var west:Boolean;

        public function AStarNode(node_id:int, node_x:int, node_y:int,
                                  northOpen:Boolean, southOpen:Boolean,
                                  eastOpen:Boolean, westOpen:Boolean,
                                  initialCost:int, visitedCost:int,
                                  parentNode:AStarNode = null) {
            id = node_id;
            x = node_x;
            y = node_y;
            north = northOpen;
            south = southOpen;
            east = eastOpen;
            west = westOpen;
            initial = initialCost;
            visited = visitedCost;

            pathCost = 0;
            pathScore = 0;
            pathParent = parentNode;

            determinePathCost();
        }

        // Determine the map cost of this tile in
        // the path being considered. Only considers
        // its own cost, not the cost of any other tiles
        // along the way.
        public function determinePathCost():void {
            var selfFound:int = 0;
            var currentNode:AStarNode = pathParent;

            while(currentNode) {
                selfFound += (currentNode.x == x && currentNode.y == y) ? 1 : 0;
                currentNode = currentNode.pathParent;
            }

            pathCost = selfFound ? initial : visited * selfFound;
        }
    }
}
