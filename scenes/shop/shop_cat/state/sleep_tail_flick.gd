extends ShopCatState


func enter(_data: Dictionary = {}) -> void:
	shop_cat.animation_player.play("sleep_tail_flick", -1, 0.75)
	await shop_cat.animation_player.animation_finished

	transition_to("Sleep")
