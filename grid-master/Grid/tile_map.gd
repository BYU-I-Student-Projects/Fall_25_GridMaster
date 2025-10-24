extends TileMap

var GridSizeX = 5
var GridSizeY = 5
var Dic = {}
var prev_tile = Vector2i(-1,-1)
var player1 = Vector2i(2, 4)
var player2 = Vector2i(2, 0)
var player_turn = 1


func _ready():
	
	#sets grass grid
	for x in GridSizeX:
		for y in GridSizeY:
			Dic[str(Vector2i(x,y))] = {
					"type" : "Grass"
			}
			set_cell(0, Vector2(x, y), 0, Vector2i(0,0), 0)
			
	#sets players
	set_cell(2, player1, 2, Vector2i(0,0), 0)
	
	#connects move_player to card actions
	PlayerAddValue.connect("move_player", self.move_player)
			
			
func _process(_delta) :
	var tile = local_to_map(get_global_mouse_position())
	var _selectedTile = map_to_local(tile)
	
	if prev_tile != tile:
		erase_cell(1, prev_tile)
		
	if Dic.has(str(tile)):
		set_cell(1, tile, 1, Vector2i(0, 0), 0)
		prev_tile = tile
		
		
func _input(event):
	#mouse location
	var tile = local_to_map(get_global_mouse_position())
	
	#move character if left mouse is clicked
	if event.is_action_pressed("LeftClick") and Dic.has(str(tile)):
		erase_cell(2, player1)
		player1 = Vector2i(tile)
		set_cell(2, player1, 2, Vector2i(0,0), 0)
		
func move_player(moving_tile):
	display_valid_moves(player1, moving_tile)
	
	if event.is_action_pressed("LeftClick") and valid_move():
		erase_cell(2, player1)
		player1 = Vector2i(tile)
		set_cell(2, player1, 2, Vector2i(0,0), 0)


func display_valid_move(player1: Vector2i, moving_tile: int) -> void:
	for x in range(GridSizeX):
		for y in range(GridSizeY):
			if (
				player1.x - moving_tile <= x and x <= player1.x + moving_tile
				and player1.y - moving_tile <= y and y <= player1.y + moving_tile
			):
				set_cell(3, Vector2i(x, y), 3, Vector2i(0, 0), 0)
			else:
				set_cell(4, Vector2i(x, y), 3, Vector2i(0, 0), 0)
