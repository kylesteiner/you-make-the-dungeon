package ai {
    import Util;
    import tiles.*;
    import starling.display.*;
    import starling.text.*;

    public class AStar extends Sprite {
        public static const MAX_COST:int = int.MAX_VALUE;

        private var initialGrid:Array;
        private var costGrid:Array;
        private var costGridWidth:int;
        private var costGridHeight:int;

        private var observed:Array;
        private var observedIds:Array;
        //private var seen:Array;
        private var seenIds:Array;

        public var screenState:TextField;
        private var updates:int;

        public function AStar(floorGrid:Array) {
            // Outer array of floorGrid is x
            // Inner arrays of floorGrid are y
            // Assume floorGrid is an array of arrays
            // and is not jagged
            initialGrid = floorGrid;
            updates = 0;
            screenState = new TextField(640, 128, updates.toString(), "Verdana", Util.MEDIUM_FONT_SIZE);
            screenState.y = 256;
            addChild(screenState);
            createCostGrid();
        }

        // Might be unused function.
        public function getStartExitPath(startTile:Tile, endTile:Tile):Array {
            return findPath(startTile.grid_x, startTile.grid_y,
                            endTile.grid_x, endTile.grid_y);
        }

        // TODO: update void -> Path
        // returns an array of directions
        public function findPath(sX:int, sY:int, eX:int, eY:int):Array {
            // Assumes passed (x,y) are valid nodes
            // and that a path can be found from s -> e.

            observed = new Array();
            observedIds = new Array();
            //seen = new Array();
            seenIds = new Array();

            var startNode:AStarNode = costGrid[sX][sY];
            var endNode:AStarNode = costGrid[eX][eY];
            var nextNode:AStarNode = startNode;
            var finalNode:AStarNode;

            observed.push(startNode);
            observedIds.push(startNode.id);

            while(nextNode) {
                //updates++;
                finalNode = handleNode(nextNode, endNode);
                //screenState.text = observed.length.toString();
                if(finalNode) {
                    screenState.text = "Found solun";
                    return createPath(finalNode);
                }
                nextNode = getBestOpenNode();
            }

            return null;
        }

        public function handleNode(current:AStarNode, endNode:AStarNode):AStarNode {
            var currentIndex:int = observed.indexOf(current.id);
            observed.splice(currentIndex, 1);
            observedIds.splice(currentIndex, 1);
            seenIds.push(current.id);

            var adjNodes:Array = getAdjacentNodes(current, endNode);

            for each (var node:AStarNode in adjNodes) {
                if(node.id == endNode.id) {
                    return node;
                } else if(seenIds.indexOf(node.id) != -1) {
                    continue;
                } else if(observedIds.indexOf(node.id) != -1) {
                    currentIndex = observedIds.indexOf(node.id);
                    // TODO: implement mCost, see how it interacts
                    // with multiple visits.
                    if(node.pathCost < observed[currentIndex].pathCost) {
                        // this might bug. If so, remove then
                        // re-add the node.
                        observed[currentIndex] = node;
                        observedIds[currentIndex] = node.id;
                    }
                } else {
                    observed.push(node);
                    observedIds.push(node.id);
                }
            }

            return null;
        }

        public function getBestOpenNode():AStarNode {
            var best:AStarNode = null;

            for each (var node:AStarNode in observed) {
                if(!best || node.pathScore <= best.pathScore) {
                    best = node;
                }
            }

            return best;
        }

        public function createPath(endNode:AStarNode):Array {
            var directionPath:Array = new Array();
            var currentNode:AStarNode = endNode;
            var priorNode:AStarNode = null;

            while(currentNode) {
                if(priorNode) {
                    if(priorNode.x > currentNode.x) {
                        directionPath.unshift(Util.EAST);
                    } else if(priorNode.x < currentNode.x) {
                        directionPath.unshift(Util.WEST);
                    } else if(priorNode.y < currentNode.y) {
                        directionPath.unshift(Util.NORTH);
                    } else {
                        // South, also catchall for easier bug detection
                        directionPath.unshift(Util.SOUTH);
                    }
                }

                priorNode = currentNode;
                currentNode = currentNode.pathParent;
            }

            screenState.text = directionPath.toString();

            return directionPath;
        }

        private function getNode(node_x:int, node_y:int, parentNode:AStarNode, endNode:AStarNode):AStarNode {
            var x_diff:int; var y_diff:int;
            var manhattanDistance:int;

            if(node_x < 0 || node_x >= costGridWidth) {
                return null;
            }

            if(node_y < 0 || node_y >= costGridHeight) {
                return null;
            }

            var rtnNode:AStarNode;
            var refNode:AStarNode = costGrid[node_x][node_y];

            rtnNode = new AStarNode(refNode.id, refNode.x, refNode.y,
                                    refNode.north, refNode.south,
                                    refNode.east, refNode.west,
                                    refNode.initial, refNode.visited,
                                    parentNode);

            x_diff = Math.abs(rtnNode.x - endNode.x);
            y_diff = Math.abs(rtnNode.y - endNode.y);
            manhattanDistance = x_diff + y_diff;
            //rtnNode.pathParent = parentNode;
            rtnNode.pathCost += parentNode.pathCost;
            rtnNode.pathScore += rtnNode.pathCost + manhattanDistance;

            return rtnNode;
        }

        public function createCostGrid():void {
            costGridWidth = initialGrid.length;
            costGridHeight = initialGrid[0].length;
            costGrid = new Array();

            var x:int; var y:int; var id:int;
            var initialCost:int; var visitedCost:int;
            var tempNode:AStarNode; var tempTile:Tile;

            for(x = 0; x < costGridWidth; x++) {
                costGrid.push(new Array());
                for(y = 0; y < costGridHeight; y++) {
                    id = x*costGridHeight + y;
                    tempTile = initialGrid[x][y];

                    if(tempTile) {
                        /*if(x == 0 && y == 0) {
                            screenState.text = tempTile.east ? "hiii" : "no";
                        }*/
                        tempNode = new AStarNode(id, x, y,
                                                 tempTile.north, tempTile.south,
                                                 tempTile.east, tempTile.west,
                                                 getCost(tempTile, false),
                                                 getCost(tempTile, true));
                    } else {
                        tempNode = new AStarNode(id, x, y, false, false,
                                                 false, false, MAX_COST, MAX_COST);
                    }

                    costGrid[x].push(tempNode);
                }
            }
        }

        private function getCost(tile:Tile, visited:Boolean):int {
            var enemyCost:int = 1;
            var objectiveCost:int = -20;
            var emptyCost:int = 2;
            var emptyVisitedCost:int = 6;
            var healthMultiplier:int = 4;

            if(tile is EnemyTile) {
                return visited ? enemyCost : emptyVisitedCost;
            } else if(tile is HealingTile) {
                return visited ? -(tile as HealingTile).health * healthMultiplier : emptyVisitedCost;
            } else if(tile is ImpassableTile) {
                return visited ? MAX_COST : MAX_COST;
            } else if(tile is ObjectiveTile) {
                return visited ? objectiveCost : emptyVisitedCost;
            } else if(tile is EntryTile) {
                return visited ? emptyCost : emptyVisitedCost;
            } else if(tile is ExitTile) {
                return visited ? -10 : emptyVisitedCost;
            } else {
                // Empty tile
                return visited ? emptyCost : emptyVisitedCost;
            }
        }

        private function getAdjacentNodes(node:AStarNode, endNode:AStarNode):Array {
            var i:int;
            var cNode:AStarNode;
            var adjacentNodes:Array = new Array();
            // TODO: check bounds for x, y
            // TODO: add expectimax

            //cNode = costGrid[(node.x - 1) * costGridHeight + node.y];
            cNode = getNode(node.x - 1, node.y, node, endNode);
            if(cNode && cNode.east && node.west) {
                adjacentNodes.push(cNode);
            }

            //cNode = costGrid[(node.x + 1) * costGridHeight + node.y];
            cNode = getNode(node.x + 1, node.y, node, endNode);
            //screenState.text = (node.east) ? "true" : "false";
            //screenState.text = node.x.toString() + ", " + node.y.toString();
            if(cNode && cNode.west && node.east) {
                adjacentNodes.push(cNode);
            }

            //cNode = costGrid[node.x * costGridHeight + (node.y - 1)];
            cNode = getNode(node.x, node.y - 1, node, endNode);
            if(cNode && cNode.south && node.north) {
                adjacentNodes.push(cNode);
            }

            //cNode = costGrid[node.x * costGridHeight + (node.y + 1)];
            cNode = getNode(node.x, node.y + 1, node, endNode);
            if(cNode && cNode.north && node.south) {
                adjacentNodes.push(cNode);
            }

            //screenState.text = adjacentNodes.length.toString();

            return adjacentNodes;
        }
    }
}
