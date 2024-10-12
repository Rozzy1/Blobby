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
var friction : float = 1.2

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
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction and is_dashing == false:
		velocity.x = direction * SPEED
	else:
		if is_dashing == false:
			velocity.x = velocity.x / friction
	if Input.is_action_just_pressed("Dash"):
		var leftright =Input.get_axis("left","right")
		var updown =Input.get_axis("up","down")
		var directions = Vector2(leftright,updown).normalized()
		if directions:
			subtract_health(1)
			for i in 10:
				velocity += (dashspeed * directions)
				print(directions)
				print(velocity)
				await get_tree().create_timer(0).timeout
				is_dashing = true
			for y in 10:
				velocity.y = velocity.y / friction
				velocity.x = velocity.x / friction
			is_dashing = false
	move_and_slide()
	lastfloor = is_on_floor()

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
	position = Vector2(0,0)
	Health = MaxHealth
	healthbar.health = Health
	velocity = Vector2(0,0)




func _on_area_2d_body_entered(body):
	if body == get_tree().get_first_node_in_group("player"):
		respawn()
