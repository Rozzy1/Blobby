extends Node2D
@export var OneShot : bool
@export var TimeBetweenPoints : float
@export var NextPathPosition : Vector2
@export var EndingPathPosition : Vector2
var isactivated : bool = false
var currentarrayposition : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isactivated == true:
		MovePlatform()
		isactivated = false

func MovePlatform():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if OneShot == false:
		tween.set_loops().set_parallel(false)
		tween.tween_property($Platform,"position", NextPathPosition, TimeBetweenPoints)
		tween.tween_property($Platform,"position", EndingPathPosition, TimeBetweenPoints)
	else:
		tween.set_parallel(false)
		tween.tween_property($Platform,"position", NextPathPosition, TimeBetweenPoints)
		tween.tween_property($Platform,"position", EndingPathPosition, TimeBetweenPoints)
