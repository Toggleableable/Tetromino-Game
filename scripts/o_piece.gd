extends Shape

func _ready():
	piece_shapes = [[Vector2i(1,0), Vector2i(2,0), Vector2i(1,1), Vector2i(2,1)]]
	wall_kicks = [[Vector2i(0,0)]]
	colour_index = 1

func rotate_piece(current_rotation, _direction) -> int:
	# O piece doesn't rotate
	return current_rotation
