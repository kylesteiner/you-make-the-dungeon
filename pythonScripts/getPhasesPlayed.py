import json, sys
from datetime import datetime
from math import ceil

INACTIVITY_LIMIT = 30000 #time in milliseconds that we consider inactve (i.e. 30 seconds)

if len(sys.argv) < 2:
    print 'Usage: python getPhasesPlayed.py <input file>'
    sys.exit(0)
    
f = open(sys.argv[1])
players = json.loads(f.read())

# Map phase number -> player count
phases = dict()
phases[0] = 0

for player in players:
    levels = player['levels']

    for level in levels:
        if level['dqid'] is not None:
            phases[0] += 1
            actions = level['actions']
            
            phase = 0
            
            # Increment phases if either run or build action
            for action in actions:
                if int(action['aid']) == 3 or int(action['aid']) == 8:
                    phase += 1
                    if phase not in phases:
                        phases[phase] = 0
                    phases[phase] += 1

sortedPhases = list()
for i in range(0, len(phases)):
    sortedPhases.append(phases[i])

for count in sortedPhases:
    print count


