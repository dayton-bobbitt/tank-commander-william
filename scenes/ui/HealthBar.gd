extends Node2D


func _ready():
	self.hide()


func update_health_bar(totalHealth: float, currentHealth: float):
	var healthPercent = currentHealth / totalHealth
	
	if healthPercent < 1:
		self.show()
	else:
		self.hide()
	
	$Current.rect_size.x *= healthPercent
