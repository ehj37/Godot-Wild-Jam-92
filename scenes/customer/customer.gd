class_name Customer

extends Node2D


class TargetData:
	var global_position: Vector2
	var on_target_reached: Callable

	@warning_ignore("shadowed_variable")

	func _init(global_position: Vector2, on_target_reached: Callable) -> void:
		self.global_position = global_position
		self.on_target_reached = on_target_reached


const MIN_DELAY_BEFORE_CONSIDER: float = 0.5
const MAX_DELAY_BEFORE_CONSIDER: float = 4.5
const CONSIDER_PROBABILITY: float = 0.9

var default_target_data: TargetData
var _consider_triggered: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var _state_machine: StateMachine = $StateMachine


func _ready() -> void:
	var target_position: Vector2 = Vector2(NightManager.CUSTOMER_DESPAWN_X, global_position.y)
	default_target_data = TargetData.new(target_position, func() -> void: queue_free())


func _on_consider_area_detector_area_entered(_area: Area2D) -> void:
	if randf() <= CONSIDER_PROBABILITY && !_consider_triggered:
		_consider_triggered = true

		var delay_before_consider: float = randf_range(
			MIN_DELAY_BEFORE_CONSIDER, MAX_DELAY_BEFORE_CONSIDER
		)
		await get_tree().create_timer(delay_before_consider).timeout

		if InventoryManager.has_enough_for_order():
			_state_machine.transition_to("Consider")
