extends CustomerState


func enter(_data: Dictionary = {}) -> void:
	var animation_player: AnimationPlayer = customer.get_animation_player()
	animation_player.play("order")
	await animation_player.animation_finished

	transition_to("Sip")
