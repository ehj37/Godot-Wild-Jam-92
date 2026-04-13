extends CustomerState


func enter(_data: Dictionary = {}) -> void:
	customer.animation_player.play("order")
	await customer.animation_player.animation_finished

	transition_to("Sip")
