class_name Deck
extends Node2D

# This is the master list of all cards in the correct order/set.
var player_deck = ["card_atk", "card_atk", "card_atk", "card_atk", "card_atk", "card_atk"]
# This array will act as your active draw pile.
var draw_pile_one: Array = []
var draw_pile_two: Array = []

#this will be used to load and call cards
var card_registry = {}

func _ready() -> void:
	draw_pile_one = player_deck.duplicate() # This duplicates the player deck
	draw_pile_one.shuffle() # This shuffles the draw pile
	draw_pile_two = player_deck.duplicate()
	draw_pile_two.shuffle()
	 
	card_registry = load_card_classes("res://Card/Card_Sence/")
	print(card_registry)

func load_card_classes(path: String) -> Dictionary:
	var registry = {}
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				registry.merge(load_card_classes(path + "/" + file_name))
			elif file_name.ends_with(".tscn"):
				var full_path = path + "/" + file_name
				var card_scene_resource = load(full_path) 
				if card_scene_resource:
					registry[file_name.get_basename()] = card_scene_resource
			file_name = dir.get_next()
		dir.list_dir_end()
	return registry

func draw_card(player):
	if player == 1:
		if draw_pile_one.is_empty():
			print("deck is empty")
			GlobalSignal.emit_signal("deck_is_empty")
			print("Continue")
		
			var drawn_card = draw_pile_one.pop_front()
			print("You drew: ", drawn_card)
			print("Cards remaining in pile: ", draw_pile_one)
			return drawn_card
		
		else:
			var drawn_card = draw_pile_one.pop_front()
		
			print("You drew: ", drawn_card)
			print("Cards remaining in pile: ", draw_pile_one)
		
			return drawn_card
			
	if player == 2:
		if draw_pile_two.is_empty():
			print("deck is empty")
			GlobalSignal.emit_signal("deck_is_empty")
			print("Continue")
		
			var drawn_card = draw_pile_two.pop_front()
			print("You drew: ", drawn_card)
			print("Cards remaining in pile: ", draw_pile_two)
			return drawn_card
		
		else:
			var drawn_card = draw_pile_two.pop_front()
		
			print("You drew: ", drawn_card)
			print("Cards remaining in pile: ", draw_pile_two)
		
			return drawn_card

func deck_is_empty(discard_pile, player):
	print("draw pile recieved")
	if player == 1:
		draw_pile_one = discard_pile
		draw_pile_one.shuffle()
	if player == 2:
		draw_pile_two = discard_pile
		draw_pile_two.shuffle()
	

func get_card_paths_for_deck(deck_id: int):
	var q = SupabaseQuery.new()
	q.from("CardsInDeck").select(["quantity", "Cards(path)"]).eq("deck_id", str(deck_id))
	var task = Supabase.database.query(q)
	task.completed.connect(Callable(self, "_on_cards_query_completed"))


func _on_cards_query_completed(task):
	if task.error:
		print("Error: %s" % task.error.message)
		return
	var paths: Array = []
	for row in task.data:
		var card_rel = row.get("Cards", row.get("cards", null))
		if card_rel == null:
			continue
		var path = card_rel.get("path", null)
		var qty = int(row.get("quantity", 0))
		for i in range(qty):
			paths.append(path)
	player_deck = paths
	print("Deck paths: ", player_deck)
