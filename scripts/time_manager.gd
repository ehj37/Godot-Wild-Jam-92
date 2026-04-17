extends Node

signal night_started
signal end_of_night_reached
# Using 24 hour clock. So 6 PM = 18:00
signal time_changed(new_hour: int, new_minute: int)

const STARTING_HOUR: int = 20
const STARTING_MINUTE: int = 00
const ENDING_HOUR: int = 4
const ENDING_MINUTE: int = 00
const SECONDS_PER_HOUR: float = 1.5  #15.0

var _day_time_range: TimeRange = TimeRange.new().initialize(
	STARTING_HOUR, STARTING_MINUTE, ENDING_HOUR, ENDING_MINUTE
)
var _night_number: int = 1
var _hour: int = STARTING_HOUR
var _minute: int = STARTING_MINUTE


func get_night_number() -> int:
	return _night_number


func get_hour() -> int:
	return _hour


func get_minute() -> int:
	return _minute


func increment_night() -> void:
	_night_number += 1
	_hour = STARTING_HOUR
	_minute = STARTING_MINUTE


func start_night() -> void:
	night_started.emit()
	_tick()


func _ready() -> void:
	start_night()


func _tick() -> void:
	await get_tree().create_timer(SECONDS_PER_HOUR / 4, false).timeout

	_minute = (_minute + 15) % 60
	if _minute == 0:
		_hour = (_hour + 1) % 24

	# A little weird. Would read better to check if the hour and minute came
	# after the end of the range, but eh, if it works it works.
	if !_day_time_range.contains(_hour, _minute):
		#_hour = STARTING_HOUR
		#_minute = STARTING_MINUTE
		#_night_number += 1
		end_of_night_reached.emit()
		return

	time_changed.emit(_hour, _minute)
	_tick()
