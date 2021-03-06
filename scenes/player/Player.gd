extends KinematicBody2D


signal player_dead


export (PackedScene) var HealthBar
export var LINEAR_ACCELERATION = 25
export var LINEAR_FRICTION = 15
export var LINEAR_MAX_SPEED = 100
export var ANGULAR_MAX_SPEED = PI
export var MAX_HEALTH = 40


onready var screen_size = get_viewport_rect().size
onready var audioStreamImpact = $AudioStreamImpact
onready var audioStreamImpactExplosion = $AudioStreamImpactExplosion
onready var audioStreamExplosion = $AudioStreamExplosion
var linear_velocity = Vector2.ZERO
var destroyed = false
var health: int
var healthBar


func _ready():
	health = MAX_HEALTH
	healthBar = HealthBar.instance()
	get_tree().current_scene.add_child(healthBar)


func update_linear_velocity():
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	if direction != Vector2.ZERO:
		linear_velocity += direction.rotated(self.rotation).normalized() * self.LINEAR_ACCELERATION
		linear_velocity = linear_velocity.clamped(self.LINEAR_MAX_SPEED)
		if !$AudioStreamDriving.playing:
			$AudioStreamDriving.play()
			$AudioStreamIdle.stop()
	else:
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, LINEAR_FRICTION)
		if !$AudioStreamIdle.playing:
			$AudioStreamDriving.stop()
			$AudioStreamIdle.play()


func get_tank_rotation():
	var tank_rotation = 0
	
	if Input.is_action_pressed("ui_left"):
		tank_rotation -= self.ANGULAR_MAX_SPEED
	if Input.is_action_pressed("ui_right"):
		tank_rotation += self.ANGULAR_MAX_SPEED
	
	return tank_rotation


func _process(delta):
	if is_instance_valid(healthBar):
		var position = self.global_position
		
		position.y -= 60
		healthBar.global_position = position


func _physics_process(delta):
	if destroyed:
		return
	
	# Move tank
	self.update_linear_velocity()
	self.linear_velocity = self.move_and_slide(self.linear_velocity)
	
	self.position.x = clamp(self.position.x, 0, screen_size.x)
	self.position.y = clamp(self.position.y, 0, screen_size.y)
	
	# Rotate tank body
	var tank_rotation = self.get_tank_rotation()
	self.rotate(tank_rotation * delta)
	
	# Rotate turret
	var target = $Turret.get_global_mouse_position()
	$Turret.aim_at(target)
	
	# Shoot
	if Input.is_action_just_pressed("ui_shoot"):
		$Turret.shoot()


func take_damage(damage):
	self.health -= damage
	
	self.healthBar.update_health_bar(MAX_HEALTH, health)
	audioStreamImpact.play()
	audioStreamImpactExplosion.play()
	
	if health <= 0:
		self.destroy()
		return true
	else:
		return false


func destroy():
	self.destroyed = true
	healthBar.queue_free()
	audioStreamExplosion.play()
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Turret.hide()
	$Explosion.play()
	$Explosion.show()


func _on_Explosion_animation_finished():
	$Explosion.hide()


func _on_AudioStreamExplosion_finished():
	self.queue_free()
	emit_signal("player_dead")
