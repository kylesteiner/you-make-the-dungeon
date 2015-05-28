import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players)
goldSpent = 0
for player in players:
	for level in player['levels']:
		actions = level['actions']
		for action in actions:
			if action['aid'] == 1:
				info = action['a_detail'] 
				typeIndex = int(info.index("goldSpent"))
				typeIndex += 10
				c = int(info[typeIndex + 1])
				goldSpent += c
			elif action['aid'] == 18:
				info = action['a_detail'] 
				typeIndex = int(info.index("cost"))
				typeIndex += 5
				c = int(info[typeIndex + 1])
				goldSpent += c
			elif action['aid'] == 12:
				info = action['a_detail'] 
				typeIndex = int(info.find("costOfTile"))
				if typeIndex > 0:
					#i'm in idiot, don't name them differently god damn it
					typeIndex += 11
				else:
					typeIndex = int(info.index("costOfDeleted"))
					typeIndex += 14
				c = int(info[typeIndex + 1])
				goldSpent -= (c / 2)
print goldSpent