extends Node2D
@onready var enemeyscene : PackedScene = preload("res://Enemey.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
@export var enemeypositions1 : PackedVector2Array
@export var enemeypositions2 : PackedVector2Array
@export var enemeypositions3 : PackedVector2Array
@export var enemeypositions4 : PackedVector2Array
@export var enemeypositions6 : PackedVector2Array
var currentarrayposition : int = 0
var array : PackedVector2Array
var LevelCount : int
#BUG -MEMORY LEAK(?), because i need to remove enemeys each level skip, ill resolve it later- BUG
func _ready():
	player.playerdied.connect(reloadenemies)


func _process(_delta):
	pass

func SpawnEnemies(array):
	currentarrayposition = 0
	for i in array.size():
		var enemey = enemeyscene.instantiate()
		add_child(enemey)
		enemey.global_position = array[currentarrayposition]
		enemey.can_see_player = false
		currentarrayposition = currentarrayposition + 1
	


func _on_level_teleporter_level_change(levelcount):
	LevelCount = levelcount
	for child in self.get_children():
		child.queue_free()
	match levelcount:
		1:
			array = enemeypositions1
		2:
			array = enemeypositions2
		3:
			array = enemeypositions3
		4:
			array = enemeypositions4
		6:
			array = enemeypositions6
	SpawnEnemies(array)

func reloadenemies():
	_on_level_teleporter_level_change(LevelCount)
