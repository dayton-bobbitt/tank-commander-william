extends KinematicBody2D


export (PackedScene) var HealthBar
export var LINEAR_MAX_SPEED = 75
export var MAX_HEALTH = 20


var canShoot = false
var destroyed = false
var health: int
var healthBar


func _exit_tree():
	if is_instance_valid(healthBar):
		healthBar.queue_free()


func _ready():
	health = MAX_HEALTH
	healthBar = HealthBar.instance()
	get_tree().current_scene.add_child(healthBar)


func _process(delta):
	if is_instance_valid(healthBar):
		var position = self.global_position
		
		position.y -= 60
		healthBar.global_position = position


func aim_at(target: Vector2, delta: float):
	# Aim at target
	$Turret.aim_at(target, delta)
	
	if canShoot:
		# Determine if target is in line of sight
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(self.global_position, target, [self])
		
		if result:
			if result.collider.is_in_group("player"):
				# Shoot if target is player and in line of sight
				$Turret.shoot()


func take_damage(damage):
	self.health -= damage
	
	healthBar.update_health_bar(MAX_HEALTH, health)
	
	if health <= 0:
		self.destroy()
		return true
	else:
		return false


func destroy():
	self.destroyed = true
	healthBar.queue_free()
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Turret.hide()
	$Explosion.play()
	$Explosion.show()


func _on_Explosion_animation_finished():
	# TODO: update score
	self.queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
