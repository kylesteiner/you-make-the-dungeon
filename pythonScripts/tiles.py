import json, sys
from datetime import datetime


if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players)
one = 0
two = 0
three = 0
four = 0
tiles = 0
cost = 0
for player in players:
	for level in player['levels']:
		actions = level['actions']
		for action in actions:
			if action['aid'] == 1:
				tiles += 1
				info = action['a_detail'] 
				typeIndex = int(info.index("goldSpent"))
				typeIndex += 10
				c = int(info[typeIndex + 1])
				cost += c
				if c == 1:
					one += 1
				elif c == 2:
					two += 1
				elif c == 3:
					three += 1
				else:
					four += 1
print "one door tiles: %d" % one
print "two door tiles: %d" % two
print "three door tiles: %d" % three
print "four door tiles: %d" % four
print "tiles: %d" % tiles
print cost