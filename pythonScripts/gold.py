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
				info = json.loads(action['a_detail'])
				c = info["goldSpent"]
				goldSpent += c
			elif action['aid'] == 18:
				info = json.loads(action['a_detail'])
				c = info["cost"]
				goldSpent += c
			elif action['aid'] == 12:
				info = json.loads(action['a_detail'])
				infob = action['a_detail']
				if "costOfTile" in infob:
					#i'm in idiot, don't name them differently god damn it
					c = info["costOfTile"]
				else:
					c = info["costOfDeleted"]
				goldSpent -= (c / 2)
			elif action['aid'] == 10:
				info = json.loads(action['a_detail'])
				try:
					c = info["goldSpent"]
				except KeyError:
					continue
				goldSpent += c
print goldSpent