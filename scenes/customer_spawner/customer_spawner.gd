@tool

extends Node2D

const MAX_Y_OFFSET: float = 20.0

# Spawn a customer with some probability every so often.
@export var spawn_roll_probability: float = 0.5
@export var spawn_roll_cadence: float = 1.0
@export var time_range: TimeRange:
	set(new_time_range):
		time_range = new_time_range
		update_configuration_warnings()

@onready var _customer_packed_scene: PackedScene = preload("res://scenes/customer/customer.tscn")
@onready var _spawn_roll_timer: Timer = $SpawnRollTimer


func _get_configuration_warnings() -> PackedStringArray:
	if time_range == null:
		return ["Time range cannot be null for customer spawner, will result in error."]

	return []


func _ready() -> void:
	assert(time_range != null, "Must define time range for CustomerSpawner")

	_spawn_roll_timer.wait_time = spawn_roll_cadence
	TimeManager.time_changed.connect(_on_time_changed)
	# Call manually once for start of game
	_on_time_changed(TimeManager.get_hour(), TimeManager.get_minute())


func _on_time_changed(new_hour: int, new_minute: int) -> void:
	if time_range.contains(new_hour, new_minute):
		if _spawn_roll_timer.is_stopped():
			_spawn_roll_timer.start()
	else:
		_spawn_roll_timer.stop()


func _on_spawn_roll_timer_timeout() -> void:
	if randf() <= spawn_roll_probability:
		var customer: Customer = _customer_packed_scene.instantiate()

		var y_offset: float = randf_range(-MAX_Y_OFFSET, MAX_Y_OFFSET)
		customer.global_position = global_position + Vector2(0, y_offset)
		NightManager.current_night.add_child(customer)
