extends ProgressBar
@onready var  timer = $Timer
@onready var damagebar = $DamageBar

var health = 0 : set = _set_health

func _set_health(new_health):
	var previous_health = health
	health = min(max_value, new_health)
	value = health
	if health <= 0:
		print("death")
	if health > previous_health:
		damagebar.value = health
	else:
		timer.start()


func init_health(_health):
	health = _health
	max_value = health
	value = health
	damagebar.max_value = health
	damagebar.value = health

func _on_timer_timeout():
	damagebar.value = health
