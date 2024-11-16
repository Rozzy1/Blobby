extends Node
@export var activatewhat : Node
@export var activatewhat2 : Node
@export var activatewhat3 : Node
@export var area2dconnectingfrom : Area2D
@export var mesh : MeshInstance2D
@onready var player = get_tree().get_first_node_in_group("player")
var canplayerdashthrough : bool = false
var switchedon : bool = false
func _ready():
	player.playerdied.connect(reset)
	if area2dconnectingfrom:
		area2dconnectingfrom.body_entered.connect(area_2d_body_entered)
		area2dconnectingfrom.body_exited.connect(area_2d_body_exited)


func _process(_delta):
	if canplayerdashthrough == true and player.is_dashing == true:
		
		if activatewhat and switchedon == false:
			
			activatewhat.isactivated = true
			mesh.modulate = Color (0,0.5,0.5)
			print("turned ",activatewhat,"on")
		if activatewhat2 and switchedon == false:
			
			activatewhat2.isactivated = true
			mesh.modulate = Color (0,0.5,0.5)
			print("turned ",activatewhat2,"on")
		if activatewhat3 and switchedon == false:
			
			activatewhat3.isactivated = true
			mesh.modulate = Color (0,0.5,0.5)
			print("turned ",activatewhat3,"on")
		if !activatewhat and !activatewhat2 and !activatewhat3:
			print("Nothing Attached!")
		switchedon = true


func area_2d_body_entered(body):
	if body == player:
		canplayerdashthrough = true



func area_2d_body_exited(body):
	if body == player:
		canplayerdashthrough = false

func reset():
	switchedon = false
	if activatewhat:
		activatewhat.isactivated = false
	if activatewhat2:
		activatewhat2.isactivated = false
	if activatewhat3:
		activatewhat3.isactivated = false
	mesh.modulate = Color (1,0.5,0.5)
