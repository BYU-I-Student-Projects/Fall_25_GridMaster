class_name Card
extends Node2D

@export_node_path var btn1_path: NodePath = "Control/CardMoveButton"
@export_node_path var btn2_path: NodePath = "Control/CardActionButton"
@export_node_path var btn3_path: NodePath = "Control/CardResourceButton"

func _ready() -> void:
	var btn1 = get_node(btn1_path) as Button
	var btn2 = get_node(btn2_path) as Button
	var btn3 = get_node(btn3_path) as Button

	# Connect signals to instance methods
	btn1.pressed.connect(_on_button_action_1)
	btn2.pressed.connect(_on_button_action_2)
	btn3.pressed.connect(_on_button_action_3)

# Default handlers that subclasses can override
func _on_button_action_1() -> void:
	effect_one()

func _on_button_action_2() -> void:
	effect_two()

func _on_button_action_3() -> void:
	effect_three()

# "Virtual" action methods intended to be overridden
func effect_one() -> void:
	pass

func effect_two() -> void:
	pass

func effect_three() -> void:
	pass
