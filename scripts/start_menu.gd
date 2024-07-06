extends CanvasLayer
class_name StartMenu

func _on_button_pressed():
	GlobalState.start_game()

func _on_quit_pressed():
	get_tree().quit()
