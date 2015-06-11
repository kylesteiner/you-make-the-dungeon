import json, sys
from datetime import datetime

from math import ceil


# Calculates the amount of active time played in seconds. Players sometimes space out or walk away from the
# computer for long periods of time, so it's useful to just look at the amount of time that they spent actively
# interacting with your game. This function calculates the amount of active time a player spends in your time by
# counting the amount of time between each logged action.  If the player does not perform any actions for more 
# than 30 seconds, this function just adds 30 seconds onto the active time and ignores any additional time between
# actions. Depending on how often your game logs actions, you might want to change the inactivity limit

INACTIVITY_LIMIT = 30000 #time in milliseconds that we consider inactve (i.e. 30 seconds)

def activeTimePlayed(levels):
    totalActiveTime = 0
    for level in levels:
         if level["dqid"] is not None:
              actions = level["actions"]
              activeTime = 0
              lastTimeStamp = 0
              currentTimeStamp = -1

              for action in actions:
                   currentTimeStamp = action["ts"]
                   difference = currentTimeStamp - lastTimeStamp
                   if difference > INACTIVITY_LIMIT:
                        difference = INACTIVITY_LIMIT
                   activeTime = activeTime + difference             
                   lastTimeStamp = currentTimeStamp

              #print "level: ",level["qid"]," activeTime: ",activeTime       
              totalActiveTime = totalActiveTime + activeTime
    return totalActiveTime/1000

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

#print "Number of players: %d" % len(players)
distance = 0
goldEarned = 0
staminaLeft = 0
healthLeft = 0
enemiesDefeated = 0
damageTaken = 0
s = 0
end = 0
death = 0
maxEarned = 0
p = 0
for player in players:
        time = activeTimePlayed(player['levels'])
        if time > 180 or time == 0:
            continue
        p += 1
	for level in player['levels']:
		actions = level['actions']
		for action in actions:
			if action['aid'] == 8:
				info = json.loads(action['a_detail'])
				#tilesIndex = int(info.index("tilesVisited"))
				#tilesIndex += 13
				#distance += int(info[tilesIndex + 1])
				distance += info["tilesVisited"]
				#goldIndex = int(info.index("goldEarned"))
				#goldIndex += 11
				#goldEarned += int(info[goldIndex + 1])
				#mIndex = int(info.index("enemiesDefeated"))
				#mIndex += 16
				#enemiesDefeated += int(info[mIndex + 1])
				#sIndex = int(info.index("staminaLeft"))
                                maxEarned = max(maxEarned, info["goldEarned"])
				#sIndex += 12
				#staminaLeft += int(info[sIndex + 1])
				staminaLeft += info["staminaLeft"]
				#hIndex = int(info.index("healthLeft"))
				#hIndex += 11
				#if info[hIndex + 1] == '-':
				#	healthLeft -= int(info[hIndex + 2])
				#else:
				#	healthLeft += int(info[hIndex + 1])
				healthLeft += info["healthLeft"]
				x = info["reason"]
				if x == "endRunButton":
					end += 1
				elif x == "healthExpended":
					death += 1
				else:
					s += 1
#print "goldEarned: %d" % goldEarned
print "distanceTraveled: %d" % distance
#print "enemiesDefeated: %d" % enemiesDefeated
print "staminaLeft: %d" % staminaLeft
print "healthLeft: %d" % healthLeft
print "staminaExpended: %d" % s
print "healthExpended: %d" % death
print "manual end: %d" % end
print maxEarned
print p
