extends Node2D
signal LevelChange
var LevelCount : int = 1
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var teleporterarea : Area2D
# Called when the node enters the scene tree for the first time.
func _ready():
	LevelChange.emit(LevelCount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body == player:
		LevelCount = LevelCount + 1
		LevelChange.emit(LevelCount)
		print("Level is now:",LevelCount)
