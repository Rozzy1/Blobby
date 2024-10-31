extends Node2D
@export var collision : CollisionShape2D
@onready var player = get_tree().get_first_node_in_group("player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body == player and player.is_dashing == true:
		collision.set_deferred("disabled",1)


func _on_area_2d_body_exited(body):
	if body == player and player.is_dashing == true:
		collision.set_deferred("disabled",0)
