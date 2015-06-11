import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players)
goldEarned = 0
enemies = 0
maxEarned = 0;
for player in players:
	for level in player['levels']:
		actions = level['actions']
		for action in actions:
			if action['aid'] == 22:
				info = json.loads(action['a_detail'])
				goldEarned += info["goldEarned"]
                                maxEarned = max(info["goldEarned"], maxEarned)
			elif action['aid'] == 19:
				info = json.loads(action['a_detail'])
				#typeIndex = int(info.index("cost"))
				#typeIndex += 5
				x = info["type"]
				if x == "gold":
					goldEarned += info["goldEarned"]
			elif action['aid'] == 17:
				info = json.loads(action['a_detail'])
				goldEarned += info["reward"]
				enemies += 1
print goldEarned
print enemies
print maxEarned
