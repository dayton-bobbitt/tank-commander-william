extends Area2D


export (PackedScene) var BULLET


var ready_to_shoot = false


func aim_at(target: Vector2, delta: float):
	var angleToTarget = Vector2.UP.angle_to(to_local(target)) * delta * 2
	
	self.rotate(angleToTarget)


func shoot():
	if ready_to_shoot:
		ready_to_shoot = false
		$AudioStream2DCannon.play()
		$ReloadTimer.start()
		play_barrel_flash_anim()
		var bullet = BULLET.instance()
		
		bullet.global_position = $BulletSpawn.global_position
		bullet.rotation = $BulletSpawn.global_rotation
		
		self.get_tree().current_scene.add_child(bullet)


func play_barrel_flash_anim():
	$BarrelFlash.frame = 0
	$BarrelFlash.show()
	$BarrelFlash.play()


func _on_BarrelFlash_animation_finished():
	$BarrelFlash.hide()


func _on_ReloadTimer_timeout():
	ready_to_shoot = true


func _on_VisibilityNotifier2D_screen_entered():
	ready_to_shoot = true
