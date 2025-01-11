extends Camera2D

@export var decay : float = 0.5
@export var max_offset = Vector2(100, 75)
@export var max_roll : float = 0.1

var trauma : float = 0.0
var trauma_power : int = 2
func _process(delta):
	if trauma > 0:
		shake()
		trauma = trauma - delta * decay
		
	else:
		offset.x = 0
		offset.y = 0

func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
