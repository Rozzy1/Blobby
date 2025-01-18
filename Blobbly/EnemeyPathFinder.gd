extends CharacterBody2D
#CURRENT BUG IN ENEMEY SCRIPT, THE ENEMEY SEES ME WHEN FIRST IMPORTED, FIX
@onready var collision = $CollisionShape2D
@onready var Sprite = $MeshInstance2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var Hurtbox = $HurtHitBox
@onready var particles = $GPUParticles2D
@onready var raycast = $RayCast2D
var gravity : int = 900
var speed :int  = 150
var player_class = Player
var can_see_player : bool = false
var damage : int = 5
var lastdirection : int

func _ready():
	can_see_player = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#EnemeyPathfinding
	if player and can_see_player == true:
		var direction = (player.position.x - global_position.x)
		if direction < 0:
			raycast.position.x = 3.15
			direction = -1
		else:
			direction = 1
			raycast.position.x = -3.15
		lastdirection = direction
		velocity.x = direction * speed
	
	if raycast.is_colliding():
		move_and_slide()


func _on_area_2d_body_entered(body):
	if body == player:
		if player.is_dashing == true:
			$DeathSfx.play()
			collision.set_deferred("disabled",1)
			Hurtbox.set_deferred("monitoring",false)
			Sprite.visible = false
			particles.emitting = true
			player.subtract_health(-6)
		else:
			$HitPlayer.play()
			player.subtract_health(damage)
			player.apply_knockback(1000,lastdirection)


func _on_gpu_particles_2d_finished():
	queue_free()


func _on_enemey_los_body_entered(body):
	if body == player:
		can_see_player = true


func _on_enemey_los_body_exited(body):
	if body == player:
		can_see_player = false
