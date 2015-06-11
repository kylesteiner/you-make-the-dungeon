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
m = 0
for player in players: 
    #print ""
    #print "Player: %s" % player['uid']
    #print "\tNumber of page loads (visits): %d" % len(player['pageloads'])
    m = max(m, len(player['pageloads']))
        #print "\t\tLevel End Event Detail %s" % level['quest_end']['q_detail']

array = [0] * m
for player in players:
    for i in range(0, len(player['pageloads'])):
        array[i] += 1

for x in array:
    print x
print m
