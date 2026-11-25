extends Node

var _shoot: AudioStreamWAV
var _hit: AudioStreamWAV
var _death: AudioStreamWAV


func _ready() -> void:
	_shoot = sfx.tone(800.0, 0.06, 0.15, true)
	_hit = sfx.noise(0.07, 0.2)
	_death = sfx.tone(220.0, 0.18, 0.22, true)


func play_shoot() -> void:
	_play(_shoot)


func play_hit() -> void:
	_play(_hit)


func play_death() -> void:
	_play(_death)


func _play(stream: AudioStream) -> void:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
