extends ShopCatState

const TAIL_FLICK_PROBABILITY: float = 0.3


func enter(_data: Dictionary = {}) -> void:
	shop_cat.animation_player.play("sleep", -1, 0.75)
	await shop_cat.animation_player.animation_finished

	if randf() <= TAIL_FLICK_PROBABILITY:
		transition_to("SleepTailFlick")
	else:
		transition_to("Sleep")
