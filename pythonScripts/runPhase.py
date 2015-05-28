import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players)
distance = 0
goldEarned = 0
staminaLeft = 0
healthLeft = 0
enemiesDefeated = 0
damageTaken = 0
s = 0
end = 0
death = 0
for player in players:
	for level in player['levels']:
		actions = level['actions']
		for action in actions:
			if action['aid'] == 8:
				info = action['a_detail'] 
				tilesIndex = int(info.index("tilesVisited"))
				tilesIndex += 13
				distance += int(info[tilesIndex + 1])
				goldIndex = int(info.index("goldEarned"))
				goldIndex += 11
				goldEarned += int(info[goldIndex + 1])
				mIndex = int(info.index("enemiesDefeated"))
				mIndex += 16
				enemiesDefeated += int(info[mIndex + 1])
				sIndex = int(info.index("staminaLeft"))
				sIndex += 12
				staminaLeft += int(info[sIndex + 1])
				hIndex = int(info.index("healthLeft"))
				hIndex += 11
				if info[hIndex + 1] == '-':
					healthLeft -= int(info[hIndex + 2])
				else:
					healthLeft += int(info[hIndex + 1])
				if int(info.find("endRunButton")) > 0:
					end += 1
				elif int(info.find("healthExpended")) > 0:
					death += 1
				else:
					s += 1
print "goldEarned: %d" % goldEarned
print "distanceTraveled: %d" % distance
print "enemiesDefeated: %d" % enemiesDefeated
print "staminaLeft: %d" % staminaLeft
print "healthLeft: %d" % healthLeft
print "staminaExpended: %d" % s
print "healthExpended: %d" % death
print "manual end: %d" % end