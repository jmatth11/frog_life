extends CanvasLayer

func _on_resume_pressed():
	GlobalState.paused = false
	queue_free()

func _on_quit_pressed():
	GlobalState.return_to_main_menu()
	queue_free()
