extends PanelContainer
const DesiredSize = Vector2(1152,648)
# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().size_changed.connect(Change_Size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func Change_Size():
	var NewSize = get_viewport_rect().size
	scale = DesiredSize/NewSize
	print(scale)
