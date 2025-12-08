extends Control

var username = ""
var password_hash = ""
var created = false
var awaiting_test = false

var firebase_scene = preload("res://addons/godot-firebase/firebase/Firebase.tscn")
var firebase_node

func _ready():
	firebase_node = firebase_scene.instantiate()
	add_child(firebase_node)

	# Connect Firebase Auth signals
	firebase_node.Auth.login_succeeded.connect(_on_google_login_success)
	firebase_node.Auth.login_failed.connect(_on_google_login_fail)

func _on_login_button_down() -> void:
	if !created:
		# First step: create account
		username = $Username.text
		password_hash = $Password.text.sha256_text()
		created = true
		awaiting_test = true
		$Login.text = "Test Login"
		$Username.text = ""
		$Password.text = ""
		print("Account Created! Please re-enter credentials to confirm.")
	else:
		if awaiting_test:
			# Second step: test login
			if $Username.text == username and $Password.text.sha256_text() == password_hash:
				print("Account confirmed! Redirecting to game...")
				awaiting_test = false
				$Login.text = "Login"
				$Username.text = ""
				$Password.text = ""
				get_tree().change_scene_to_file("res://Grid/Grid_Sence/Grid_Master.tscn")
			else:
				print("Error: credentials do not match. Try again.")
				$Username.text = ""
				$Password.text = ""
		else:
			# Normal login after confirmation
			if $Username.text == username and $Password.text.sha256_text() == password_hash:
				print("Login Success! Redirecting to game...")
				get_tree().change_scene_to_file("res://Grid/Grid_Sence/Grid_Master.tscn")
			else:
				print("Login Fail!")

func _on_google_pressed() -> void:
	var provider: AuthProvider = firebase_node.Auth.get_GoogleProvider()
	firebase_node.Auth.get_auth_with_redirect(provider)

func _on_google_login_success(auth_result: Dictionary) -> void:
	print("Google Login Success! Redirecting to game...")
	get_tree().change_scene_to_file("res://Grid/Grid_Sence/Grid_Master.tscn")

func _on_google_login_fail(error: Dictionary) -> void:
	print("Google Login Failed: " + str(error))
