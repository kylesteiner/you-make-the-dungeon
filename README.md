# You Make the Dungeon

## Building on command line
```
mxmlc -source-path+=lib/starling/src -incremental=true -static-link-runtime-shared-libraries=true src/Main.as -output Main.swf
```

## In-Game Commands
m - toggle mute
w/a/s/d - move camera

## Floor Data

Floor data text files are tab-delineated, with the following structure:
```
FloorName
FloorXDimension	FloorYDimension
CharInitialX	CharInitialY
TileType	x	y	nOpen?	sOpen?	eOpen?	wOpen?	AdditionalParams...
...
...

The valid tile types are:
*entry
*exit
*empty
*health (additional parameters: amount of health)
*none

```
