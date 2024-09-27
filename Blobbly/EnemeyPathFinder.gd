extends CharacterBody2D
@onready var collision = $CollisionShape2D
@onready var Sprite = $MeshInstance2D
@onready var player = $"../Player"
@onready var Hurtbox = $Area2D
@onready var particles = $GPUParticles2D
var gravity = 900
var speed = 150
var player_class = Player

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	await get_tree().physics_frame
	if player:
		var direction = (player.position.x - global_position.x)
		if direction < 0:
			direction = -1
		else:
			direction = 1
		velocity.x = direction * speed
		move_and_slide()



func _on_area_2d_body_entered(body):
	if body == player:
		if player.is_dashing == true:
			Sprite.visible = false
			collision.set_deferred("disabled",1)
			particles.emitting = true
		else:
			pass #dish out dmage function here


func _on_gpu_particles_2d_finished():
	queue_free()
