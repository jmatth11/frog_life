extends CanvasLayer

func _on_quit_button_pressed():
	GlobalState.return_to_main_menu()
	queue_free()


func _on_resume_button_pressed():
	GlobalState.paused = false
	queue_free()
