extends CharacterBody2D
@onready var agent = $NavigationAgent2D
var gravity = 900
var speed = 5
func _physics_process(delta: float) -> void:
	agent.target_position = player.global_position
	var next_position = agent.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

