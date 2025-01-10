extends Node
var Player1 = Player.new()
var testarray : Array[InputModel]
func _process(_delta: float) -> void:
	Write_Inputs()
	
	
	

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
