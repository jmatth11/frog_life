class_name Main
extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$MobTimer.start()
	
func _input(event):
	GlobalState.common_input_handler(get_tree().root, event)

func random_movement(spawn_location, sprite, rot=0.0):
	spawn_location.progress_ratio = randf()
	var direction = spawn_location.rotation + PI/2
	sprite.position = spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	sprite.rotation = direction + rot
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	sprite.velocity = velocity.rotated(direction)
	
func _on_mob_timer_timeout():
	var fly = mob_scene.instantiate()
	var spawn_location = get_node("MobPath/MobSpawnPath")
	random_movement(spawn_location, fly)
	add_child(fly)
