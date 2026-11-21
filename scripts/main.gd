extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")

## Spawn enemies slightly outside the screen so they walk in.
const SPAWN_MARGIN := 40.0

@onready var spawn_timer: Timer = $SpawnTimer
@onready var player: CharacterBody2D = $Player
@onready var score_label: Label = $HUD/ScoreLabel
@onready var health_label: Label = $HUD/HealthLabel
@onready var game_over_label: Label = $HUD/GameOverLabel

var score := 0
var game_over := false


func _ready() -> void:
	spawn_timer.timeout.connect(_spawn_enemy)
	player.died.connect(_on_player_died)
	_update_hud()


func _process(_delta: float) -> void:
	health_label.text = "HP: %d" % maxi(player.health, 0)


func _spawn_enemy() -> void:
	if game_over:
		return
	
	var enemy: Enemy = ENEMY_SCENE.instantiate() as Enemy
	
	enemy.position = _random_edge_position()
	enemy.died.connect(_on_enemy_died)
	add_child(enemy)


func _on_player_died() -> void:
	game_over = true
	spawn_timer.stop()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	game_over_label.show()


func _on_enemy_died() -> void:
	score += 1
	_update_hud()


func _unhandled_input(event: InputEvent) -> void:
	if game_over and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()


func _update_hud() -> void:
	score_label.text = "Score: %d" % score
	health_label.text = "HP: %d" % player.health


func _random_edge_position() -> Vector2:
	var screen := get_viewport_rect().size
	
	match randi() % 4:
		0: 
			return Vector2(randf_range(0.0, screen.x), -SPAWN_MARGIN)
		1:
			return Vector2(randf_range(0.0, screen.x), screen.y + SPAWN_MARGIN)
		2:
			return Vector2(-SPAWN_MARGIN, randf_range(0.0, screen.y))
		_:
			return Vector2(screen.x + SPAWN_MARGIN, randf_range(0.0, screen.y))
