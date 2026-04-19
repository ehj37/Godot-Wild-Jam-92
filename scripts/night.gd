class_name Night

extends Control

var night_config: NightConfig

@onready var _customer_spawner_packed_scene: PackedScene = preload(
	"res://scenes/customer_spawner/customer_spawner.tscn"
)
@onready var _customer_spawner_marker: Marker2D = $CustomerSpawnerMarker
@onready var _end_of_night_dialog: EndOfNightDialog = $EndOfNightDialogContainer/EndOfNightDialog


func _ready() -> void:
	# Just here so things don't explode when night.tscn is run directly
	NightManager.current_night = self
	if night_config == null:
		push_warning("night_config not defined, defaulting to night 1 config")
		night_config = NightManager.get_night_config(TimeManager.get_night_number())

	for customer_spawn_period: CustomerSpawnPeriod in night_config.customer_spawn_periods:
		var customer_spawner: CustomerSpawner = _customer_spawner_packed_scene.instantiate()
		customer_spawner.customer_spawn_period = customer_spawn_period
		customer_spawner.global_position = _customer_spawner_marker.global_position
		add_child(customer_spawner)

	TimeManager.end_of_night_reached.connect(_on_end_of_night_reached)


func _on_end_of_night_reached() -> void:
	_end_of_night_dialog.fade_in()
	NightManager.switch_to_shop()
