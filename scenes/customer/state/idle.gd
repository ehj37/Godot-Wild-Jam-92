extends CustomerState


func enter(_data: Dictionary = {}) -> void:
	customer.animation_player.play("idle")
