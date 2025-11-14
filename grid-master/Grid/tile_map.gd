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
var valid_move_array = []


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
	set_cell(3, player1, 2, Vector2i(0,0), 0)
	set_cell(3, player2, 2, Vector2i(0,0), 0)
			
			
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
	if (dist == 1): #Move to any adjacent on immedate next tiles
		valid_move_array.append(player1 + Vector2i(1, 0))
		valid_move_array.append(player1 + Vector2i(-1, 0))
		valid_move_array.append(player1 + Vector2i(0, 1))
		valid_move_array.append(player1 + Vector2i(0, -1))
	if (dist == 2): #Move to any corners on immedate next times
		valid_move_array.append(player1 + Vector2i(1, 1))
		valid_move_array.append(player1 + Vector2i(-1, 1))
		valid_move_array.append(player1 + Vector2i(1, -1))
		valid_move_array.append(player1 + Vector2i(-1, -1))
	if (dist == 3): #Move to any of the immediate tiles
		valid_move_array.append(player1 + Vector2i(1, 0))
		valid_move_array.append(player1 + Vector2i(-1, 0))
		valid_move_array.append(player1 + Vector2i(0, 1))
		valid_move_array.append(player1 + Vector2i(0, -1))
		valid_move_array.append(player1 + Vector2i(1, 1))
		valid_move_array.append(player1 + Vector2i(-1, 1))
		valid_move_array.append(player1 + Vector2i(-1, -1))
		valid_move_array.append(player1 + Vector2i(1, -1))
	if (dist == 4): #Move to any of the 3 immediately ahead tiles
		valid_move_array.append(player1 + Vector2i(0, -1))
		valid_move_array.append(player1 + Vector2i(1, -1))
		valid_move_array.append(player1 + Vector2i(-1, -1))
	if (dist == 5): #Move to any of the 3 immediately behind tiles
		valid_move_array.append(player1 + Vector2i(0, 1))
		valid_move_array.append(player1 + Vector2i(-1, 1))
		valid_move_array.append(player1 + Vector2i(1, 1))
	if (dist == 6): #Moves side to side
		valid_move_array.append(player1 + Vector2i(1, 0))
		valid_move_array.append(player1 + Vector2i(-1, 0))
	if (dist == 7): #Moves forward or back
		valid_move_array.append(player1 + Vector2i(0, 1))
		valid_move_array.append(player1 + Vector2i(0, -1))
	if (dist == 8): #Jumps 2 tiles in a cardinal direction
		valid_move_array.append(player1 + Vector2i(2, 0))
		valid_move_array.append(player1 + Vector2i(-2, 0))
		valid_move_array.append(player1 + Vector2i(0, 2))
		valid_move_array.append(player1 + Vector2i(0, -2))
		valid_move_array.append(player1 + Vector2i(2, 2))
		valid_move_array.append(player1 + Vector2i(-2, 2))
		valid_move_array.append(player1 + Vector2i(-2, -2))
		valid_move_array.append(player1 + Vector2i(2, -2))
	if (dist == 9): #Knight movements
		valid_move_array.append(player1 + Vector2i(1, 2))
		valid_move_array.append(player1 + Vector2i(2, 1))
		valid_move_array.append(player1 + Vector2i(-1, 2))
		valid_move_array.append(player1 + Vector2i(-2, 1))
		valid_move_array.append(player1 + Vector2i(1, -2))
		valid_move_array.append(player1 + Vector2i(2, -1))
		valid_move_array.append(player1 + Vector2i(-1, -2))
		valid_move_array.append(player1 + Vector2i(-2, -1))
	can_move_1 = true
	for z in valid_move_array:
		if (z.x < 0) or (z.x > 2):
			1 == 1 
		elif (z.y < 0) or (z.y > 5):
			1 == 1 
		elif (z == player1) or (z == player2):
			1 == 1 
		else:
			set_cell(2, z, 1, Vector2(0, 0)) 

func _external_move(playerID, x, y):
	if playerID == 1:
		if ((player1 + Vector2i(x, y)).x < 0) or ((player1 + Vector2i(x, y)).x > 2):
			return
		if ((player1 + Vector2i(x, y)).y < 0) or ((player1 + Vector2i(x, y)).y > 5):
			return
		if ((player1 + Vector2i(x, y)) == player1) or ((player1 + Vector2i(x, y)) == player2):
			return
		erase_cell(3, player1)
		player1 += Vector2i(x, y)
		set_cell(3, player1, 2, Vector2i(0, 0), 0)
		print("Player moved to ", player1)
		for z in valid_move_array:
			erase_cell(2, z) 

	if playerID == 2:
		if ((player2 + Vector2i(x, y)).x < 0) or ((player2 + Vector2i(x, y)).x > 2):
			return
		if ((player2 + Vector2i(x, y)).y < 0) or ((player2 + Vector2i(x, y)).y > 5):
			return
		if ((player2 + Vector2i(x, y)) == player1) or ((player2 + Vector2i(x, y)) == player2):
			return
		erase_cell(3, player2)
		player2 += Vector2i(x, y)
		set_cell(3, player2, 2, Vector2i(0, 0), 0)
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
			
		if tile in valid_move_array:
			erase_cell(3, player1)
			player1 = tile
			set_cell(3, player1, 2, Vector2i(0, 0), 0)
			print("Player moved to ", player1)
			for z in valid_move_array:
				erase_cell(2, z) 
			valid_move_array = []
			can_move_1 = false
		

func get_relative_mouse_position() -> Vector2i:
	var local_pos = to_local(get_viewport().get_mouse_position())
	local_pos /= scale
	return Vector2i(int(local_pos.x / tile_set.tile_size.x * scale.x), int(local_pos.y / tile_set.tile_size.y * scale.y))
