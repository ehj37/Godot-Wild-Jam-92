class_name CustomerSpawnPeriod

extends Resource

@export var customer_type: Customer.CustomerType
@export_range(0.0, 1.0) var spawn_roll_probability: float
@export var spawn_roll_cadence: float
@export var time_range: TimeRange
