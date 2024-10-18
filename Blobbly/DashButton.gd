extends StaticBody2D
@export var collision : CollisionShape2D
@export var activatewhat : Node2D
@onready var player = get_tree().get_first_node_in_group("player")
var canplayerdashthrough : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	print(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canplayerdashthrough == true and player.is_dashing == true:
		activatewhat.isactivated = true
	else:
		collision.set_deferred("disabled",0)


func _on_area_2d_body_entered(body):
	if body == player:
		canplayerdashthrough = true



func _on_area_2d_body_exited(body):
	if body == player:
		canplayerdashthrough = false
