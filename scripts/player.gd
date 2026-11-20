extends CharacterBody2D

## Movement speed in pixels per second.
@export var speed: float = 300.0


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 12.0, Color("4ec9b0"))
