extends Control
var fps : int = 1
var fps_timer : float = 0
var track_fps : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	if track_fps == true:
		fps_timer += delta
		fps += 1
		if fps_timer >= 1:
			$"../../fpslabel".text = "FPS: " + str(fps)
			fps_timer = 0
			fps = 0

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	print(AudioServer.get_bus_volume_db(0))


func _on_testsoundbutton_pressed():
	$TestSoundButton/SplatTest.play()


func _on_display_fps_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"../../fpslabel".visible= true
		track_fps = true
	else:
		$"../../fpslabel".visible = false

func _on_resolution_dropdown_item_selected(index: int) -> void:
	if DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1280,720))
		2:
			DisplayServer.window_set_size(Vector2i(1152,648))

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_v_sync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
