extends Node2D
var LevelCount : int = 1
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var teleporterarea : Area2D
@export var TeleporterLevelPositions : PackedVector2Array
@onready var teleportersprite = $TeleporterSprite
@onready var animationplayer = $AnimationParts/AnimationPlayer
@onready var leveltransitionsfx = $leveltransitionsfx
@onready var levelcompletedsfx = $transitionedcompleted
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.LevelChange.connect(_on_level_change)
	GameManager.LevelChange.emit(LevelCount)
	teleportersprite.frame = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	if Input.is_action_just_pressed("debugforwardlevel"):
		LevelCount = LevelCount + 1
		GameManager.LevelChange.emit(LevelCount)
		await get_tree().create_timer(1.39).timeout



func _on_area_2d_body_entered(body):
	if body == player and !player.is_dashing == true and player.velocity.y == 0:
		if not LevelCount < 1:
			GameManager.TeleporterTouched.emit(position + Vector2(0,-40))
			animationplayer.play("TeleporterSpriteOpen")
			leveltransitionsfx.play()
			await get_tree().create_timer(1.39).timeout
			LevelCount = LevelCount + 1
			GameManager.LevelChange.emit(LevelCount)
		pass


func _on_level_change(currentlevel):
	levelcompletedsfx.play()
	global_position = TeleporterLevelPositions[currentlevel]
	print("Level is now:",LevelCount)
