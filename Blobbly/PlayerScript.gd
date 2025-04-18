class_name Player
extends CharacterBody2D
@onready var healthbar = $CanvasLayer/HealthBar
@onready var coyotetimer = $Coyotetimer
@onready var animationsprite = $AnimatedSprite2D
@onready var deathparticles = $DeathParticles
@onready var camera = $Camera2D
@export var PlayerSpawnPoints : PackedVector2Array
signal playerdied

var dashspeed : int = 300
var LevelCount : int = 1
const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var gravity = 800
var is_dashing : bool = false
var Health : int = 15
var MaxHealth : int = Health
var cancoyote : bool
var lastfloor : bool
var jumping : bool
var isrespawning : bool
var friction : float = 1.2
var dashedinaircounter : int = 1
var canmove : bool = true
var lastdirs : Vector2
var istouchingfrictionlessbody : bool
var isteleportertouched : bool = false
var leftright
var updown
var direction

func _ready():
	GameManager.LevelChange.connect(_on_level_teleporter_level_change)
	GameManager.TeleporterTouched.connect(_on_level_teleporter_teleporter_touched)
	GameManager.PlayerSteppedOnSpikes.connect(landed_on_spikes)
	


func _physics_process(delta):
	if istouchingfrictionlessbody == true:
		friction = 1
	else:
		friction = 1.2
	
	
	leftright = Input.get_axis("left","right")
	updown = Input.get_axis("up","down")
	
	if leftright or updown:
		lastdirs = Vector2(leftright,updown)
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 0:
			gravity = 1200
	else:
		jumping = false
		dashedinaircounter = 1
	
	if !is_on_floor() and lastfloor and !jumping:
		print("cancoyote")
		cancoyote = true
		coyotetimer.start()
	
	
	# Handle jump.
	if Input.is_action_just_pressed("up") and (is_on_floor() or cancoyote == true) and canmove == true:
		velocity.y = JUMP_VELOCITY
		jumping = true
		play_sound_effect("Jump")
	
	#InputDirections and simple movement
	direction = Input.get_axis("left", "right")
	if direction and is_dashing == false and canmove == true:
		velocity.x = direction * SPEED
		if is_on_floor() == true:
			play_animation("walk")
	else:
		if is_dashing == false:
			velocity.x = velocity.x / friction
	
	#Dash Function
	if Input.is_action_just_pressed("Dash"):
		var directions = lastdirs.normalized()
		if directions and canmove == true:
			play_animation("dash")
			if not is_on_floor():
				if dashedinaircounter > 1:
					play_sound_effect("Hit")
				dashedinaircounter = dashedinaircounter + 1
				subtract_health(dashedinaircounter)
			else:
				dashedinaircounter = 1
				subtract_health(dashedinaircounter)
			for i in 10:
				velocity += (dashspeed * directions) * 2
				play_animation("dash_loop")
				await get_tree().create_timer(0.01).timeout
				is_dashing = true
			for y in 10:
				velocity.y = velocity.y / friction
				velocity.x = velocity.x / friction
			play_animation("dash_end")
			await get_tree().create_timer(0.35).timeout
			is_dashing = false
			camera.add_trauma(0.1)
	
	if !isrespawning and !direction and !is_dashing and !jumping and !isteleportertouched and is_on_floor():
		play_animation("idle")
	
	if !isteleportertouched and !isrespawning:
		if velocity.y < 0:
			play_animation("jump_start")
		else:
			if velocity.y > 0:
				play_animation("jump_mid")
			if velocity.y > 300:
				play_animation("jump_fall")
	
	
	lastfloor = is_on_floor()
	move_and_slide()

func subtract_health(damage_amt):
	camera.add_trauma(damage_amt/10)
	print("Player got dealt: ",damage_amt)
	Health = Health - damage_amt
	if Health > MaxHealth:
		Health = MaxHealth
	healthbar.health = Health
	if Health < 1:
		canmove = false
		camera.add_trauma(0.25)
		animationsprite.visible = false
		deathparticles.emitting = true
		play_sound_effect("Die")
		await get_tree().create_timer(2.5).timeout
		respawn()

func _on_coyotetimer_timeout():
	cancoyote = false

func respawn():
	canmove = false
	isrespawning = true
	direction = 1
	animationsprite.visible = true
	deathparticles.emitting = false
	GameManager.PlayerDied.emit()
	global_position  = PlayerSpawnPoints[LevelCount]
	print(global_position)
	Health = MaxHealth
	healthbar.health = Health
	dashedinaircounter = 1
	velocity = Vector2(0,0)
	cancoyote = false
	play_animation("respawn")
	await get_tree().create_timer(1.75).timeout
	canmove = true
	isrespawning = false



func landed_on_spikes():
	subtract_health(99)


func _on_level_teleporter_level_change(levelcount):
	LevelCount = levelcount
	respawn()
	print("spawned")



func _on_level_teleporter_teleporter_touched(teleporterposition):
	isteleportertouched = true
	play_animation("spin")
	canmove = false
	velocity = Vector2(0,0)
	var teleportertween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	teleportertween.set_parallel(false)
	teleportertween.tween_property(self,"position", teleporterposition, 0.4)
	await get_tree().create_timer(2).timeout
	isteleportertouched = false
	canmove = true
	print("ahh")
	

func play_animation(animation):
	if animation == "walk":
		animationsprite.speed_scale = 1.5
	else:
		animationsprite.speed_scale = 1
	
	if direction < 0:
		animationsprite.flip_h = true
	elif direction > 0:
		animationsprite.flip_h = false
	animationsprite.play(animation)


func apply_knockback(force,direction):
	print(force,direction, "applied")
	velocity.x = direction * force * 5
	velocity.y = direction * force / 2.5
	print(velocity)

func play_sound_effect(soundeffect):
	match soundeffect:
		"Jump":
			$Jump.play()
			$Jump.pitch_scale = randf_range(0.9,1.1)
		"Hit":
			$Hit.play()
			$Hit.pitch_scale = randf_range(0.9,1.1)
		"Die":
			$Die.play()
