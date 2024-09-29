extends Node2D
@onready var enemeyscene : PackedScene = preload("res://Enemey.tscn")
@export var enemeypositions : PackedVector2Array
var currentarrayposition : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnEnemies(enemeypositions.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SpawnEnemies(amount):
	for i in amount:
		var enemey = enemeyscene.instantiate()
		add_child(enemey)
		enemey.global_position = enemeypositions[currentarrayposition]
		currentarrayposition = currentarrayposition + 1
		
