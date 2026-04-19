extends CustomerState

const MIN_ORDER_PROBABILITY: float = 0.1
const MAX_ORDER_PROBABILITY: float = 0.9
const REPUTATION_PROBABILITY_FACTOR: float = 1.75
const PROBABLITY_HIT_PER_PRICE_UNIT: float = 0.05


func enter(_data: Dictionary = {}) -> void:
	var animation_player: AnimationPlayer = customer.get_animation_player()
	animation_player.play("consider")
	await animation_player.animation_finished

	var reputation: float = ReputationManager.get_current_reputation()
	var price: int = PriceManager.current_price
	var order_probability: float = max(
		min(
			reputation * REPUTATION_PROBABILITY_FACTOR - price * PROBABLITY_HIT_PER_PRICE_UNIT,
			MAX_ORDER_PROBABILITY
		),
		MIN_ORDER_PROBABILITY
	)

	if InventoryManager.has_enough_for_order() && randf() <= order_probability:
		# Immediately update inventory so no order goes unfilfilled
		InventoryManager.update_from_order()

		var order_window_x_offset: float = randf_range(
			-NightManager.ORDER_WINDOW_MAX_X_VARIANCE, NightManager.ORDER_WINDOW_MAX_X_VARIANCE
		)
		var order_window_y_offset: float = randf_range(
			-NightManager.ORDER_WINDOW_MAX_Y_VARIANCE, NightManager.ORDER_WINDOW_MAX_Y_VARIANCE
		)
		var target: Vector2 = (
			NightManager.ORDER_WINDOW_POSITION
			+ Vector2(order_window_x_offset, order_window_y_offset)
		)

		# Recipe/price may change by Order/Sip
		var recipe_at_time_of_order: Dictionary = RecipeManager.get_recipe()
		var target_data: Customer.TargetData = Customer.TargetData.new(
			target,
			func() -> void: state_machine.transition_to(
				"Order",
				{
					"recipe_at_time_of_order": recipe_at_time_of_order,
					"price_at_time_of_order": price
				}
			)
		)
		transition_to("Walk", {"target_data": target_data})
	else:
		transition_to("Walk")
