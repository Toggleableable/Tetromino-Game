extends Shape

func _ready():
	piece_shapes = [[Vector2i(0,1), Vector2i(1,1), Vector2i(1,0), Vector2i(2,0)],
					[Vector2i(1,0), Vector2i(1,1), Vector2i(2,1), Vector2i(2,2)],
					[Vector2i(1,1), Vector2i(2,1), Vector2i(0,2), Vector2i(1,2)],
					[Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(1,2)],
	]
	colour_index = 3
