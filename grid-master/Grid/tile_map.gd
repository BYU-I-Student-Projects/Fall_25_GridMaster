extends TileMap

var GridSizeX = 3
var GridSizeY = 6
var Dic = {}
var prev_tile = Vector2i(-1,-1)
var player1 = Vector2i(2, 4)
var player2 = Vector2i(2, 0)
var player_turn = 1
var can_move = false
var move_range = 0


func _ready():
	GlobalSignal.connect("player_move", _on_player_move)
	
	#sets grass grid
	for x in GridSizeX:
		for y in GridSizeY:
			Dic[str(Vector2i(x,y))] = {
					"type" : "Grass"
			}
			set_cell(0, Vector2(x, y), 0, Vector2i(0,0), 0)
			
	#sets players
	set_cell(2, player1, 2, Vector2i(0,0), 0)
			
			
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
		
	can_move = true
	move_range = dist
	print("Player %d may now move %d tile(s)" % [playerID, dist])
	
func _input(event):
	if not can_move:
		return

	if event.is_action_pressed("LeftClick"):
		var tile = Vector2i(local_to_map(get_global_mouse_position()))

		if not Dic.has(str(tile)):
			return

		var diff = tile - player1
		if max(abs(diff.x), abs(diff.y)) <= move_range and (diff.x != 0 or diff.y != 0):
			erase_cell(2, player1)
			player1 = tile
			set_cell(2, player1, 2, Vector2i(0, 0), 0)
			print("Player moved to ", player1)

			can_move = false
		

func get_relative_mouse_position() -> Vector2i:
	var local_pos = to_local(get_viewport().get_mouse_position())
	local_pos /= scale
	return Vector2i(int(local_pos.x / tile_set.tile_size.x * scale.x), int(local_pos.y / tile_set.tile_size.y * scale.y))
