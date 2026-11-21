class_name Bullet
extends Area2D

@export var lifetime: float = 3.0

var direction := Vector2.RIGHT
var speed := 500.0

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
		body.take_damage(1)
		queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 3.0, Color("ffd866"))
