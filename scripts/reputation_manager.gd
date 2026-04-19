extends Node

signal reputation_changed(new_value: float)

const INITIAL_REPUTATION: float = 0.5

var _current_reputation: float = INITIAL_REPUTATION


func get_current_reputation() -> float:
	return _current_reputation


func update_reputation(delta: float) -> void:
	var updated_reputation: float = clampf(_current_reputation + delta, 0.0, 1.0)
	if updated_reputation == _current_reputation:
		return

	_current_reputation = updated_reputation
	reputation_changed.emit(_current_reputation)
