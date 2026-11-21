class_name Enemy
extends CharacterBody2D

signal died

## Enemies are slower than the player so they can be dodged.
@export var speed: float = 120.0
@export var health: int = 3

var player: Node2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	var direction := (player.global_position - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		died.emit()
		queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 10.0, Color("e06c75"))
