extends CharacterBody2D

signal died

## Movement speed in pixels per second.
@export var speed: float = 300.0
## Seconds between shots.
@export var fire_interval: float = 0.4
@export var max_health: int = 3
@export var contact_damage: int = 1

const BULLET_SCENE := preload("res://scenes/bullet.tscn")
const INVULNERABLE_TIME := 1.0
const INVULNERABLE_ALPHA := 0.35
const BLINK_RATE := 10.0

var health: int
var _fire_cooldown := 0.0
var _invulnerable_time := 0.0

@onready var hurtbox: Area2D = $Hurtbox
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	health = max_health
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)


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
	
	if _invulnerable_time > 0.0:
		_invulnerable_time -= delta
		modulate.a = INVULNERABLE_ALPHA if int(_invulnerable_time * BLINK_RATE) % 2 == 0 else 1.0
		if _invulnerable_time <= 0.0:
			collision_shape.set_deferred("disabled", false)
			modulate.a = 1.0
	else:
		modulate.a = 1.0


func take_damage(amount: int) -> void:
	if _invulnerable_time > 0.0:
		return
	health -= amount
	_invulnerable_time = INVULNERABLE_TIME
	collision_shape.set_deferred("disabled", true)
	if health <= 0:
		_die()


func _die() -> void:
	hide()
	set_physics_process(false)
	hurtbox.set_deferred("monitoring", false)
	died.emit()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		take_damage(contact_damage)


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
	var bullet: Bullet = BULLET_SCENE.instantiate() as Bullet
	
	bullet.global_position = global_position
	bullet.direction = (target.global_position - global_position).normalized()
	get_tree().current_scene.add_child(bullet)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 12.0, Color("4ec9b0"))
