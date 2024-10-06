class_name Player
extends CharacterBody2D
@onready var healthbar = $CanvasLayer/HealthBar
var dashspeed : int = 300
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var gravity = 900
var groundpoundgravity = 5000
var is_dashing : bool = false
var Health : int = 10
var MaxHealth : int = Health
var cancoyote : bool
var lastfloor : bool
var jumping : bool

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumping = false
	
	if lastfloor == false and not jumping and not is_on_floor():
		cancoyote = true
		$Coyotetimer.start()
	
	
	# Handle jump.
	if Input.is_action_just_pressed("up") and (is_on_floor() or cancoyote):
		velocity.y = JUMP_VELOCITY
		jumping = true
	if Input.is_action_pressed("down") and not is_on_floor():
		gravity = groundpoundgravity
	else:
		gravity = 900
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction and is_dashing == false:
		velocity.x = direction * SPEED
	else:
		if is_dashing == false:
			velocity.x = move_toward(velocity.x,0, SPEED)
	if Input.is_action_just_pressed("Dash"):
		subtract_health(1)
		for i in 10:
			velocity.x = velocity.x + direction * dashspeed
			await get_tree().create_timer(0).timeout
			is_dashing = true
		await get_tree().create_timer(0.05).timeout
		is_dashing = false
	move_and_slide()
	lastfloor = is_on_floor()
	print(lastfloor)

func subtract_health(damage_amt):#
	print("ow")
	Health = Health - damage_amt
	if Health > MaxHealth:
		Health = MaxHealth
	healthbar.health = Health
	if Health < 1:
		respawn()

func _on_coyotetimer_timeout():
	cancoyote = false

func respawn():
	position = Vector2(-400,0)
	Health = MaxHealth
	healthbar.health = Health
	velocity = Vector2(0,0)




func _on_area_2d_body_entered(body):
	if body == get_tree().get_first_node_in_group("player"):
		respawn()
