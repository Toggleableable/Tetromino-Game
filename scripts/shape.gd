extends Node
class_name Shape

## 2D array of Vector2i's containing all 4 rotations
var piece_shapes: Array
var colour_index: int

func rotate_piece(current_rotation, direction) -> int:
	# direction must be 1 for clockwise, -1 for counter clockwise
	return (current_rotation + direction) % 4
