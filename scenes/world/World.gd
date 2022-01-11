extends Node2D


export (PackedScene) var enemy_path
export (PackedScene) var enemy_tank
export (PackedScene) var player_scene


onready var horizontal_road = $HorizontalRoad
onready var vertical_road = $VerticalRoad
onready var spawn_timer = $SpawnTimer
onready var player_spawn = $PlayerSpawn
onready var roads = [horizontal_road, vertical_road]
var game_over_scene = load("res://scenes/ui/GameOver.tscn")
var player
var enemies = []
var score = 0


func _ready():
	randomize()
	start_game()


func start_game():
	spawn_player()
	spawn_enemy()
	spawn_timer.start()


func spawn_player():
	player = player_scene.instance()
	player.global_position = player_spawn.position
	player.connect("player_dead", self, "game_over")
	add_child(player)


func game_over():
	var game_over = game_over_scene.instance()
	game_over.score = score
	add_child(game_over)


func spawn_enemy():
	# Choose a random road
	roads.shuffle()
	
	var random_road = roads[0]
	
	var enemy = enemy_tank.instance()
	enemy.connect("enemy_dead", self, "update_score")
	enemy.player = player
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


func update_score():
	score += 1
	$Score.text = "Score: %d" % score


func _on_SpawnTimer_timeout():
	spawn_enemy()
