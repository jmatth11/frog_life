extends CharacterBody2D
class_name Tongue

# create signal to notify when animation is done
signal animation_done

@export var SPEED = 1000.0
# keep track of home position and the currect target position
var home_position = Vector2.ZERO
var target_position = Vector2.ZERO
var action_done = true
var targets_to_dispose: Array[Fly]
var current_trail: Trail

func set_start_pos(pos: Vector2):
	home_position = pos
	target_position = pos
	
func remove_current_trail():
	if current_trail:
		current_trail.stop()
		current_trail = null
	
func set_target_position(pos):
	target_position = pos
	remove_current_trail()
	current_trail = Trail.create()
	add_child(current_trail)
	
func back_to_home():
	target_position = home_position
	current_trail.reverse = true

func get_shape() -> Shape2D:
	return $CollisionShape2D.shape

func parent_rotation() -> float:
	return get_parent().rotation

func _physics_process(_delta):
	# check if position has been reached or not
	var pos_dif = (global_position - target_position).length()
	var direction = global_position.direction_to(target_position) * SPEED
	
	# 10 seems to be a good threshold for the tongue not to bug out
	if pos_dif > 10:
		action_done = false
		# try something with incrementing the size to emulate growing the tongue
		velocity = direction
	else:
		# if we are not at the home position, return home after reaching target
		if target_position != home_position:
			back_to_home()
		elif !action_done:
			tongue_action_done()
		velocity = Vector2.ZERO
	if is_physics_processing() && move_and_slide():
		handle_target_collision()

func handle_target_collision():
	# to prevent bugging out return home once collision happens
	back_to_home()
	var collision = get_last_slide_collision()
	var target = collision.get_collider()
	if target is Fly:
		target.capture(self)
		targets_to_dispose.push_back(target)
		
func tongue_action_done():
	# we have returned home at this point so emit animation done signal
	action_done = true
	remove_current_trail()
	if not targets_to_dispose.is_empty():
		for index in targets_to_dispose.size():
			var obj = targets_to_dispose[index]
			if obj != null:
				obj.queue_free()
		GlobalState.update_score.emit(targets_to_dispose.size())
		targets_to_dispose.clear()
	animation_done.emit()
