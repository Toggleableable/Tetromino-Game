extends Shape

func _ready():
	piece_shapes = [[Vector2i(1,0), Vector2i(2,0), Vector2i(1,1), Vector2i(2,1)]]
	colour_index = 1

func rotate_piece(current_rotation, direction):
	# O piece doesn't rotate
	pass
