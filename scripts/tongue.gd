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

func set_start_pos(pos: Vector2):
	home_position = pos
	target_position = pos

func _physics_process(_delta):
	# check if position has been reached or not
	var pos_dif = (global_position - target_position).length()
	var direction = global_position.direction_to(target_position) * SPEED
	
	# 10 seems to be a good threshold for the tongue not to bug out
	if pos_dif > 10:
		action_done = false
		velocity = direction
	else:
		# if we are not at the home position, return home after reaching target
		if target_position != home_position:
			target_position = home_position
		elif !action_done:
			tongue_action_done()
		velocity = Vector2.ZERO
	if move_and_slide():
		handle_target_collision()

func handle_target_collision():
	# to prevent bugging out return home once collision happens
	target_position = home_position
	var collision = get_last_slide_collision()
	var target = collision.get_collider()
	if target is Fly:
		target.capture(self)
		targets_to_dispose.push_back(target)
		
func tongue_action_done():
	# we have returned home at this point so emit animation done signal
	action_done = true
	if not targets_to_dispose.is_empty():
		for index in targets_to_dispose.size():
			var obj = targets_to_dispose[index]
			if obj != null:
				obj.queue_free()
		GlobalState.update_score.emit(targets_to_dispose.size())
		targets_to_dispose.clear()
	animation_done.emit()
