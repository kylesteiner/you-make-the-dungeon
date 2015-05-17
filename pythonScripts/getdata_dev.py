#!/usr/bin/python

import sys
import urllib

CHUNK_SIZE = 1 * 1024 * 1024

try:
    gid = int(sys.argv[1])
    cid = int(sys.argv[2])
except:
    print "Usage: %s <game id> <category id>" % (sys.argv[0])
    sys.exit(1)

url = "http://games.cs.washington.edu/cgs/py/cse481d/sp15/getdata_dev.py?gid=%d&cid=%d" % (gid, cid)
filename = "dump_dev_%d-%d.json" % (gid, cid)

fin = urllib.urlopen(url)
with open(filename, "w") as fout:
    while True:
        chunk = fin.read(CHUNK_SIZE)
        if not chunk: break
        fout.write(chunk)

