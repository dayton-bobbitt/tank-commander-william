extends KinematicBody2D


export var LINEAR_MAX_SPEED = 1750
export var attackPower = 10


var destroyed = false


func _physics_process(delta):
	if destroyed:
		return
	
	var linear_velocity = Vector2.UP.rotated(self.rotation).normalized() * self.LINEAR_MAX_SPEED
	var collision = self.move_and_collide(linear_velocity * delta)

	if collision != null:
		self.destroyed = true
		
		if collision.collider.has_method("take_damage"):
			var destroyed = collision.collider.take_damage(attackPower)
			
			if !destroyed:
				self.play_hit_animation()
			else:
				self.queue_free()
		elif collision.collider.name == "Bullet":
			collision.collider.queue_free()
			play_hit_animation()


func play_hit_animation():
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.play()
	$Explosion.show()


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_Explosion_animation_finished():
	self.queue_free()
