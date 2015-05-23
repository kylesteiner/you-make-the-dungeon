How to get the data from the database and run the scripts

to get the data, run the getdata_dev.py script with the game number and
the version number that we are on

So for us, we would do
   python getdata_dev.py 115 (version number)

right now we are on version 2


After doing that, in the directory a json file will appear, then to run
the scripts on that json file, just do

python (scriptname) (jsonfile)

That should output the data to the console for use.
