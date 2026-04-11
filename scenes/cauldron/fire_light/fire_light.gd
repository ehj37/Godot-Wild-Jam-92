extends Node2D

@export var noise_texture: NoiseTexture2D

var _time_passed: float = 0.0

@onready var _sprite_flicker: Sprite2D = $SpriteFlicker


func _process(delta: float) -> void:
	_time_passed += delta
	var sampled_noise: float = abs(noise_texture.noise.get_noise_1d(_time_passed))
	_sprite_flicker.modulate.a = sampled_noise
