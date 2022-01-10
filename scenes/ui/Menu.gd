extends CanvasLayer


func _on_StartGameButton_pressed():
	get_tree().change_scene("res://scenes/world/World.tscn")


func _on_LinkButton_pressed():
	$HowToPlay.show()
	
	
func _on_GoBackToMenuButton_pressed():
	$HowToPlay.hide()
