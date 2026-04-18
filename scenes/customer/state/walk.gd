class_name CustomerWalkState

extends CustomerState

const WALK_SPEED: float = 15.0

var _default_target_data: Customer.TargetData
var _target_data: Customer.TargetData


func physics_update(delta: float) -> void:
	if customer.global_position == _target_data.global_position:
		_target_data.on_target_reached.call()
	else:
		customer.global_position = customer.global_position.move_toward(
			_target_data.global_position, WALK_SPEED * delta
		)


func enter(data: Dictionary = {}) -> void:
	_target_data = data.get("target_data", customer.default_target_data)
	var sprite: Sprite2D = customer.get_sprite()
	sprite.flip_h = _target_data.global_position.x < customer.global_position.x
	var animation_player: AnimationPlayer = customer.get_animation_player()
	animation_player.play("walk")


func _ready() -> void:
	super()

	var target_position: Vector2 = Vector2(
		NightManager.CUSTOMER_DESPAWN_X, customer.global_position.y
	)
	_default_target_data = Customer.TargetData.new(target_position, func() -> void: queue_free())
