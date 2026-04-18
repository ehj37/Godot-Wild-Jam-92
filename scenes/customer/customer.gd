class_name Customer

extends Node2D


class TargetData:
	var global_position: Vector2
	var on_target_reached: Callable

	@warning_ignore("shadowed_variable")

	func _init(global_position: Vector2, on_target_reached: Callable) -> void:
		self.global_position = global_position
		self.on_target_reached = on_target_reached


enum CustomerType { FRANK, SKELLY, PHANTOM }

const MIN_DELAY_BEFORE_CONSIDER: float = 0.5
const MAX_DELAY_BEFORE_CONSIDER: float = 4.5
const CONSIDER_PROBABILITY: float = 0.9

var customer_type: CustomerType
var default_target_data: TargetData
var _consider_triggered: bool = false

@onready var _state_machine: StateMachine = $StateMachine
@onready var _sprite_frank: Sprite2D = $SpriteFrank
@onready var _frank_animation_player: AnimationPlayer = $FrankAnimationPlayer
@onready var _sprite_skelly: Sprite2D = $SpriteSkelly
@onready var _skelly_animation_player: AnimationPlayer = $SkellyAnimationPlayer
@onready var _sprite_phantom: Sprite2D = $SpritePhantom
@onready var _phantom_animation_player: AnimationPlayer = $PhantomAnimationPlayer


func get_animation_player() -> AnimationPlayer:
	var animation_player: AnimationPlayer
	match customer_type:
		CustomerType.FRANK:
			animation_player = _frank_animation_player
		CustomerType.SKELLY:
			animation_player = _skelly_animation_player
		CustomerType.PHANTOM:
			animation_player = _phantom_animation_player
		_:
			push_error("Unhandled customer type in Customer#get_animation_player")
	return animation_player


func get_sprite() -> Sprite2D:
	var sprite: Sprite2D
	match customer_type:
		CustomerType.FRANK:
			sprite = _sprite_frank
		CustomerType.SKELLY:
			sprite = _sprite_skelly
		CustomerType.PHANTOM:
			sprite = _sprite_phantom
		_:
			push_error("Unhandled customer type in Customer#get_animation_player")

	return sprite


func _ready() -> void:
	get_sprite().visible = true

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
