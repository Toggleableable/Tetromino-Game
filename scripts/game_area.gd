extends TileMapLayer

const rows: int = 22
const columns: int = 10
const start_location: Vector2i = Vector2i(3,0)
const start_rotation: int = 0
const next_queue: int = 5
const next_queue_location: Vector2i = Vector2i(15,2)
const place_time: float = 0.5
const place_reset_limit: int = 15

## Delayed Auto Shift
const DAS: float = 0
## Auto repeat rate
const ARR: float = 0
## Entry delay
const ARE: float = 0

var fall_time: float = 1
var pieces: Array
var shuffle_array: Array
var tileset_id: int = 0

var next_pieces: Array = []
var place_resets: int = 0
var used_cells: Array = []
var current_rotation: int = 0
var current_location: Vector2i = start_location
var current_piece: Shape
var cells_in_rows: Array = []

func _ready():
	pieces = $Shape.get_children()
	shuffle_array = range(pieces.size())
	
	# New Game
	cells_in_rows.resize(rows)
	for i in rows:
		cells_in_rows[i] = []
	
	create_piece()

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	# TODO change to be based on time, implement DAS and ARR
	if Input.is_action_just_pressed("soft_drop"):
		move_piece(Vector2i.DOWN)
	if Input.is_action_just_pressed("hard_drop"):
		var distance: int = 0
		while can_move((distance + 1) * Vector2i.DOWN):
			distance += 1
		clear_piece()
		current_location += distance * Vector2i.DOWN
		place_piece()
	
	if Input.is_action_just_pressed("move_left"):
		move_piece(Vector2i.LEFT)
	if Input.is_action_just_pressed("move_right"):
		move_piece(Vector2i.RIGHT)
	
	if Input.is_action_just_pressed("rotate_clockwise"):
		rotate_piece(1)
	if Input.is_action_just_pressed("rotate_counter_clockwise"):
		rotate_piece(-1)

## Checks if the current piece is able to move in the direction given
func can_move(direction: Vector2i = Vector2i.ZERO, new_rotation: int = current_rotation) -> bool:
	for i in current_piece.piece_shapes[new_rotation]:
		var piece_location = i + current_location + direction
		if piece_location.x < 0 or piece_location.x > columns - 1 or piece_location.y > rows - 1:
			return false
		if piece_location in used_cells:
			return false
	return true

## Clears the tiles of the current piece in the current location
func clear_piece(piece: Shape = current_piece, location: Vector2i = current_location):
	for i in piece.piece_shapes[current_rotation]:
		erase_cell(i + location)

## Generates a new piece from the next_pieces queue and reset all the relavent variables
func create_piece():
	current_rotation = start_rotation
	current_location = start_location
	place_resets = 0
	$DropPieceTimer.start(fall_time)
	if next_pieces.size() <= next_queue:
		shuffle_pieces()
	current_piece = pieces[next_pieces.pop_front()]
	
	draw_piece()
	draw_next_pieces()
	if !can_move():
		game_over()
	else:
		move_piece(Vector2i.DOWN)

## Draws the queue of next pieces to the side of the board
func draw_next_pieces():
	var draw_location = next_queue_location
	for i in range(next_queue):
		if i == 0:
			clear_piece(current_piece, draw_location)
		else:
			clear_piece(pieces[next_pieces[i-1]], draw_location)
		
		draw_piece(pieces[next_pieces[i]], draw_location)
		draw_location += Vector2i(0, 3)

## Iterates through the cells in a piece and draws them in the given location
func draw_piece(piece: Shape = current_piece, location: Vector2i = current_location):
	for i in piece.piece_shapes[current_rotation]:
		set_cell(i + location, tileset_id, Vector2i(piece.colour_index, 0))

func game_over():
	$DropPieceTimer.stop()
	print("End")
	# TODO Add game over screen + option to restart

## Moves the current piece in the direction specified
func move_piece(direction: Vector2i):
	if can_move(direction):
		if direction == Vector2i.DOWN:
			$DropPieceTimer.start(fall_time)
		clear_piece()
		current_location += direction
		draw_piece()
	elif direction == Vector2i.DOWN:
		place_piece()

## Places the piece onto the placed layer and creates the next piece
func place_piece():
	var out_of_field: bool = true
	for i in current_piece.piece_shapes[current_rotation]:
		cells_in_rows[i.y + current_location.y].append((i + current_location).x)
		$PlacedPieces.set_cell(i + current_location, tileset_id, Vector2i(current_piece.colour_index, 0))
		if (i + current_location).y > 1:
			out_of_field = false
	
	if out_of_field:
		game_over()
	else:
		check_full_rows()
		clear_piece()
		used_cells = $PlacedPieces.get_used_cells()
		create_piece()

func rotate_piece(direction):
	var attempt_rotate: int = current_piece.rotate_piece(current_rotation, direction)
	
	# Set the index to get the correct kicks for the rotation
	var index: int
	match current_rotation:
		0:
			index = 0 if direction==1 else 3
		1:
			index = 1 if direction==1 else 0
		2:
			index = 2 if direction==1 else 1
		3:
			index = 3 if direction==1 else 2
	
	var kick_list: Array = current_piece.wall_kicks[index]
	for i in kick_list:
		if can_move(direction * i, attempt_rotate):
			clear_piece()
			current_location += direction * i
			current_rotation = attempt_rotate
			draw_piece()
			return

## Checks the board for any full rows
func check_full_rows():
	var full_rows: Array[int] = []
	for i in range(rows):
		if cells_in_rows[i].size() == 10:
			full_rows.append(i)
	if full_rows.size() > 0:
		clear_rows(full_rows)

## Clears full rows and shifts the others downwards
func clear_rows(full_rows: Array[int]):
	var shift_amount: int = 0
	for i in range(full_rows[-1], 0, -1):
		if i in full_rows:
			shift_amount += 1
			for j in cells_in_rows[i]:
				$PlacedPieces.erase_cell(Vector2i(j,i))
		elif cells_in_rows[i].size() == 0:
			cells_in_rows[i+shift_amount] = cells_in_rows[i].duplicate()
			break
		else:
			for j in cells_in_rows[i]:
				$PlacedPieces.set_cell(Vector2i(j,i) + Vector2i(0, shift_amount), tileset_id, $PlacedPieces.get_cell_atlas_coords(Vector2i(j,i)))
				$PlacedPieces.erase_cell(Vector2i(j,i))
			cells_in_rows[i+shift_amount] = cells_in_rows[i].duplicate()

## Shuffles the possible pieces and appends them to the next_pieces array (7-Bag)
func shuffle_pieces():
	shuffle_array.shuffle()
	next_pieces.append_array(shuffle_array)

func _on_drop_piece_timer_timeout() -> void:
	move_piece(Vector2i.DOWN)
