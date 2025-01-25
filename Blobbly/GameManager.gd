extends Node
var Player1 = Player.new()
var testarray : Array[InputModel]
var level1 : PackedScene = preload("res://level_1.tscn")
var level2 : PackedScene = preload("res://level_2.tscn")
var level3 : PackedScene = preload("res://level_3.tscn")
var level4 : PackedScene = preload("res://level_4.tscn")
var level5 : PackedScene = preload("res://level_5.tscn")
var level6 : PackedScene = preload("res://level_6.tscn")
var levelarray : Array = [level1,level2,level3,level4,level5,level6]

signal PlayerDied
signal PlayerSteppedOnSpikes
signal LevelChange
signal TeleporterTouched

func _ready():
	LevelChange.connect(level_change)
	








func _process(_delta: float) -> void:
#	Write_Inputs()
	pass
	
	
	

func Read_Inputs():
	for i in testarray.size():
		var testinputs = testarray[i]
		Player1.leftright = testinputs.left - testinputs.right
	


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
	currentlevel = levelarray[levelcount-1].instantiate()
	print(currentlevel)
	add_child.call_deferred(currentlevel)
	currentlevel.visible = true
