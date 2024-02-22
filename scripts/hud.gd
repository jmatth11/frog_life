extends CanvasLayer
class_name HUD

@export var fly_points = 3
var current_points = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalState.update_score.connect(Callable(_on_player_fly_points))
	$Score.text = "0"
	current_points = 0

func _on_player_fly_points(num):
	current_points += fly_points * num
	$Score.text = str(current_points)
