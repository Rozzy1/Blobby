extends Node
@export var collision : CollisionShape2D
@export var area2d : Area2D
@onready var player = get_tree().get_first_node_in_group("player")
var canplayerdashthrough : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	if area2d:
		area2d.body_entered.connect(area_2d_body_entered)
		area2d.body_exited.connect(area_2d_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if canplayerdashthrough == true and player.is_dashing == true:
		if collision:
			collision.set_deferred("disabled",0)
	else:
		if collision:
			collision.set_deferred("disabled",1)


func area_2d_body_entered(body):
	if body == player:
		canplayerdashthrough = true


func area_2d_body_exited(body):
	if body == player:
		canplayerdashthrough = true
