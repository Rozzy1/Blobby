extends Node
@onready var enemeyscene : PackedScene = preload("res://Enemey.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@export var enemeypositions : PackedVector2Array
var currentarrayposition : int = 0
var array : PackedVector2Array
var LevelCount : int
func _ready():
	GameManager.PlayerDied.connect(reloadenemies)
	GameManager.LevelChange.connect(_on_level_teleporter_level_change)
	SpawnEnemies(enemeypositions)


func _process(_delta):
	pass

func SpawnEnemies(enemeyarray):
	print("spawned enemies")
	currentarrayposition = 0
	for i in enemeyarray.size():
		var enemey = enemeyscene.instantiate()
		add_child(enemey)
		enemey.global_position = enemeyarray[currentarrayposition]
		enemey.can_see_player = false
		currentarrayposition = currentarrayposition + 1
	


func _on_level_teleporter_level_change(levelcount):
	print("connected")
	LevelCount = levelcount
	for child in self.get_children():
		child.queue_free()
	array = enemeypositions
	SpawnEnemies(array)

func reloadenemies():
	_on_level_teleporter_level_change(LevelCount)
