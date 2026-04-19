extends CustomerState

const ORDER_PROBABILITY: float = 0.9


func enter(_data: Dictionary = {}) -> void:
	var animation_player: AnimationPlayer = customer.get_animation_player()
	animation_player.play("consider")
	await animation_player.animation_finished

	if InventoryManager.has_enough_for_order() && randf() <= ORDER_PROBABILITY:
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
		var price_at_time_of_order: int = PriceManager.current_price
		var target_data: Customer.TargetData = Customer.TargetData.new(
			target,
			func() -> void: state_machine.transition_to(
				"Order",
				{
					"recipe_at_time_of_order": recipe_at_time_of_order,
					"price_at_time_of_order": price_at_time_of_order
				}
			)
		)
		transition_to("Walk", {"target_data": target_data})
	else:
		transition_to("Walk")
