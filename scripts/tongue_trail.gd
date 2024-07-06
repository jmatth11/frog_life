class_name Trail
extends Line2D

@onready var curve = Curve2D.new()
var reverse = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var parent_pos = get_parent().global_position
	var parent_shape = get_parent().get_shape()
	var rot = get_parent().parent_rotation() + 1.5
	# edit y offset to handle rotation
	var y_offset = ((parent_shape.radius / 2) * rot)
	if rot < 0:
		parent_pos.y = parent_pos.y + y_offset
	else:
		parent_pos.y = parent_pos.y - y_offset
	# apply x offset for normal centering
	parent_pos.x = parent_pos.x - (parent_shape.radius * 2)
	
	if not reverse:
		curve.add_point(parent_pos)
	else:
		var idx = curve.point_count - 1
		# TODO maybe find better way to remove points
		if idx >= 0:
			curve.remove_point(curve.point_count - 1)
	points = curve.get_baked_points()

func stop():
	set_process(false)
	queue_free()
	
static func create() -> Trail:
	var scn = preload("res://scenes/tongue_trail.tscn")
	return scn.instantiate()
