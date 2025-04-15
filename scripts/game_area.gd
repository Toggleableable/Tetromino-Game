extends TileMapLayer

const rows: int = 22
const columns: int = 10
const start_location: Vector2i = Vector2i(2,0)
const start_rotation: int = 0

var fall_time: float
var pieces: Array
var next_pieces: Array = []
var next_piece: int
var shuffle_array: Array
var tileset_id: int = 0

var current_rotation: int = 0
var current_location: Vector2i = start_location
var current_piece: Shape

func _ready():
	pieces = $Shape.get_children()
	shuffle_array = range(pieces.size())
	
	# New Game
	shuffle_pieces()
	create_piece()
	$DropPieceTimer.start(fall_time)

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

func clear_piece():
	for i in current_piece.piece_shapes[current_rotation]:
		erase_cell(i + current_location)

func create_piece():
	current_rotation = start_rotation
	current_location = start_location
	current_piece = pieces[next_pieces.pop_front()]
	draw_piece()

## Iterates through the cells in a piece and draws them in the given location
func draw_piece():
	for i in current_piece.piece_shapes[current_rotation]:
		set_cell(i + current_location, tileset_id, Vector2i(current_piece.colour_index, 0))

func move_piece(direction: Vector2i):
	clear_piece()
	current_location += direction
	draw_piece()

## Shuffles the possible pieces and appends them to the next_pieces array (7-Bag)
func shuffle_pieces():
	shuffle_array.shuffle()
	next_pieces.append_array(shuffle_array)

func _on_drop_piece_timer_timeout() -> void:
	move_piece(Vector2i.DOWN)
