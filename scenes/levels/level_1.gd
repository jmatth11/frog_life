extends Node2D

@export var speed = 300
var target_position = Vector2.ZERO
var path_count = 2

func add_fly(sprite:Node2D):
	LevelHelpers.add_fly(sprite, path_count, self, get_node)

func map_paths(cb: Callable, opts: Dictionary):
	for i in path_count:
		var p: PathFollow2D = get_node("Path%d/Follow" % (i + 1))
		cb.call(p, opts)

func handle_progress(p: PathFollow2D, opts: Dictionary):
	if p.progress_ratio == 1:
		if p.get_child_count() > 0:
			var c = p.get_child(0)
			c.global_rotation = c.global_position.angle_to_point(target_position)
	var delta = opts["delta"] as float
	p.progress += speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var opts = {
		"delta": delta,
	}
	map_paths(handle_progress, opts)
		
