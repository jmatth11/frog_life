extends Node

var current_scene = null
# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(res_path) -> void:
	call_deferred("_deferred_scene_switch", res_path)
	
func _deferred_scene_switch(res_path) -> void:
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
