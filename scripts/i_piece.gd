extends Shape

func _ready():
	piece_shapes = [[Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(3,1)],
					[Vector2i(2,0), Vector2i(2,1), Vector2i(2,2), Vector2i(2,3)],
					[Vector2i(0,2), Vector2i(1,2), Vector2i(2,2), Vector2i(3,2)],
					[Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3)],
	]
	colour_index = 0
