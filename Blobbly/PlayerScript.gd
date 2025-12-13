class_name Player
extends CharacterBody2D

# -------------------------------------------------------------------
# Node references
# -------------------------------------------------------------------
@onready var health_bar      = $CanvasLayer/HealthBar
@onready var coyote_timer    = $Coyotetimer
@onready var anim_sprite     = $AnimatedSprite2D
@onready var death_particles = $DeathParticles
@onready var camera          = $Camera2D

# -------------------------------------------------------------------
# Exported / editable values
# -------------------------------------------------------------------
@export var player_spawn_points: PackedVector2Array

signal player_died

# -------------------------------------------------------------------
# Constants / Settings
# -------------------------------------------------------------------
const SPEED           = 600.0
const JUMP_VEL        = -700.0
const GRAVITY_FALL    = 1200
const GRAVITY_RISE    = 1600
const DASH_SPEED      = 300
const MIN_SLOPE_ANGLE = 30
const MAX_SLOPE_ANGLE = 90

# -------------------------------------------------------------------
# State Variables
# -------------------------------------------------------------------
var level_count        = 1
var health             = 15
var max_health         = 15

var gravity            = GRAVITY_FALL
var is_dashing         = false
var can_move           = true
var is_respawning      = false
var coyote_available   = false
var last_on_floor      = false
var jumping            = false
var dashed_in_air      = 1

var friction           = 1.2
var TARGET_FRICTION : float = 1.2
var frictionless_count : int = 0
var last_dirs          = Vector2.ZERO
var touching_no_fric   = false
var teleporter_locked  = false

var horizontal_input := 0.0
var vertical_input   := 0.0
var direction        := 0.0
var ray_length = 2.0
var up_vector = Vector3.UP

var last_animation : String

# -------------------------------------------------------------------
func _ready():
	GameManager.LevelChange.connect(_on_level_change)
	GameManager.TeleporterTouched.connect(_on_teleporter_enter)
	GameManager.PlayerSteppedOnSpikes.connect(_on_spike_hit)


# -------------------------------------------------------------------
func _physics_process(delta):
	_handle_debug()
# ------------------------------------------------------------
# FRICTION SYSTEM
# ------------------------------------------------------------
	TARGET_FRICTION = 1 if frictionless_count > 0 else 1.2
	friction = lerp(friction, TARGET_FRICTION, delta * 10)

# ------------------------------------------------------------
# INPUT
# ------------------------------------------------------------
	horizontal_input = Input.get_axis("left", "right")
	vertical_input   = Input.get_axis("up", "down")

	if horizontal_input != 0 or vertical_input != 0:
		last_dirs = Vector2(horizontal_input, vertical_input)

	direction = horizontal_input

# ------------------------------------------------------------
# CATPURE FLOOR STATE BEFORE ANY MOVEMENT
# ------------------------------------------------------------
	var on_floor_now := is_on_floor()
	if on_floor_now == true:
		dashed_in_air = 0

# ------------------------------------------------------------
# GRAVITY
# ------------------------------------------------------------
	if not on_floor_now:
		gravity = GRAVITY_FALL
		velocity.y += gravity * delta
	else:
		gravity = GRAVITY_FALL

# variable jump height
	if Input.is_action_just_released("up") and velocity.y < 0:
		velocity.y = 0

	if velocity.y < 0:
		gravity = GRAVITY_RISE

# ------------------------------------------------------------
# COYOTE TIME LOGIC 
# ------------------------------------------------------------
	if on_floor_now:
	# touching ground kills coyote + prevents double jump
		coyote_available = false
		jumping = false
	else:
	# just left the ground?
		if last_on_floor and not jumping:
			coyote_available = true
			coyote_timer.start()
	
	
	
# ------------------------------------------------------------
# JUMP
# ------------------------------------------------------------
	if Input.is_action_just_pressed("up") and can_move and (on_floor_now or coyote_available):
		velocity.y = JUMP_VEL
		jumping = true
		coyote_available = false  # MUST stay here (fix)
		_play_sfx("Jump")

# ------------------------------------------------------------
# HORIZONTAL MOVEMENT
# ------------------------------------------------------------
	if can_move and not is_dashing:
		if direction != 0:
			velocity.x = direction * SPEED
			if on_floor_now:
				_play_anim("run")
		else:
			velocity.x /= friction

# ------------------------------------------------------------
# UPDATE FLOOR STATE FOR NEXT FRAME
# ------------------------------------------------------------
	last_on_floor = on_floor_now


	# -----------------------------
	# Dash
	# -----------------------------
	if Input.is_action_just_pressed("Dash"):
		_perform_dash()

	# -----------------------------
	# Idle Animations
	# -----------------------------
	if _should_idle():
		if last_animation == "run":
			_play_anim("run_to_idle")
		else:
			_play_anim("idle")

	# Air animations
	if not teleporter_locked and not is_respawning:
		if velocity.y < 0:
			_play_anim("jump_start")
		elif velocity.y > 150:
			_play_anim("jump_mid")
		if velocity.y > 400:
			_play_anim("jump_fall")

	last_on_floor = is_on_floor()
	calculate_max_slope_angle(velocity.x)
	move_and_slide()
	align_to_ground()


# -------------------------------------------------------------------
# Logic Helpers
# -------------------------------------------------------------------
func _should_idle() -> bool:
	return (
		not is_respawning
		and not teleporter_locked
		and not is_dashing
		and not jumping
		and direction == 0
		and is_on_floor()
	)

func _on_coyotetimer_timeout() -> void:
	coyote_available = false
func _perform_dash():
	if is_dashing or not can_move:
		return

	var dash_dir = last_dirs.normalized()
	if dash_dir == Vector2.ZERO:
		return

	_play_anim("dash")
	_play_sfx("Dash")

	# Apply health cost
	if not is_on_floor():
		if dashed_in_air > 0:
			dashed_in_air += 1
			subtract_health(dashed_in_air)
	else:
		dashed_in_air = 1
		subtract_health(1)

	is_dashing = true

	for i in 10:
		velocity += dash_dir * DASH_SPEED * 2
		_play_anim("dash_loop")
		await get_tree().create_timer(0.01).timeout

	for i in 10:
		velocity /= friction

	_play_anim("dash_end")
	await get_tree().create_timer(0.35).timeout

	is_dashing = false
	camera.add_trauma(0.1)


# -------------------------------------------------------------------
# Health & Damage
# -------------------------------------------------------------------
func subtract_health(dmg):
	if dmg > 0:
		camera.add_trauma(dmg / 8.0)
	health -= dmg
	health = min(health, max_health)
	health_bar.health = health

	if health <= 0:
		_die()


func _die():
	can_move = false
	camera.add_trauma(0.25)
	anim_sprite.visible = false
	death_particles.emitting = true
	_play_sfx("Die")

	await get_tree().create_timer(2.5).timeout
	_respawn()


func _respawn():
	can_move = false
	is_respawning = true
	anim_sprite.visible = true
	death_particles.emitting = false

	GameManager.PlayerDied.emit()

	global_position = player_spawn_points[level_count-1]
	health = max_health
	health_bar.health = health
	dashed_in_air = 1
	velocity = Vector2.ZERO
	coyote_available = false

	_play_anim("respawn")

	await get_tree().create_timer(1.75).timeout
	can_move = true
	is_respawning = false


# -------------------------------------------------------------------
# Teleporters, Spikes, Level Change
# -------------------------------------------------------------------
func _on_spike_hit():
	subtract_health(99)


func _on_level_change(level):
	level_count = level
	_respawn()


func _on_teleporter_enter(target_pos):
	teleporter_locked = true
	can_move = false
	velocity = Vector2.ZERO

	_play_anim("spin")

	create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) \
		.tween_property(self, "position", target_pos, 0.4)

	await get_tree().create_timer(2).timeout

	teleporter_locked = false
	can_move = true


# -------------------------------------------------------------------
# Misc
# -------------------------------------------------------------------
func _play_anim(anim):
	last_animation = anim
	anim_sprite.speed_scale = 1.5 if anim == "run" else 1.0

	if direction < 0:
		anim_sprite.flip_h = true
	elif direction > 0:
		anim_sprite.flip_h = false
	anim_sprite.play(anim)


func apply_knockback(force, player_dir):
	velocity.x = player_dir * force * 5
	velocity.y = player_dir * force / 2.5


func _play_sfx(name):
	match name:
		"Jump":
			$Jump.pitch_scale = randf_range(0.9, 1.1)
			$Jump.play()
		"Hit":
			$Hit.pitch_scale = randf_range(0.9, 1.1)
			$Hit.play()
		"Die":
			$Die.play()
		"Dash":
			$Dash.play()


func _on_CoyoteTimer_timeout():
	coyote_available = false


func _handle_debug():
	if Input.is_action_just_pressed("debugforwardlevel"):
		GameManager.LevelChange.emit(0)
		level_count = -1
		await get_tree().create_timer(1.39).timeout

func align_to_ground() -> void:
	var space_state = get_world_2d().direct_space_state
	var from = global_position
	var to = from + Vector2.DOWN * 75.0
	
	var query = PhysicsRayQueryParameters2D.create(from, to)
	var result = space_state.intersect_ray(query)
	if result:
		print(result)
		var ground_normal: Vector2 = result.normal
		
		# Calculate the angle of the ground
		var angle = ground_normal.angle() + deg_to_rad(90)
		
		# Rotate the player to match the ground
		rotation = lerp_angle(rotation, angle, 0.5)
	else:
		rotation = lerp_angle(rotation, 0, 0.2)

func calculate_max_slope_angle(speed: float) -> float:
	var v = max(speed, 0.0)
	var scale = 0.5 # adjust to control growth rate
	var angle = MIN_SLOPE_ANGLE + log(1.0 + v) * scale
	return clamp(angle, MIN_SLOPE_ANGLE, MAX_SLOPE_ANGLE)
