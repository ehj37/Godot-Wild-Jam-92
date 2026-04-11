class_name CustomerWalkState

extends CustomerState


class TargetData:
	var global_position: Vector2
	var enqueued_state_name: String

	@warning_ignore("shadowed_variable")

	func _init(global_position: Vector2, enqueued_state_name: String) -> void:
		self.global_position = global_position
		self.enqueued_state_name = enqueued_state_name


const WALK_SPEED: float = 15.0

var _target_data: TargetData


func physics_update(delta: float) -> void:
	customer.position.x += WALK_SPEED * delta


func enter(data: Dictionary = {}) -> void:
	if data.has("target_data"):
		_target_data = data.get("target_data")

	customer.animation_player.play("walk")
