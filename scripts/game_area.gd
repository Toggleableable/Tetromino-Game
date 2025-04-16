extends TileMapLayer

const rows: int = 22
const columns: int = 10
const start_location: Vector2i = Vector2i(3,-1)
const start_rotation: int = 0
const next_queue: int = 5
const place_time: float = 0.5
const place_reset_limit: int = 15

var fall_time: float
var pieces: Array
var next_pieces: Array = []
var next_piece: int
var shuffle_array: Array
var tileset_id: int = 0
var place_resets: int = 0

var current_rotation: int = 0
var current_location: Vector2i = start_location
var current_piece: Shape

func _ready():
	pieces = $Shape.get_children()
	shuffle_array = range(pieces.size())
	
	# New Game
	create_piece()

func _process(_delta):
	# TODO change to be based on time, implement DAS and ARR
	if Input.is_action_just_pressed("soft_drop"):
		move_piece(Vector2i.DOWN)
		$DropPieceTimer.start(fall_time)
	if Input.is_action_just_pressed("move_left"):
		move_piece(Vector2i.LEFT)
	if Input.is_action_just_pressed("move_right"):
		move_piece(Vector2i.RIGHT)
	
	if Input.is_action_just_pressed("rotate_clockwise"):
		current_rotation = current_piece.rotate_piece(current_rotation, 1)
	if Input.is_action_just_pressed("rotate_counter_clockwise"):
		current_rotation = current_piece.rotate_piece(current_rotation, -1)

## Checks if the current piece is able to move in the direction given
func can_move(direction: Vector2i) -> bool:
	var used_cells: Array = $PlacedPieces.get_used_cells()
	for i in current_piece.piece_shapes[current_rotation]:
		var piece_location = i + current_location + direction
		if piece_location.x < 0 or piece_location.x > columns - 1 or piece_location.y > rows - 1:
			return false
		if piece_location in used_cells:
			return false
	return true

## Clears the tiles of the current piece in the current location
func clear_piece():
	for i in current_piece.piece_shapes[current_rotation]:
		erase_cell(i + current_location)

## Generates a new piece from the next_pieces queue and reset all the relavent variables
func create_piece():
	current_rotation = start_rotation
	current_location = start_location
	place_resets = 0
	#$DropPieceTimer.start(fall_time)
	if next_pieces.size() < next_queue:
		shuffle_pieces()
	current_piece = pieces[next_pieces.pop_front()]
	draw_piece()
	move_piece(Vector2i.DOWN)

## Iterates through the cells in a piece and draws them in the given location
func draw_piece():
	for i in current_piece.piece_shapes[current_rotation]:
		set_cell(i + current_location, tileset_id, Vector2i(current_piece.colour_index, 0))

## Moves the current piece in the direction specified
func move_piece(direction: Vector2i):
	if can_move(direction):
		clear_piece()
		current_location += direction
		draw_piece()
	elif direction == Vector2i.DOWN:
		place_piece()

## Places the piece onto the placed layer and creates the next piece
func place_piece():
	clear_piece()
	for i in current_piece.piece_shapes[current_rotation]:
		$PlacedPieces.set_cell(i + current_location, tileset_id, Vector2i(current_piece.colour_index, 0))
	create_piece()

## Shuffles the possible pieces and appends them to the next_pieces array (7-Bag)
func shuffle_pieces():
	shuffle_array.shuffle()
	next_pieces.append_array(shuffle_array)

func _on_drop_piece_timer_timeout() -> void:
	move_piece(Vector2i.DOWN)
