extends CharacterBody2D
class_name Fly

var captured = false

# Called when the node enters the scene tree for the first time.
func _ready():
	captured = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide()

func capture(tongue: Tongue):
	disable_collision()
	velocity = Vector2.ZERO
	captured = true
	# reparent tongue so we follow to the tongue back to the home position
	reparent(tongue)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func disable_collision():
	# turn collision off
	set_collision_layer_value(3, false)
