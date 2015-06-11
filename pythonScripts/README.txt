How to get the data from the database and run the scripts

to get the data, run the getdata_prd.py script with the game number and
the version number that we are on

So for us, we would do
   python getdata_dev.py 115 (version number)

right now we are on version 23 for kongregate


After doing that, in the directory a json file will appear, then to run
the scripts on that json file, just do

python (scriptname) (jsonfile)

That should output the data to the console for use.

the getTimePlayed script outputs the number of players for every half a minute, so each
number printed after it prints what is essentially nonsense is 0, then 30 seconds, and 
so on.
