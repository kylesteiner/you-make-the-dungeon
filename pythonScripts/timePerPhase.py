import json, sys
from datetime import datetime

INACTIVITY_LIMIT = 30000 #time in milliseconds that we consider inactve (i.e. 30 seconds)



if len(sys.argv) < 2:
    print "enter json file"
    sys.exit(0)
    
f = open(sys.argv[1]);
players = json.loads(f.read())

print "Number of players: %d" % len(players)
buildTime = 0.0
buildPhases = 1
runPhases = 0
runTime = 0.0
numPlay = 0
for player in players:
	time = 0
	for level in player['levels']:
		build = True
		actions = level['actions']
		lastTimeStamp = 0
		currentTimeStamp = -1
		for action in actions:
			currentTimeStamp = action["ts"]
			difference = currentTimeStamp - lastTimeStamp
			if difference > INACTIVITY_LIMIT:
				difference = INACTIVITY_LIMIT
			time += difference
			if build is True:
				buildTime = buildTime + difference
			else:
				runTime = runTime + difference             
			lastTimeStamp = currentTimeStamp
			if int(action['aid']) == 3:
				runPhases += 1
				build = False
			elif int(action['aid']) == 8:
				buildPhases += 1
				build = True
	if time is not 0:
		numPlay += 1
print "buildTime: %f" % (buildTime / 1000 /60)
print "runTime: %f" % (runTime / 1000 / 60)
print "buildPhases: %d" % buildPhases
print "runPhases: %d" % runPhases
print "players: %d" % numPlay

