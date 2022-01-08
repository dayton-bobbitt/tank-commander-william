extends StaticBody2D


export var health = 15


func take_damage(damage):
	self.health -= damage
	
	if health <= 0:
		self.destroy()
		return true
	else:
		return false


func destroy():
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.play()
	$Explosion.show()

func _on_Explosion_animation_finished():
	self.queue_free()
