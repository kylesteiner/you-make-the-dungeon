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
NumTiles
TileType	x	y	northOpen?	southOpen?	eastOpen?	westOpen?
...
...
NumEntities
EntityType	x	y	texture	AdditionalParameters...
```

Rate of drawing each tile (per floor) is tab-delineated, with the following structure:
```
TileType	Rate
...
...
```

### Valid Tile Types
* entry
* exit
* empty
* none

### Valid Entity Types and Additional Parameters
For the texture parameter, look up the string used to identify the texture in
Util.as.
* enemy     - hp (int), attack (int), reward (int)
* healing   - health (int)
* objective - key (String), prereqs (Strings)...
