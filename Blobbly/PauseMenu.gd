extends Control
func _ready():
	$AnimationPlayer.play("RESET")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("pause_blur")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("pause_blur")

func quit():
	get_tree().quit()

func options():
	pass

func on_esc_pressed():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()

func _process(_delta):
	on_esc_pressed()


func _on_resume_pressed():
	resume()


func _on_quit_pressed():
	quit()
