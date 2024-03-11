extends Node

@export var mob_scene: PackedScene
@export var fish_scene: PackedScene
var rng = RandomNumberGenerator.new()
var commonFishTime = Timer.new()
var clownFishTime = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	commonFishTime.timeout.connect(spawn_common_fish)
	clownFishTime.timeout.connect(spawn_clown_fish)
	add_child(commonFishTime)
	add_child(clownFishTime)
	reset_clown_timer()
	reset_common_timer()
	commonFishTime.start()
	clownFishTime.start()
	#pass # Replace with function body.
	$MobTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	GlobalState.common_input_handler(get_tree().root, event)

func reset_common_timer():
	commonFishTime.set_wait_time(rng.randf_range(1,3))
	
func reset_clown_timer():
	clownFishTime.set_wait_time(rng.randf_range(5,10))

func spawn_common_fish():
	var fish = fish_scene.instantiate() as Fish
	fish.common()
	var spawn_loc = get_node("FishPath/FishSpawnPath")
	random_movement(spawn_loc, fish, 1.5)
	add_child(fish)
	reset_common_timer()

func spawn_clown_fish():
	var fish = fish_scene.instantiate() as Fish
	fish.clown()
	var spawn_loc = get_node("FishPath/FishSpawnPath")
	random_movement(spawn_loc, fish, 1.5)
	add_child(fish)
	reset_clown_timer()

func random_movement(spawn_location, sprite, rot=0):
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
