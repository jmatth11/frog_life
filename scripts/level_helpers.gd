extends Node
class_name LevelHelpers

static func add_fly(sprite:Node2D, path_count: int, parent:Node2D, path_getter: Callable):
	var useMainPath = true
	for i in path_count:
		var p: PathFollow2D = path_getter.call("Path%d/Follow" % (i + 1))
		if p.get_child_count() == 0:
			p.progress = 0
			p.add_child(sprite)
			useMainPath = false
	var mainPath: PathFollow2D = path_getter.call("Main/Follow")
	if useMainPath:
		mainPath.progress_ratio = randf()
		sprite.position = mainPath.position
		sprite.rotation = Vector2.DOWN.angle()
		var velocity = Vector2(0.0, randf_range(250.0, 350.0))
		sprite.velocity = velocity
		parent.add_child(sprite)
