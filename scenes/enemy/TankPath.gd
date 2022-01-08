extends PathFollow2D


onready var enemy = $Enemy


func _physics_process(delta):
	if is_instance_valid(enemy):
		self.offset += enemy.LINEAR_MAX_SPEED * delta
	else:
		self.queue_free()
