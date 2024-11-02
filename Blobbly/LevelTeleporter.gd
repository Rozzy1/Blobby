extends Node2D
signal LevelChange
signal TeleporterTouched
var LevelCount : int = 1
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var teleporterarea : Area2D
@export var TeleporterLevelPositions : PackedVector2Array
# Called when the node enters the scene tree for the first time.
func _ready():
	LevelChange.emit(LevelCount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	if Input.is_action_just_pressed("debugforwardlevel"):
		LevelCount = LevelCount + 1
		LevelChange.emit(LevelCount)



func _on_area_2d_body_entered(body):
	if body == player:
		if not LevelCount < 1:
			TeleporterTouched.emit()
		LevelCount = LevelCount + 1
		LevelChange.emit(LevelCount)


func _on_level_change(currentlevel):
	global_position = TeleporterLevelPositions[currentlevel]
	print("Level is now:",LevelCount)
