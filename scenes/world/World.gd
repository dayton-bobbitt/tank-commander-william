extends Node2D


export (PackedScene) var enemy_path
export (PackedScene) var enemy_tank
export (PackedScene) var player_scene


onready var horizontal_road = $HorizontalRoad
onready var vertical_road = $VerticalRoad
onready var spawn_timer = $SpawnTimer
onready var player_spawn = $PlayerSpawn
onready var gui = $GUI
onready var roads = [horizontal_road, vertical_road]
var player
var enemies = []


func _ready():
	randomize()


func start_game():
	spawn_player()
	spawn_enemy()
	spawn_timer.start()
	gui.game_in_progress()


func spawn_player():
	player = player_scene.instance()
	player.position = player_spawn.position
	player.connect("player_dead", self, "game_over")
	add_child(player)


func game_over():
	spawn_timer.stop()
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	
	enemies = []
	gui.game_over()


func spawn_enemy():
	# Choose a random road
	roads.shuffle()
	
	var random_road = roads[0]
	
	var enemy = enemy_tank.instance()
	
	enemy.rotation = PI / 2
	enemies.append(enemy)
	
	var path = enemy_path.instance()
	
	path.add_child(enemy)
	random_road.add_child(path)


func _physics_process(delta):
	for i in range(enemies.size()):
		var enemy = enemies[i]
		if is_instance_valid(enemy) && is_instance_valid(player):
			enemy.aim_at(player.position, delta)


func _on_SpawnTimer_timeout():
	spawn_enemy()
	pass


func _on_GUI_start_game():
	start_game()
