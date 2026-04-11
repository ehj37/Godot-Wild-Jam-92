class_name CustomerWalkState

extends CustomerState

const WALK_SPEED: float = 15.0

var _target_data: Customer.TargetData


func physics_update(delta: float) -> void:
	if customer.global_position == _target_data.global_position:
		_target_data.on_target_reached.call()
	else:
		customer.global_position = customer.global_position.move_toward(
			_target_data.global_position, WALK_SPEED * delta
		)


func enter(data: Dictionary = {}) -> void:
	_target_data = data.get("target_data", customer.default_target_data)
	customer.sprite.flip_h = _target_data.global_position.x < customer.global_position.x
	customer.animation_player.play("walk")
