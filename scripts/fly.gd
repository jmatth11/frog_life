extends RigidBody2D
class_name Fly

var captured = false
var delegate: Tongue

# Called when the node enters the scene tree for the first time.
func _ready():
	captured = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if captured:
		linear_velocity = delegate.velocity

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
