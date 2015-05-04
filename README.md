# You Make the Dungeon

## Building on command line
```
mxmlc -source-path+=lib/starling/src -incremental=true -static-link-runtime-shared-libraries=true src/Main.as -output Main.swf
```
## Floor Data

Floor data text files are tab-delineated, with the following structure:
```
floorname
floorXDimension floorYDimension
characterXStart characterYStart
TileType1   x   y   nOpen?  sOpen?  eOpen?  wOpen?  additionalParams...
...
...
```
