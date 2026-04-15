class_name TimeRange

extends Resource

@export var starting_hour: int
@export var ending_hour: int
@export var starting_minute: int
@export var ending_minute: int


func contains(hour: int, minute: int) -> bool:
	# Ranges assumed to be end-inclusive
	if (
		hour == starting_hour && minute == starting_minute
		|| hour == ending_hour && minute == ending_minute
	):
		return true

	return (
		_is_after(hour, minute, starting_hour, starting_minute)
		&& !_is_after(hour, minute, ending_hour, ending_minute)
	)


# This is weird, but attempting to override _init makes trouble for export vars
@warning_ignore("shadowed_variable")


func initialize(
	starting_hour: int, starting_minute: int, ending_hour: int, ending_minute: int
) -> TimeRange:
	self.starting_hour = starting_hour
	self.starting_minute = starting_minute
	self.ending_hour = ending_hour
	self.ending_minute = ending_minute

	return self


# Assumes that any AM values come AFTER a PM value (since the night progresses
# from PM to AM)
func _is_after(
	comparison_hour: int, comparison_minute: int, reference_hour: int, reference_minute: int
) -> bool:
	if comparison_hour == reference_hour:
		return comparison_minute > reference_minute
	# Both in PM
	if comparison_hour >= 12 && reference_hour >= 12:
		if comparison_hour == reference_hour:
			return comparison_minute > reference_minute

		return comparison_hour > reference_hour
	# Comparison in PM, reference in AM
	if comparison_hour >= 12 && reference_hour < 12:
		return false
	# Comparison in AM, reference in PM
	if comparison_hour < 12 && reference_hour >= 12:
		return true
	# Both in AM
	return (
		(comparison_hour == reference_hour && comparison_minute > reference_minute)
		|| (comparison_hour > reference_hour)
	)
