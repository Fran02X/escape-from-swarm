extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")

##Spawn enemies slightly outside the screen so they walk in.
const SPAWN_MARGIN := 40.0

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.timeout.connect(_spawn_enemy)


func _spawn_enemy() -> void:
	var enemy := ENEMY_SCENE.instantiate()
	
	enemy.position = _random_edge_position()
	add_child(enemy)


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
