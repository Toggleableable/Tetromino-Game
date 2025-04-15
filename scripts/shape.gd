extends Node
class_name Shape

# 2D array of Vector2i's containing all 4 rotations
var piece_shapes: Array
var current_rotation: int = 0
var colour_index: int

func rotate_piece(current_rotation, direction):
	# direction must be 1 for clockwise, -1 for counter clockwise
	current_rotation = (current_rotation + direction) % 4
