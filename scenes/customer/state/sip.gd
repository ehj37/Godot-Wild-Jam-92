extends CustomerState


func enter(_data: Dictionary = {}) -> void:
	InventoryManager.update_from_order()

	customer.animation_player.play("sip")
	await customer.animation_player.animation_finished

	transition_to("Walk")
