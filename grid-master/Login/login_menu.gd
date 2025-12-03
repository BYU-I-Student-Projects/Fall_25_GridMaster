extends Control

var username = ""
var password_hash = ""
var created = false

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
		username = $Username.text
		password_hash = $Password.text.sha256_text()
		created = true
		$Login.text = "Login"
		$Username.text = ""
		$Password.text = ""
		$StatusLabel.text = "Account Created!"
	else:
		if $Username.text == username and $Password.text.sha256_text() == password_hash:
			$StatusLabel.text = "Login Success!"
			get_tree().change_scene_to_file("res://Grid/Grid_Scene/Grid_Master.tscn")
		else:
			$StatusLabel.text = "Login Fail!"

func _on_google_pressed() -> void:
	var provider: AuthProvider = firebase_node.Auth.get_GoogleProvider()
	firebase_node.Auth.get_auth_with_redirect(provider)

# Called when Google login succeeds
func _on_google_login_success(auth_result: Dictionary) -> void:
	$StatusLabel.text = "Google Login Success!"
	get_tree().change_scene_to_file("res://Grid/Grid_Scene/Grid_Master.tscn")

# Called when Google login fails
func _on_google_login_fail(error: Dictionary) -> void:
	$StatusLabel.text = "Google Login Failed: " + str(error)
