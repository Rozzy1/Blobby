class_name Player
extends CharacterBody2D

var dashspeed : int = 300
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var gravity = 900
var is_dashing : bool = false



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("down") and not is_on_floor():
		gravity = 5000
	else:
		gravity = 800
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction and is_dashing == false:
		velocity.x = direction * SPEED
	else:
		if is_dashing == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("Dash"):
		for i in 10:
			velocity.x = velocity.x + direction * dashspeed
			await get_tree().create_timer(0).timeout
			is_dashing = true
		await get_tree().create_timer(0.05).timeout
		is_dashing = false
	move_and_slide()
