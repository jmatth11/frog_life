extends Area2D
class_name Frog

signal hit
signal fly_points
# only allow the user to launch the tongue once per animation
var tongue_animation_in_progress = false
var angle_to_target = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_rotation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation = rotate_toward(rotation, angle_to_target, 0.5)

func _input(event):
	if !GlobalState.paused:
		if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if !tongue_animation_in_progress:
				tongue_animation_in_progress = true
				$Tongue.target_position = event.position
				# get_angle_to get's the angle relative to the beginning position.
				# so since I want to start with a -90 degree offset I need to account for that
				angle_to_target = get_angle_to(event.position) - deg_to_rad(90)

func reset_rotation():
	angle_to_target = deg_to_rad(-90)

func _on_body_entered(_body):
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func _on_tongue_animation_done():
	tongue_animation_in_progress = false
	reset_rotation()

func _on_tongue_fly_caught(num):
	fly_points.emit(num)
