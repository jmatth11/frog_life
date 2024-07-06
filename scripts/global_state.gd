extends Node

var paused: bool = false
var game_started: bool = false
var current_level: int = 1

signal update_score

# extract out default values to a reset function
func start_game():
	game_started = true
	paused = false
	SceneManager.switch_scene("res://scenes/main.tscn")
	
func return_to_main_menu():
	game_started = false
	paused = false
	SceneManager.switch_scene("res://scenes/start_menu.tscn")

func set_pause_game(root, flag):
	paused = flag
	if root.has_node("StartMenu"):
		return
	
	if flag:
		if !root.has_node("EscapeMenu"):
			paused = true
			var escape_menu = load("res://scenes/escape_menu.tscn").instantiate()
			root.add_child(escape_menu)
			root.move_child(escape_menu, 0)
	else:
		if root.has_node("EscapeMenu"):
			var escape_menu = root.get_node("EscapeMenu")
			escape_menu.queue_free()
			paused = false
			
func common_input_handler(root, event):
	if event is InputEventKey:
		if event.is_action_pressed("EscapeMenu"):
			set_pause_game(root, !paused)
