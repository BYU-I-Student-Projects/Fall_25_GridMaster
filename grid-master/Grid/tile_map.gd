extends TileMap

var GridSizeX = 3
var GridSizeY = 6
var Dic = {}
var prev_tile = Vector2i(-1,-1)
var player1 = Vector2i(1, 4)
var player2 = Vector2i(1, 1)
var player_turn = 1
var can_move_1 = false
var can_move_2 = false
var move_range = 0


func _ready():
	GlobalSignal.connect("player_move", _on_player_move)
	GlobalSignal.connect("free_move", _external_move)
	
	#sets grass grid
	for x in GridSizeX:
		for y in GridSizeY:
			Dic[str(Vector2i(x,y))] = {
					"type" : "Grass"
			}
			set_cell(0, Vector2(x, y), 0, Vector2i(0,0), 0)
			
	#sets players
	set_cell(2, player1, 2, Vector2i(0,0), 0)
	set_cell(2, player2, 2, Vector2i(0,0), 0)
			
			
func _process(_delta) :
	var tile = get_relative_mouse_position()

	if prev_tile != tile:
		erase_cell(1, prev_tile)
	
	if Dic.has(str(tile)):
		set_cell(1, tile, 1, Vector2i(0, 0), 0)
		prev_tile = tile
		
		
func _on_player_move(playerID, dist):
	if playerID != 1:
		return
		
	can_move_1 = true
	move_range = dist
	print("Player %d may now move %d tile(s)" % [playerID, dist])
	
func _external_move(playerID, x, y):
	if playerID == 1:
		if ((player1 + Vector2i(x, y)).x < 0) or ((player1 + Vector2i(x, y)).x > 2):
			return
		if ((player1 + Vector2i(x, y)).y < 0) or ((player1 + Vector2i(x, y)).y > 5):
			return
		if ((player1 + Vector2i(x, y)) == player1) or ((player1 + Vector2i(x, y)) == player2):
			return
		erase_cell(2, player1)
		player1 += Vector2i(x, y)
		set_cell(2, player1, 2, Vector2i(0, 0), 0)
		print("Player moved to ", player1)
	if playerID == 2:
		if ((player2 + Vector2i(x, y)).x < 0) or ((player2 + Vector2i(x, y)).x > 2):
			return
		if ((player2 + Vector2i(x, y)).y < 0) or ((player2 + Vector2i(x, y)).y > 5):
			return
		if ((player2 + Vector2i(x, y)) == player1) or ((player2 + Vector2i(x, y)) == player2):
			return
		erase_cell(2, player2)
		player2 += Vector2i(x, y)
		set_cell(2, player2, 2, Vector2i(0, 0), 0)
		print("Player moved to ", player2)
	
	
func _input(event):
	if not can_move_1 and not can_move_2:
		return

	if event.is_action_pressed("LeftClick"):
		var tile = get_relative_mouse_position()
		if (tile == player1) or (tile == player2):
			return

		if not Dic.has(str(tile)):
			return

		var diff = tile - player1
		if max(abs(diff.x), abs(diff.y)) <= move_range:
			erase_cell(2, player1)
			player1 = tile
			set_cell(2, player1, 2, Vector2i(0, 0), 0)
			print("Player moved to ", player1)

			can_move_1 = false
		

func get_relative_mouse_position() -> Vector2i:
	var local_pos = to_local(get_viewport().get_mouse_position())
	local_pos /= scale
	return Vector2i(int(local_pos.x / tile_set.tile_size.x * scale.x), int(local_pos.y / tile_set.tile_size.y * scale.y))
