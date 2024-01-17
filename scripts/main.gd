extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	$MobTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	var fly = mob_scene.instantiate()
	var spawn_location = get_node("MobPath/MobSpawnPath")
	spawn_location.progress_ratio = randf()
	var direction = spawn_location.rotation + PI/2
	fly.position = spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	fly.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	fly.linear_velocity = velocity.rotated(direction)
	add_child(fly)
