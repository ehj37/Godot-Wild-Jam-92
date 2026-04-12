extends Node

signal coins_changed(new_amount: int)

var _coins: int = 0


func get_coins() -> int:
	return _coins


func subtract_coins(amount: int) -> void:
	if amount == 0:
		return

	_coins -= amount
	coins_changed.emit(_coins + amount, _coins)


func add_coins(amount: int) -> void:
	if amount == 0:
		return

	_coins += amount
	coins_changed.emit(_coins)
