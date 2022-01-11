extends Area2D


func _on_ShootingEnabler_area_entered(area):
	var parent_node = area.get_parent()
	
	if is_instance_valid(parent_node) && "canShoot" in parent_node:
		parent_node.canShoot = true
