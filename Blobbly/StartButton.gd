extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(0, -25)
	print(AudioServer.get_bus_volume_db(0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")
