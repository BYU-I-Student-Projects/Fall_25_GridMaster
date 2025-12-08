extends Node

var object_registry = {}

func _ready():
	object_registry = load_object_classes("res://Object")

func load_object_classes(path: String) -> Dictionary:
	var registry = {}
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				registry.merge(load_object_classes(path + "/" + file_name))
			elif file_name.ends_with(".gd"):
				var full_path = path + "/" + file_name
				var script = load(full_path)
				if script:
					registry[file_name.get_basename()] = script
					var dummy = script.new()
					dummy.free()
			file_name = dir.get_next()
		dir.list_dir_end()
	return registry
