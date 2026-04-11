extends CustomerState

const ORDER_PROBABILITY: float = 1.0


func enter(_data: Dictionary = {}) -> void:
	customer.animation_player.play("consider")
	await customer.animation_player.animation_finished

	if randf() <= ORDER_PROBABILITY:
		var target_data: Customer.TargetData = Customer.TargetData.new(
			LevelManager.ORDER_WINDOW_POSITION, func() -> void: state_machine.transition_to("Sip")
		)
		transition_to("Walk", {"target_data": target_data})
	else:
		transition_to("Walk")
