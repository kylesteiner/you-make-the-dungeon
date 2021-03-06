# You Make the Dungeon

## Building the game
The game can be built from the command line using the build scripts in the top level directory. Versions are included for both Windows and Unix systems.

The game can also be built using an IDE like FlashDevelop.

## In-Game Commands
w/a/s/d - move camera (build phase) / move player

arrow keys - move camera (build phase) / move player

space - switch phase

m - mute background music

, - mute sound effects

j - toggle fast movement

k - toggle fast combat

## Floor Data

Floor data is stored in JSON files. Here is an example of a floor and its structure.
```
{
	"floor_name": "main_floor",
	"floor_dimensions": {
		"width": 20,
		"height": 20
	},
	"character_start": {
		"x": 5,
		"y": 5
	},
	"tiles": [
		{
			"type": "entry",
			"x": 5,
			"y": 5,
			"edges": ["n", "s", "e", "w"]
		},
		{
			"type": "exit",
			"x": 0,
			"y": 0,
			"edges": ["s", "e"]
		},
		{
			"type": "none",
			"x": 15,
			"y": 15,
			"edges": []
		},
		{
			"type": "empty",
			"x": 10,
			"y": 10,
			"edges": ["n", "s", "e", "w"]
		},
	],
	"entities": [
		{
			"type": "enemy",
			"x": 10,
			"y": 10,
			"texture": "monster_1",
			"hp": 5,
			"attack": 2,
			"reward": 5
		},
		{
			"type": "healing",
			"x": 5,
			"y": 5,
			"texture": "health",
			"health": 5
		},
		{
			"type": "objective",
			"x": 3,
			"y": 3,
			"texture": "door",
			"key": "door",
			"prereqs": ["key"]
		}
	],
	"temporary_entities": [
		{
			"type": "enemy",
			"x": 2,
			"y": 5,
			"texture": "monster_2",
			"hp": 10,
			"attack": 4,
			"reward": 20
		}
	]
	"rooms": [
		{
			"name": 'first_room",
			"callback": "roomcb_none",
			"walls": [
				{
					"x": 3,
					"y":, 4
				},
				{
					"x": 2,
					"y", 4
				},
				{
					"x": 3,
					"y": 5
				}
			],
			"spaces": [
				{
					"x": 2,
					"y": 5
				}
			]
		}
	]
}
```

### Tiles
Tile objects contain an x/y coordinate, a type, and an array that represents which edges are passable.

Valid Types:
* entry
* exit
* empty
* none

### Entities
Entity objects contain an x/y coordinate, a type, and its texture. The "texture" field's value is the name of the texture as defined in Util.as.

Valid Types and additional parameters:
* enemy     - hp (int), attack (int), reward (int)
* healing   - health (int)
* objective - key (String), prereqs (Strings)...
