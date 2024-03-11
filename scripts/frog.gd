extends Area2D
class_name Frog

signal hit
# only allow the user to launch the tongue once per animation
var tongue_animation_in_progress = false
var angle_to_target = 0
var tongue: Tongue = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	reset_rotation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation = rotate_toward(rotation, angle_to_target, 0.5)

func _input(event):
	if !GlobalState.paused:
		if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if tongue == null:
				load_tongue()
			if !tongue_animation_in_progress:
				tongue_animation_in_progress = true
				# get_angle_to get's the angle relative to the beginning position.
				# so since I want to start with a -90 degree offset I need to account for that
				angle_to_target = get_angle_to(event.position) - deg_to_rad(90)
				add_tongue(event.position)
				

func reset_rotation():
	angle_to_target = deg_to_rad(-90)

func _on_body_entered(_body):
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func _on_tongue_animation_done():
	tongue_animation_in_progress = false
	remove_tongue()
	reset_rotation()

func remove_tongue():
	tongue.set_physics_process(false)
	remove_child(tongue)
	
func add_tongue(pos):
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("default")
	tongue.set_physics_process(true)
	add_child(tongue)
	move_child(tongue, 0)
	tongue.set_target_position(pos)

func load_tongue():
	tongue = load("res://scenes/tongue.tscn").instantiate()
	tongue.set_start_pos(global_position)
	# manually add connection to signal
	tongue.animation_done.connect(Callable(_on_tongue_animation_done))
