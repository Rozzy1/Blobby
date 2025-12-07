extends Node
@export var area2d : Area2D
@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	if area2d:
		area2d.body_entered.connect(area2d_entered)
		area2d.body_exited.connect(area2d_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func area2d_entered(body):
	if body == player:
		player.frictionless_count += 1


func area2d_exited(body):
	if body == player:
		player.frictionless_count -= 1
	
