class_name Fish
extends CharacterBody2D

func common():
	$AnimatedSprite2D.play("common")
	
func clown():
	$AnimatedSprite2D.play("clown")

func _physics_process(_delta):
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
