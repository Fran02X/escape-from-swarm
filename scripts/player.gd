extends CharacterBody2D

## Movement speed in pixels per second.
@export var speed: float = 300.0
##Seconds between shots.
@export var fire_interval: float = 0.4
@export var bullet_speed: float = 500.0

const BULLET_SCENE := preload("res://scenes/bullet.tscn")

var _fire_cooldown := 0.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = direction * speed
	move_and_slide()
	
	_fire_cooldown -= delta
	if _fire_cooldown <= 0.0:
		var target := _find_nearest_enemy()
		if is_instance_valid(target):
			_shoot_at(target)
			_fire_cooldown = fire_interval


func _find_nearest_enemy() -> Node2D:
	var nearest: Node2D = null
	var nearest_distance := INF
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var distance := global_position.distance_squared_to(enemy.global_position)
		
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = enemy
	
	return nearest


func _shoot_at(target: Node2D) -> void:
	var bullet := BULLET_SCENE.instantiate()
	
	bullet.global_position = global_position
	bullet.direction = (target.global_position - global_position).normalized()
	bullet.speed = bullet_speed
	get_tree().current_scene.add_child(bullet)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 12.0, Color("4ec9b0"))
