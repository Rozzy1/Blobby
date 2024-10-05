extends CharacterBody2D
@onready var collision = $CollisionShape2D
@onready var Sprite = $MeshInstance2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var Hurtbox = $HurtHitBox
@onready var particles = $GPUParticles2D
var gravity : int = 900
var speed :int  = 150
var player_class = Player
var can_see_player : bool
var damage : int = 4

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	await get_tree().physics_frame
	if player and can_see_player == true:
		var direction = (player.position.x - global_position.x)
		if direction < 0:
			direction = -1
		else:
			direction = 1
		velocity.x = direction * speed
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body == player:
		if player.is_dashing == true or player.gravity == player.groundpoundgravity:
			collision.set_deferred("disabled",1)
			Hurtbox.set_deferred("monitoring",false)
			Sprite.visible = false
			particles.emitting = true
			player.subtract_health(-5)
		else:
			player.subtract_health(damage)


func _on_gpu_particles_2d_finished():
	queue_free()


func _on_enemey_los_body_entered(body):
	can_see_player = true


func _on_enemey_los_body_exited(body):
	can_see_player = false
