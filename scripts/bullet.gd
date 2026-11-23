class_name Bullet
extends Area2D

@export var lifetime: float = 3.0
@export var damage: int = 1
@export var speed: float = 500.0

var direction := Vector2.RIGHT

var _age := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	_age += delta
	if _age >= lifetime:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 3.0, Color("ffd866"))
