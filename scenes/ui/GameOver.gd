extends CanvasLayer


var score = 0


func _ready():
	$Control/Score.text = "You destroyed %d enemy tanks!" % score


func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://scenes/world/World.tscn")


func _on_QuitButton_pressed():
	get_tree().quit(0)
