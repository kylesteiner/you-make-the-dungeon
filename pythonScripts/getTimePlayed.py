# Template that you should use for your analysis script. This script loads the JSON data into a players object
# and loops over the player

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

print "Number of players: %d" % len(players) 

times= []
totalTime = 0
for player in players: 
    #print "Player: %s" % player['uid']
    levels = player['levels']
    activeTime = activeTimePlayed(levels)
   # print "Total Levels played: %d" % len(levels)
    print "Time elapsed: %d" % activeTime
    totalTime += activeTime
    if activeTime != 0:
      times.append(activeTime)

times.sort()

maxTime = times[-1]
maxTime = maxTime / 60.0
num = maxTime * 2
print maxTime
print ceil(num)
print int(ceil(num))

percList = [0] * (1 + int(ceil(num)))

for x in range(0, len(percList)):
    for time in times:
        if time >= x * 30:
            percList[x] += 1

for perc in percList:
    print perc

print totalTime