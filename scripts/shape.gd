extends Node
class_name Shape

## 2D array of Vector2i's containing all 4 rotations
var piece_shapes: Array
var colour_index: int

## 2D array of Vector2i's containing the directions to attempt to move the piece if it cannot rotate
var wall_kicks: Array = [	[Vector2i(0,0), Vector2i(-1,0), Vector2i(-1, -1), Vector2i(0,2), Vector2i(-1,2)],
							[Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(0,-2), Vector2i(1,-2)],
							[Vector2i(0,0), Vector2i(1,0), Vector2i(1,-1), Vector2i(0,2), Vector2i(1,2)],
							[Vector2i(0,0), Vector2i(-1,0), Vector2i(-1,1), Vector2i(0,-2), Vector2i(-1,-2)],
							]

func rotate_piece(current_rotation, direction) -> int:
	# direction must be 1 for clockwise, -1 for counter clockwise
	return (current_rotation + direction) % 4
