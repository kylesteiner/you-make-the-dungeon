# Template that you should use for your analysis script. This script loads the JSON data into a players object
# and loops over the player

import json, sys
from datetime import datetime

if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players) 
overallListLevels = [0] * 8;
for player in players: 
    print ""
    print "Player: %s" % player['uid']
    print "\tTimes Played: %s" % len(player['pageloads'])
    print "\tNumber of levels played: %d" % len(player['levels'])
    listLevels = [0] * 8
    for level in player['levels']:
    	if level["dqid"] is not None:
    		listLevels[int(float(level["qid"])) - 2] += 1
    index = 0
    for level in listLevels:
   		print "level %d played %d times" % ((index + 1), level)
                if level is not 0:
                    overallListLevels[index] += 1
   		index += 1
    print "\tAverage levels per visit: %d" % (len(player['levels']) / len(player['pageloads']))

print "overall results:"
for level in overallListLevels:
    print level

