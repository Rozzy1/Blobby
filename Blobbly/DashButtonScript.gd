extends Node
@export var activatewhat : Node
@export var area2dconnectingfrom : Area2D
@export var mesh : MeshInstance2D
@onready var player = get_tree().get_first_node_in_group("player")
var canplayerdashthrough : bool = false
func _ready():
	if area2dconnectingfrom:
		area2dconnectingfrom.body_entered.connect(area_2d_body_entered)
		area2dconnectingfrom.body_exited.connect(area_2d_body_exited)


func _process(_delta):
	if canplayerdashthrough == true and player.is_dashing == true:
		if activatewhat and not activatewhat.isactivated == true:
			activatewhat.isactivated = true
			mesh.modulate = Color (0,0.5,0.5)
			print("turned ",activatewhat,"on")
			return
		if !activatewhat:
			print("Nothing Attached!")


func area_2d_body_entered(body):
	if body == player:
		canplayerdashthrough = true



func area_2d_body_exited(body):
	if body == player:
		canplayerdashthrough = false
