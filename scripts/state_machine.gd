class_name StateMachine

extends Node

@export var initial_state: State
@export var initial_state_data: Dictionary = {}

var current_state: State
var _states: Array[State] = []


func transition_to(state_name: String, data: Dictionary = {}) -> void:
	var new_state_i: int = _states.find_custom(func(s: State) -> bool: return s.name == state_name)
	if new_state_i == -1:
		push_error("State " + state_name + " not found, could now transition state.")

	var new_state: State = _states[new_state_i]
	current_state.exit()
	current_state = new_state
	current_state.enter(data)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func _process(delta: float) -> void:
	current_state.update(delta)


func _ready() -> void:
	await owner.ready

	for child: Node in get_children():
		if child is State:
			(child as State).state_machine = self
			_states.append(child)
		else:
			push_warning("State machine has non-State child.")

	if _states.size() == 0:
		push_error("State machine must have at least one state.")

	if initial_state == null:
		push_warning("Initial state not set on state machine, defaulting to first.")
		initial_state = _states[0]

	current_state = initial_state

	initial_state.enter(initial_state_data)
