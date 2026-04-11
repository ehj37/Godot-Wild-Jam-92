extends CustomerState


func enter(_data: Dictionary = {}) -> void:
	customer.animation_player.play("decide")
	await customer.animation_player.animation_finished

	if true:
		var target_data: CustomerWalkState.TargetData = CustomerWalkState.TargetData.new(
			Vector2.ZERO, "Idle"
		)
		transition_to("Walk", {"target_data": target_data})
