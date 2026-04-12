extends CustomerState


func enter(_data: Dictionary = {}) -> void:
	InventoryManager.add_coins(1)

	customer.animation_player.play("sip")
	await customer.animation_player.animation_finished

	transition_to("Walk")
