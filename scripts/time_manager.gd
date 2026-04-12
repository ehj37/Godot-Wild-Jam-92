extends Node

signal night_number_changed(new_night_number: int)
# Using 24 hour clock. So 6 PM = 18:00
signal time_changed(new_hour: int, new_minute: int)

const STARTING_HOUR: int = 20
const STARTING_MINUTE: int = 00
const ENDING_HOUR: int = 4
const SECONDS_PER_HOUR: float = 15.0

var _night_number: int = 1
var _hour: int = STARTING_HOUR
var _minute: int = STARTING_MINUTE


func get_night_number() -> int:
	return _night_number


func get_hour() -> int:
	return _hour


func get_minnute() -> int:
	return _minute


func _ready() -> void:
	_tick()


func _tick() -> void:
	await get_tree().create_timer(SECONDS_PER_HOUR / 4).timeout

	_minute = (_minute + 15) % 60
	if _minute == 0:
		_hour = (_hour + 1) % 24

	# Allow 6:00–6:15 AM to happen, and then change the night number
	if _hour == ENDING_HOUR && _minute > 0:
		_hour = STARTING_HOUR
		_minute = STARTING_MINUTE
		_night_number += 1
		night_number_changed.emit(_night_number)

	time_changed.emit(_hour, _minute)
	_tick()
