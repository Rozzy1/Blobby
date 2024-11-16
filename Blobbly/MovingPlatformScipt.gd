extends Node
@onready var player = get_tree().get_first_node_in_group("player")
@export var OneShot : bool
@export var TimeBetweenPoints : float
@export var NextPathPosition : Vector2
@export var EndingPathPosition : Vector2
@export var StartingPathPosition : Vector2
@export var Platform : AnimatableBody2D
var isactivated : bool = false
var currentarrayposition : int
var hasplayerdied : bool = false
var tween
func _ready():
	player.playerdied.connect(reset)

func _process(_delta):
	if isactivated == true or hasplayerdied == true:
		if Platform:
			MovePlatform()
			isactivated = false


func MovePlatform():
	if tween:
		tween.kill()
	tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if OneShot == false and hasplayerdied == false:
		tween.set_loops().set_parallel(false)
		tween.tween_property(Platform,"position", NextPathPosition, TimeBetweenPoints)
		tween.tween_property(Platform,"position", EndingPathPosition, TimeBetweenPoints)
		print("tweening")
	if OneShot == true and hasplayerdied == false:
		tween.set_parallel(false)
		tween.tween_property(Platform,"position", NextPathPosition, TimeBetweenPoints)
		tween.tween_property(Platform,"position", EndingPathPosition, TimeBetweenPoints)
	if hasplayerdied == true:
		Platform.position = StartingPathPosition
		tween.kill()
		hasplayerdied = false
		isactivated = false
		return

func reset():
	hasplayerdied = true
