extends Node2D

const MIN_RATIO_BACK: float = 0.15
const MIN_RATIO_FRONT: float = 0.15
const RATIO_GROW_AMOUNT: float = 0.1
const RATIO_DECAY_AMOUNT: float = 0.15

@onready var _back_particles: GPUParticles2D = $BackParticles
@onready var _front_particles: GPUParticles2D = $FrontParticles
@onready var _decay_timer: Timer = $DecayTimer


func _ready() -> void:
	_back_particles.amount_ratio = MIN_RATIO_BACK
	_front_particles.amount_ratio = MIN_RATIO_FRONT

	InventoryManager.order_fulfilled.connect(_on_order_fulfilled)


func _on_order_fulfilled(_price: int) -> void:
	_decay_timer.start()

	_back_particles.amount_ratio = min(_back_particles.amount_ratio + RATIO_GROW_AMOUNT, 1.0)
	_front_particles.amount_ratio = min(_front_particles.amount_ratio + RATIO_GROW_AMOUNT, 1.0)


func _on_decay_timer_timeout() -> void:
	_back_particles.amount_ratio = max(
		_back_particles.amount_ratio - RATIO_DECAY_AMOUNT, MIN_RATIO_BACK
	)
	_front_particles.amount_ratio = max(
		_front_particles.amount_ratio - RATIO_DECAY_AMOUNT, MIN_RATIO_FRONT
	)
