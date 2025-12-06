# CardBase.gd
class_name Card
extends Node2D

var card_id: String = ""

@export_node_path var btn1_path: NodePath = "Control/CardMoveButton"
@export_node_path var btn2_path: NodePath = "Control/CardActionButton"
@export_node_path var btn3_path: NodePath = "Control/CardResourceButton"

func _ready() -> void:
	GlobalSignal.connect("card_effect_finished", _test)
	var btn1 = get_node(btn1_path) as Button
	var btn2 = get_node(btn2_path) as Button
	var btn3 = get_node(btn3_path) as Button

	# Connect signals to instance methods
	if btn1: btn1.pressed.connect(_on_button_action_1)
	if btn2: btn2.pressed.connect(_on_button_action_2)
	if btn3: btn3.pressed.connect(_on_button_action_3)

func _on_button_action_1() -> void:
	effect_one()
	await GlobalSignal.card_function_finished
	GlobalSignal.emit_signal("card_effect_finished", self)

func _on_button_action_2() -> void:
	effect_two()
	await GlobalSignal.card_function_finished
	GlobalSignal.emit_signal("card_effect_finished", self)

func _on_button_action_3() -> void:
	effect_three()
	await GlobalSignal.card_function_finished
	GlobalSignal.emit_signal("card_effect_finished", self)

func effect_one():
	pass

func effect_two():
	pass

func effect_three():
	pass

func _test(card):
	if card == self:
		print("sent")
