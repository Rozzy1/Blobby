extends Node
var testarray : Array[InputModel]
var amtlevels : int = 8
var levelarray : Array[PackedScene] = []
var Player1 = Player.new()
signal PlayerDied
signal PlayerSteppedOnSpikes
signal LevelChange
signal TeleporterTouched

func _ready():
	levelarray.clear()
	for i in amtlevels:
		levelarray.append(load("res://level_" + str(i) +".tscn"))
	LevelChange.connect(level_change)
	

func _process(_delta: float) -> void:
#	Write_Inputs()
	pass
	
	
	

#func Read_Inputs():
##		var testinputs = testarray[i]
#		Player1.leftright = testinputs.left - testinputs.right
	


func Write_Inputs():
	var inputs = InputModel.new()
	inputs.dash = Input.get_action_strength("Dash")
	inputs.up = Input.get_action_strength("up")
	inputs.left = Input.get_action_strength("left")
	inputs.right = Input.get_action_strength("right")
	if inputs.up or inputs.right or inputs.left or inputs.dash:
		testarray.append(inputs)
		print(testarray)


func level_change(levelcount):
	var currentlevel
	print(levelarray)
	remove_child(get_tree().get_first_node_in_group("level"))
	currentlevel = levelarray[levelcount].instantiate()
	print(currentlevel)
	add_child.call_deferred(currentlevel)
	currentlevel.visible = true
