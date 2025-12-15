extends Control

# This script is attached to the MainMenu Control node.

# IMPORTANT: Before running, make sure you have a game scene saved 
# in your project, e.g., "res://game_level.tscn".

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main Menu loaded successfully.")

# Function connected to the "Play Game" button.
func _on_PlayButton_pressed():
	print("Play button pressed. Loading game scene...")
	# === SCENE TRANSITION CODE UPDATED FOR Grid_Master.tscn ===
	var next_scene_path = "res://Grid/Grid_Sence/Grid_Master.tscn"
	
	if FileAccess.file_exists(next_scene_path):
		# This line tells Godot to load and switch to your game scene!
		get_tree().change_scene_to_file(next_scene_path)
	else:
		# Important: This will show an error if you haven't created your Grid_Master.tscn yet!
		print("ERROR: Could not find the game scene at path: " + next_scene_path)

# Function connected to the "Sign In" button.
func _on_SignInButton_pressed():
	print("Sign In button pressed. Opening sign in menu...")
	get_tree().change_scene_to_file("res://Login/Login_menu.tscn")
	
# Function connected to the "Leaderboards" button.
func _on_LeaderboardsButton_pressed():
	print("Leaderboards button pressed. Fetching data...")
	# TODO: Add logic to fetch and display the leaderboard data.
