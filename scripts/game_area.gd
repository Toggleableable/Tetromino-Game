extends TileMapLayer

const rows: int = 22
const columns: int = 10

var pieces: Array

var tileset_id: int = 0

func _ready():
	var location: Vector2i = Vector2i(0,0)
	pieces = $Shape.get_children()
	for i in pieces:
		draw_piece(i, location)
		location += Vector2i(0,2)

func draw_piece(current_piece: Shape, location: Vector2i):
	for i in current_piece.piece_shapes[current_piece.current_rotation]:
		set_cell(i + location, tileset_id, Vector2i(current_piece.colour_index, 0))
