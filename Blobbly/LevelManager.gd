extends Node
# Called when the node enters the scene tree for the first time.
func _ready():
	$Level2.position = Vector2(90000,90000)
	$Level3.position = Vector2(90000,90000)
	$Level4.position = Vector2(90000,90000)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_level_teleporter_level_change(LevelCount):
	match LevelCount:
		1:
			$Level1.visible = true
			$Level1.position = Vector2(0,0)
		2:
			remove_child($Level1)
			$Level2.position = Vector2(0,0)
			$Level2.visible = true
		3:
			remove_child($Level2)
			$Level3.position = Vector2(0,0)
			$Level3.visible = true
		4:
			remove_child($Level3)
			$Level4.position = Vector2(0,0)
			$Level4.visible = true
