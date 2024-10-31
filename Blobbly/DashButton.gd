extends StaticBody2D
@export var activatewhat : Node2D
@onready var mesh = $Polygon
@onready var player = get_tree().get_first_node_in_group("player")
var canplayerdashthrough : bool = false
func _ready():
	pass


func _process(_delta):
	if canplayerdashthrough == true and player.is_dashing == true:
		if not activatewhat.isactivated == true:
			activatewhat.isactivated = true
			mesh.modulate = Color (0,0.5,0.5)
			print("turned ",activatewhat,"on")
			return


func _on_area_2d_body_entered(body):
	if body == player:
		canplayerdashthrough = true



func _on_area_2d_body_exited(body):
	if body == player:
		canplayerdashthrough = false
