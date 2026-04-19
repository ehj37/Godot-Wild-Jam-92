extends CustomerState


func enter(data: Dictionary = {}) -> void:
	var animation_player: AnimationPlayer = customer.get_animation_player()
	animation_player.play("order")
	await animation_player.animation_finished

	var recipe_at_time_of_order: Dictionary = data.get("recipe_at_time_of_order")
	var price_at_time_of_order: int = data.get("price_at_time_of_order")
	transition_to(
		"Sip",
		{
			"recipe_at_time_of_order": recipe_at_time_of_order,
			"price_at_time_of_order": price_at_time_of_order
		}
	)
