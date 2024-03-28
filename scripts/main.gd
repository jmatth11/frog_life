class_name Main
extends Node

@export var mob_scene: PackedScene

var levelPath = "res://scenes/levels/level_%d.tscn"
var current_level: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$MobTimer.start()
	
func _input(event):
	GlobalState.common_input_handler(get_tree().root, event)

func load_level(idx: int):
	var lvl = load(levelPath % idx) as PackedScene
	current_level = lvl.instantiate()
	current_level.target_position = $Player.global_position
	add_child(current_level)

func random_movement(spawn_location, sprite, rot=0.0):
	spawn_location.progress_ratio = randf()
	var direction = spawn_location.rotation + PI/2
	sprite.position = spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	sprite.rotation = direction + rot
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	sprite.velocity = velocity.rotated(direction)
	
func follow_path(sprite):
	current_level.add_fly(sprite)
	
func _on_mob_timer_timeout():
	var fly = mob_scene.instantiate()
	follow_path(fly)
