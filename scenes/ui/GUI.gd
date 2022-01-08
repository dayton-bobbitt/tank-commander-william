extends CanvasLayer


signal start_game


onready var title_screen = $TitleScreen
onready var game_over_screen = $GameOverScreen


func _ready():
	title_screen.show()
	game_over_screen.hide()


func game_in_progress():
	title_screen.hide()
	game_over_screen.hide()


func game_over():
	title_screen.hide()
	game_over_screen.show()


func _on_StartGameButton_pressed():
	self.emit_signal("start_game")


func _on_PlayAgainButton_pressed():
	self.emit_signal("start_game")
