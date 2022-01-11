extends KinematicBody2D


signal enemy_dead


export (PackedScene) var HealthBar
export var LINEAR_MAX_SPEED = 75
export var MAX_HEALTH = 20


onready var screen_size = get_viewport_rect().size
onready var center_of_screen = screen_size / 2
onready var audioStream2dDriving = $AudioStream2DDriving
onready var audioStream2dImpact = $AudioStream2DImpact
onready var audioStream2dImpactExplosion = $AudioStream2DImpactExplosion
onready var audioStream2dExplosion = $AudioStream2DExplosion
var canShoot = false
var destroyed = false
var health: int
var healthBar
var player


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
	
	if is_instance_valid(player):
		var directional_offset = player.global_position - self.global_position
		var directional_audio_position = center_of_screen - directional_offset
		
		audioStream2dDriving.global_position = directional_audio_position
		audioStream2dImpact.global_position = directional_audio_position
		audioStream2dImpactExplosion.global_position = directional_audio_position
		audioStream2dExplosion.global_position = directional_audio_position


func aim_at(target: Vector2, delta: float):
	if !destroyed:
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
	audioStream2dImpact.play()
	audioStream2dImpactExplosion.play()
	
	if health <= 0:
		self.destroy()
		return true
	else:
		return false


func destroy():
	self.destroyed = true
	emit_signal("enemy_dead")
	healthBar.queue_free()
	audioStream2dDriving.stop()
	audioStream2dExplosion.play()
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Turret.hide()
	$Explosion.play()
	$Explosion.show()


func _on_Explosion_animation_finished():
	$Explosion.hide()


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_AudioStream2DExplosion_finished():
	self.queue_free()
