@tool

class_name CustomerSpawner

extends Node2D

const MAX_Y_OFFSET: float = 20.0

@export var disabled: bool = false

var customer_spawn_period: CustomerSpawnPeriod

@onready var _customer_packed_scene: PackedScene = preload("res://scenes/customer/customer.tscn")
@onready var _spawn_roll_timer: Timer = $SpawnRollTimer


func _ready() -> void:
	assert(customer_spawn_period != null, "Must define customer_spawn_period for CustomerSpawner")

	if disabled:
		return

	_spawn_roll_timer.wait_time = customer_spawn_period.spawn_roll_cadence
	TimeManager.time_changed.connect(_on_time_changed)
	# Call manually once for start of game
	_on_time_changed(TimeManager.get_hour(), TimeManager.get_minute())


func _on_time_changed(new_hour: int, new_minute: int) -> void:
	if customer_spawn_period.time_range.contains(new_hour, new_minute):
		if _spawn_roll_timer.is_stopped():
			_spawn_roll_timer.start()
	else:
		_spawn_roll_timer.stop()


func _on_spawn_roll_timer_timeout() -> void:
	if randf() <= customer_spawn_period.spawn_roll_probability:
		var customer: Customer = _customer_packed_scene.instantiate()
		customer.customer_type = customer_spawn_period.customer_type

		var y_offset: float = randf_range(-MAX_Y_OFFSET, MAX_Y_OFFSET)
		customer.global_position = global_position + Vector2(0, y_offset)
		NightManager.current_night.add_child(customer)
