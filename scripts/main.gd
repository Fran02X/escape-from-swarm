extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")

## Spawn enemies slightly outside the screen so they walk in.
const SPAWN_MARGIN := 40.0
const WAVE_DURATION := 20.0
const BASE_SPAWN_INTERVAL := 1.2
const MIN_SPAWN_INTERVAL := 0.25
const SPAWN_INTERVAL_STEP := 0.08
const SPEED_GROWTH_PER_WAVE := 0.06
const HEALTH_PER_WAVES := 3

const SAVE_PATH := "user://save.cfg"
const SAVE_SECTION := "progress"
const SAVE_KEY := "high_score"

@onready var spawn_timer: Timer = $SpawnTimer
@onready var player: CharacterBody2D = $Player
@onready var score_label: Label = $HUD/ScoreLabel
@onready var health_label: Label = $HUD/HealthLabel
@onready var wave_label: Label = $HUD/WaveLabel
@onready var game_over_label: Label = $HUD/GameOverLabel
@onready var best_label: Label = $HUD/BestLabel

var score := 0
var high_score := 0
var wave := 1
var game_over := false

var _wave_time_left := WAVE_DURATION



func _ready() -> void:
	spawn_timer.timeout.connect(_spawn_enemy)
	player.died.connect(_on_player_died)
	high_score = _load_high_score()
	best_label.text = "Best: %d" % high_score
	_update_hud()
	_apply_wave_difficulty()


func _process(delta: float) -> void:
	health_label.text = "HP: %d" % maxi(player.health, 0)
	if game_over:
		return
	_wave_time_left -= delta
	if _wave_time_left <= 0.0:
		_start_next_wave()
	else:
		wave_label.text = "Wave %d (%ds)" % [wave, ceili(_wave_time_left)]


func _start_next_wave() -> void:
	wave += 1
	_wave_time_left = WAVE_DURATION
	_apply_wave_difficulty()


func _apply_wave_difficulty() -> void:
	spawn_timer.wait_time = maxf(MIN_SPAWN_INTERVAL, BASE_SPAWN_INTERVAL - (wave - 1) * SPAWN_INTERVAL_STEP)


func _spawn_enemy() -> void:
	if game_over:
		return
	
	var enemy: Enemy = ENEMY_SCENE.instantiate() as Enemy
	enemy.position = _random_edge_position()
	enemy.speed *= 1.0 + (wave - 1) * SPEED_GROWTH_PER_WAVE
	enemy.health += int((wave - 1) / float(HEALTH_PER_WAVES))
	enemy.died.connect(_on_enemy_died)
	add_child(enemy)


func _on_player_died() -> void:
	game_over = true
	spawn_timer.stop()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	if score > high_score:
		high_score = score
		best_label.text = "Best: %d" % high_score
		_save_high_score()
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


func _load_high_score() -> int:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return 0
	return int(config.get_value(SAVE_SECTION, SAVE_KEY, 0))


func _save_high_score() -> void:
	var config := ConfigFile.new()
	config.set_value(SAVE_SECTION, SAVE_KEY, high_score)
	config.save(SAVE_PATH)
