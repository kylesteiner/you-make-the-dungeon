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
traps = 0
stamina = 0
for player in players:
	for level in player['levels']:
		actions = level['actions']
		for action in actions:
			if action['aid'] == 18:
				info = json.loads(action['a_detail'])
				x = info["entityPlaced"]
				if x == "enemy":
					enemy += 1
				elif x == "healing":
					healing += 1
				elif x == "stamina":
					stamina += 1
				else:
					traps += 1
print "healing: %d" % healing
print "enemy: %d" % enemy
print "traps: %d" % traps
print "stamina: %d" % stamina
print "total: %d" % (healing + stamina + enemy + traps)
