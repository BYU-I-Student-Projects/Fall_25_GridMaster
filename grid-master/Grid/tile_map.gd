extends TileMap

var GridSizeX = 3
var GridSizeY = 6
var Dic = {}
var objects = {}
var effects = {}
var prev_tile = Vector2i(-1,-1)
var player1 = Vector2i(1, 4)
var player2 = Vector2i(1, 1)
var player_turn = 1
var can_move = false
var move_range = 0
var valid_move_array = []
var selected_object_tile: Vector2i = Vector2i(-1, -1)
var allowed_object_ids: Array = []
var selected_object_range: int = 0
var current_object_spawn
var magnitude
var duration

func _ready():
	GlobalSignal.connect("player_move", _on_player_move)
	GlobalSignal.connect("free_move", _external_move)
	GlobalSignal.connect("spawn_object", _on_spawn_object)
	GlobalSignal.connect("spawn_effect_zone", _on_spawn_effect_zone)
	GlobalSignal.connect("move_at", _on_move_at)
	GlobalSignal.connect("object_move", _on_object_move)
	GlobalSignal.connect("relative_spawn_object", _on_relative_spawn_object)
	
	#sets grass grid
	for x in GridSizeX:
		for y in GridSizeY:
			Dic[str(Vector2i(x,y))] = {
					"type" : "Grass"
			}
			set_cell(0, Vector2(x, y), 0, Vector2i(0,0), 0)
	#sets players
	set_cell(3, player1, 2, Vector2i(0,0), 0)
	set_cell(3, player2, 3, Vector2i(0,0), 0)

func _process(_delta) :
	var tile = get_relative_mouse_position()

	if prev_tile != tile:
		erase_cell(1, prev_tile)
	
	if Dic.has(str(tile)):
		set_cell(1, tile, 1, Vector2i(0, 0), 0)
		prev_tile = tile

func get_range(tile, move_pattern):
	if (move_pattern == 1): #Move to any adjacent on immedate next tiles
		valid_move_array.append(tile + Vector2i(1, 0))
		valid_move_array.append(tile + Vector2i(-1, 0))
		valid_move_array.append(tile + Vector2i(0, 1))
		valid_move_array.append(tile + Vector2i(0, -1))
	if (move_pattern == 2): #Move to any corners on immedate next times
		valid_move_array.append(tile + Vector2i(1, 1))
		valid_move_array.append(tile + Vector2i(-1, 1))
		valid_move_array.append(tile + Vector2i(1, -1))
		valid_move_array.append(tile + Vector2i(-1, -1))
	if (move_pattern == 3): #Move to any of the immediate tiles
		valid_move_array.append(tile + Vector2i(1, 0))
		valid_move_array.append(tile + Vector2i(-1, 0))
		valid_move_array.append(tile + Vector2i(0, 1))
		valid_move_array.append(tile + Vector2i(0, -1))
		valid_move_array.append(tile + Vector2i(1, 1))
		valid_move_array.append(tile + Vector2i(-1, 1))
		valid_move_array.append(tile + Vector2i(-1, -1))
		valid_move_array.append(tile + Vector2i(1, -1))
	if (move_pattern == 4): #Move to any of the 3 immediately ahead tiles
		valid_move_array.append(tile + Vector2i(0, -1))
		valid_move_array.append(tile + Vector2i(1, -1))
		valid_move_array.append(tile + Vector2i(-1, -1))
	if (move_pattern == 5): #Move to any of the 3 immediately behind tiles
		valid_move_array.append(tile + Vector2i(0, 1))
		valid_move_array.append(tile + Vector2i(-1, 1))
		valid_move_array.append(tile + Vector2i(1, 1))
	if (move_pattern == 6): #Moves side to side
		valid_move_array.append(tile + Vector2i(1, 0))
		valid_move_array.append(tile + Vector2i(-1, 0))
	if (move_pattern == 7): #Moves forward or back
		valid_move_array.append(tile + Vector2i(0, 1))
		valid_move_array.append(tile + Vector2i(0, -1))
	if (move_pattern == 8): #Jumps 2 tiles in a cardinal direction
		valid_move_array.append(tile + Vector2i(2, 0))
		valid_move_array.append(tile + Vector2i(-2, 0))
		valid_move_array.append(tile + Vector2i(0, 2))
		valid_move_array.append(tile + Vector2i(0, -2))
		valid_move_array.append(tile + Vector2i(2, 2))
		valid_move_array.append(tile + Vector2i(-2, 2))
		valid_move_array.append(tile + Vector2i(-2, -2))
		valid_move_array.append(tile + Vector2i(2, -2))
	if (move_pattern == 9): #Knight movements
		valid_move_array.append(tile + Vector2i(1, 2))
		valid_move_array.append(tile + Vector2i(2, 1))
		valid_move_array.append(tile + Vector2i(-1, 2))
		valid_move_array.append(tile + Vector2i(-2, 1))
		valid_move_array.append(tile + Vector2i(1, -2))
		valid_move_array.append(tile + Vector2i(2, -1))
		valid_move_array.append(tile + Vector2i(-1, -2))
		valid_move_array.append(tile + Vector2i(-2, -1))

func _on_player_move(playerID, dist):
	if playerID != 1:
		return
	get_range(player1, dist)
	can_move = true
	for z in valid_move_array:
		if (z == player1) or (z == player2):
			pass
		elif (verify_in_bounds(z) and not objects.has(str(z))):
			set_cell(2, z, 1, Vector2(0, 0))

func verify_in_bounds(pos: Vector2i) -> bool:
	return (pos.x >= 0 and pos.x <= 2) and (pos.y >= 0 and pos.y <= 5)

func _on_spawn_object(object_name: String, ownership: int, position: Vector2i) -> void:
	if not verify_in_bounds(position):
		push_error("Spawn position %s out of bounds" % position)
		return
	if position == player1 or position == player2:
		push_error("Cannot spawn at player position %s" % position)
		return
	if objects.has(str(position)):
		push_error("Tile %s already occupied by %s" % [position, objects[str(position)]["type"]])
		return

	var script = Preload.object_registry.get(object_name)
	if script == null:
		push_error("Unknown object: %s" % object_name)
		return

	var instance = script.new()
	instance.ownership = ownership
	add_child(instance)

	objects[str(position)] = {
		"type": object_name,
		"ownership": ownership,
		"node": instance
	}

	if instance.tileID == -1:
		push_error("No tile ID mapped for %s" % object_name)
		return
	set_cell(3, position, instance.tileID, Vector2i(0,0), 0)

func _on_spawn_effect_zone(effect_name: String, position: Vector2i, magnitude: int = 1, duration: int = 2) -> void:
	if not verify_in_bounds(position):
		push_error("Spawn position %s out of bounds" % position)
		return
	var script = Preload.object_registry.get(effect_name)
	if script == null:
		push_error("Unknown effect: %s" % effect_name)
		return
	var instance = script.new()
	if instance != null and instance is Object:
		add_child(instance)
		if not effects.has(str(position)):
			effects[str(position)] = []
		effects[str(position)].append({
			"type": effect_name,
			"magnitude": magnitude,
			"node": instance,
			"duration": duration
		})
		if instance.tileID != -1:
			set_cell(4, position, instance.tileID, Vector2i(0,0), 0)

func _external_move(playerID, x, y):
	if playerID == 1:
		if not verify_in_bounds(player1 + Vector2i(x, y)):
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
		if not verify_in_bounds(player2 + Vector2i(x, y)):
			return
		if ((player2 + Vector2i(x, y)) == player1) or ((player2 + Vector2i(x, y)) == player2):
			return
		erase_cell(3, player2)
		player2 += Vector2i(x, y)
		set_cell(3, player2, 3, Vector2i(0, 0), 0)
		print("Player moved to ", player2)

func _on_move_at(x: int, y: int, dX: int, dY: int) -> void:
	move_object_at(Vector2i(x, y), dX, dY)

func move_object_at(tile: Vector2i, dX: int, dY: int) -> void:
	var key = str(tile)
	if not objects.has(key):
		push_error("No object at %s" % tile)
		return
	var entry = objects[key]
	var instance = entry["node"]
	var new_tile = tile + Vector2i(dX, dY)
	if not verify_in_bounds(new_tile):
		push_error("New position %s out of bounds" % new_tile)
		return
	if new_tile == player1 or new_tile == player2:
		push_error("Cannot move into player position %s" % new_tile)
		return
	if objects.has(str(new_tile)):
		push_error("Tile %s already occupied by %s" % [new_tile, objects[str(new_tile)]["type"]])
		return
	erase_cell(3, tile)
	objects.erase(key)
	objects[str(new_tile)] = {
		"type": entry["type"],
		"ownership": entry["ownership"],
		"node": instance
	}
	if instance.tileID != -1:
		set_cell(3, new_tile, instance.tileID, Vector2i(0,0), 0)
		print("Moved %s from %s to %s" % [entry["type"], tile, new_tile])

func _input(event):
	if not event.is_action_pressed("LeftClick"):
		return
	var tile = get_relative_mouse_position()
	if can_move:
		if tile in valid_move_array:
			if objects.has(str(tile)):
				push_error("Tile %s occupied by %s" % [tile, objects[str(tile)]["type"]])
				return
			erase_cell(3, player1)
			player1 = tile
			set_cell(3, player1, 2, Vector2i(0, 0), 0)
			for z in valid_move_array: erase_cell(2, z)
			valid_move_array.clear()
			can_move = false
		return
	if allowed_object_ids.size() > 0:
		if selected_object_tile == Vector2i(-1, -1):
			if is_tile_selectable(tile, allowed_object_ids):
				for z in valid_move_array:
					erase_cell(2, z)
				valid_move_array.clear()
				selected_object_tile = tile
				get_range(tile, selected_object_range)
				for z in valid_move_array:
					if verify_in_bounds(z) and not objects.has(str(z)) and z != player1 and z != player2:
						set_cell(2, z, 1, Vector2i(0, 0))
				erase_cell(2, tile)
		elif tile in valid_move_array:
			move_object_at(selected_object_tile, tile.x - selected_object_tile.x, tile.y - selected_object_tile.y)
			for z in valid_move_array: erase_cell(2, z)
			valid_move_array.clear()
			selected_object_tile = Vector2i(-1, -1)
			allowed_object_ids.clear()
	elif current_object_spawn != "" and tile in valid_move_array:				#Here///////////////
		if (current_object_spawn == "wall"):
			_on_spawn_object(current_object_spawn, 0, tile)
		else:
			_on_spawn_effect_zone(current_object_spawn, tile, magnitude, duration)
		for z in valid_move_array: erase_cell(2, z)
		valid_move_array.clear()
		current_object_spawn = ""
		magnitude = 0
		duration = 0
		return


func _on_object_move(objectIDs: Array, move_pattern: int) -> void:
	allowed_object_ids = objectIDs.duplicate()
	selected_object_tile = Vector2i(-1, -1)
	selected_object_range = move_pattern
	valid_move_array.clear()
	for key in objects.keys():
		var tile = Vector2i(key.split(",")[0].to_int(), key.split(",")[1].to_int())
		if is_tile_selectable(tile, allowed_object_ids):
			set_cell(2, tile, 1, Vector2i(0, 0))

func _on_relative_spawn_object(objectID: String, playerID: int, move_pattern: int, damage: int = 0, time: int = 0) -> void:
	valid_move_array.clear()
	current_object_spawn = objectID
	magnitude = damage
	duration = time
	if playerID == 1:
		get_range(player1, move_pattern)
		for tile in valid_move_array:
			if verify_in_bounds(tile) and not objects.has(str(tile)) and tile != player1 and tile != player2:
				set_cell(2, tile, 1, Vector2i(0,0))

func is_tile_selectable(tile: Vector2i, allowed_ids: Array) -> bool:
	if tile == player1 and 1 in allowed_ids:
		return true
	if tile == player2 and 2 in allowed_ids:
		return true
	var key = str(tile)
	if objects.has(key):
		var entry = objects[key]
		var ownership = entry["ownership"]
		var id = ownership + 10
		if id in allowed_ids:
			return true
	return false

func get_relative_mouse_position() -> Vector2i:
	var local_pos = to_local(get_viewport().get_mouse_position())
	local_pos /= scale
	return Vector2i(int(local_pos.x / tile_set.tile_size.x * scale.x), int(local_pos.y / tile_set.tile_size.y * scale.y))
