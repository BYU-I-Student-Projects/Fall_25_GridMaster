class_name Deck
extends Node2D

# This is the master list of all cards in the correct order/set.
var player_deck = ["card_atk", "card_atk", "card_atk", "card_atk", "card_atk", "card_atk"]

# This array will act as your active draw pile.
var draw_pile: Array = []

#this will be used to load and call cards
var card_registry = {}

func _ready() -> void:
	draw_pile = player_deck.duplicate() # This duplicates the player deck
	draw_pile.shuffle() # This shuffles the draw pile
	print("Original master deck (untouched): ", player_deck)
	print("Shuffled draw pile: ", draw_pile)
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




func draw_card():
	if draw_pile.is_empty():
		print("deck is empty")
		GlobalSignal.emit_signal("deck_is_empty")
		print("Continue")
		
		var drawn_card = draw_pile.pop_front()
		print("You drew: ", drawn_card)
		print("Cards remaining in pile: ", draw_pile)
		return drawn_card
	
	else:
		var drawn_card = draw_pile.pop_front()
		
		print("You drew: ", drawn_card)
		print("Cards remaining in pile: ", draw_pile)
		
		return drawn_card

func deck_is_empty(discard_pile):
	print("draw pile recieved")
	draw_pile = discard_pile
	draw_pile.shuffle()
	
