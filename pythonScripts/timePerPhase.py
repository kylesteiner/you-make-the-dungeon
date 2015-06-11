import json, sys
from datetime import datetime

INACTIVITY_LIMIT = 30000 #time in milliseconds that we consider inactve (i.e. 30 seconds)

from math import ceil


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
buildTime = 0.0
buildPhases = 0
runPhases = 0
runTime = 0.0
numPlay = 0
endAfter1B = 0
endAfter1R = 0
# for going phase by phase
timeBuild = 0
timeRun = 0
endAfter2B = 0
endAfter2R = 0
s1 = 0
s2 = 0
p = 0
tS = 0
timeTakenBuild1 = 0
timeTakenBuild2 = 0
timeTakenRun1 = 0
timeTakenRun2 = 0
ttb = 0
ttr = 0

for player in players:
	time = 0
	timeBuild = 0
	timeRun = 0
	tS = 0
	ttb = 0
	ttr = 0
        eT = activeTimePlayed(player['levels'])
        #if eT == 0 or eT > 180:
        #    continue
        p += 1
	for level in player['levels']:
		build = False
		actions = level['actions']
		lastTimeStamp = 0
		currentTimeStamp = -1
		runPhases += 1
		timeRun += 1
		for action in actions:
			currentTimeStamp = action["ts"]
			difference = currentTimeStamp - lastTimeStamp
			if difference > INACTIVITY_LIMIT:
				difference = INACTIVITY_LIMIT
			time += difference
			if build is True:
				ttb = ttb + difference
				buildTime = buildTime + difference
			else:
				runTime = runTime + difference
				ttr = ttr + difference            
			lastTimeStamp = currentTimeStamp
			if int(action['aid']) == 3:
				runPhases += 1
				build = False
				if timeBuild == 1:
					timeTakenBuild1 += ttb
					timeRun += 1
				elif timeBuild == 2:
					timeTakenBuild2 += ttb
				ttb = 0
			elif int(action['aid']) == 8:
				buildPhases += 1
				info = json.loads(action['a_detail'])
				tS += info['staminaLeft']
				build = True
				if timeRun == 1:
					timeTakenRun1 += ttr
					timeBuild += 1
				elif timeRun == 2:
					timeTakenRun2 += ttr
					timeBuild += 1
				ttr = 0
	if time is not 0:
		numPlay += 1
	if timeBuild == 1:
		endAfter1B += 1
	#	ttb1 += tt
	elif timeBuild == 2:
		endAfter2B += 1
	#	ttb2 += ttb
	if timeRun == 1:
		endAfter1R += 1
		s1 += tS
	#	ttr1 += ttr
	elif timeRun == 2:
		endAfter2R += 1
		s2 += tS
	#	ttr2 += ttr
print "buildTime: %f" % (buildTime / 1000 /60)
print "runTime: %f" % (runTime / 1000 / 60)
print "buildPhases: %d" % buildPhases
print "runPhases: %d" % runPhases
#print "players: %d" % numPlay
#print p
print "end after 1 build %d" % endAfter1B
print "end after 2 builds %d" % endAfter2B
#print (s1 * 1.0 / endAfter1R)
#print (s2 *1.0 / endAfter2R)
print "1 build time %f" % (timeTakenBuild1 * 1.0 / 1000  / (endAfter1B + endAfter2B))
print "2 build time %f" % (timeTakenBuild2 * 1.0 / 1000 / endAfter2B / 2)
print "1 run time %f" % (timeTakenRun1 * 1.0 / 1000  / (endAfter1R + endAfter2R))
print "2 run time %f" % (timeTakenRun2 * 1.0 / 1000 / endAfter2R / 2)
#print (ttbo * 1.0 / 1000 / (temp1 /endAfterob))
#print (ttro * 1.0 / 1000 / (temp2 / endAfteror))
#print (ttr1 * 1.0 / 1000 / (p))
#print (ttr2 * 1.0 / 1000/ (p))
#print (ttb1 * 1.0 / 1000/( p) / 2)
#print (ttb2 * 1.0 / 1000/(p) /2 )
