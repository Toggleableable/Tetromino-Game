extends TileMapLayer

const rows: int = 22
const columns: int = 10
const start_location: Vector2i = Vector2i(2,0)

var pieces: Array
var next_pieces: Array = []
var shuffle_array: Array
var tileset_id: int = 0

var current_rotation: int = 0
var current_location: Vector2i = start_location

func _ready():
	pieces = $Shape.get_children()
	shuffle_array = range(pieces.size())
	shuffle_pieces()
	
	for i in next_pieces:
		draw_piece(pieces[i], current_location)
		current_location += Vector2i(2,2)

## Iterates through the cells in a piece and draws them in the given location
func draw_piece(current_piece: Shape, location: Vector2i):
	for i in current_piece.piece_shapes[current_rotation]:
		set_cell(i + location, tileset_id, Vector2i(current_piece.colour_index, 0))

func shuffle_pieces():
	shuffle_array.shuffle()
	next_pieces.append_array(shuffle_array)
