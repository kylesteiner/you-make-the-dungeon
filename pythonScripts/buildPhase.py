import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players)
tiles = 0
goldSpent = 0
entitiesPlaced = 0
for player in players:
	for level in player['levels']:
		actions = level['actions']
		for action in actions:
			if action['aid'] == 3:
				info = action['a_detail'] 
				tilesIndex = int(info.index("numberOfTiles"))
				tilesIndex += 14
				tiles += int(info[tilesIndex + 1])
				goldIndex = int(info.index("goldSpent"))
				goldIndex += 10
				if info[goldIndex + 1] == '-':
					goldSpent -= int(info[goldIndex + 2])
				else:
					goldSpent += int(info[goldIndex + 1])
				entityIndex = int(info.index("numberOfEntitiesPlaced"))
				entityIndex += 23
				entitiesPlaced += int(info[entityIndex + 1])
print "goldSpent: %d" % goldSpent
print "tilesPlaced: %d" % tiles
print "entitiesPlaced: %d" % entitiesPlaced