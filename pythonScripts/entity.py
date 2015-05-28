import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players)
healing = 0
enemy = 0
for player in players:
	for level in player['levels']:
		actions = level['actions']
		for action in actions:
			if action['aid'] == 18:
				info = action['a_detail'] 
				typeIndex = int(info.find("enemy"))
				if typeIndex > 0:
					enemy += 1
				else:
					healing += 1
print "healing: %d" % healing
print "enemy: %d" % enemy
