extends Node

signal charge_changed(new_charge: float)
signal plan_mode_entered
signal plan_mode_exited
signal off_to_fetch
signal resource_fetched(fetchable: Fetchable, amount: int)

enum Fetchable { PUMPKIN, SPIDER, CORN, COIN }

# TODO: Adjust to more reasonable times before release
const RECHARGE_TIME: float = 6.0  #60.0
const FETCH_TIME: float = 5  #15.0
const FETCHABLE_TO_INGREDIENT: Dictionary = {
	Fetchable.PUMPKIN: RecipeManager.Ingredient.PUMPKIN,
	Fetchable.SPIDER: RecipeManager.Ingredient.SPIDER,
	Fetchable.CORN: RecipeManager.Ingredient.CORN
}
const FETCHABLE_TO_MIN_FETCH_AMOUNT: Dictionary = {
	Fetchable.PUMPKIN: 5,
	Fetchable.SPIDER: 5,
	Fetchable.CORN: 3,
	Fetchable.COIN: 1,
}
const FETCHABLE_TO_MAX_FETCH_AMOUNT: Dictionary = {
	Fetchable.PUMPKIN: 10, Fetchable.SPIDER: 10, Fetchable.CORN: 10, Fetchable.COIN: 20
}

# TODO: May want to set to false to start when I have a main menu
var _update_times: bool = true
var _current_charge_time: float = 0.0
var _is_fetching: bool = false
var _resource_being_fetched: Fetchable
var _current_time_fetching: float = 0.0


func enter_plan_mode() -> void:
	get_tree().paused = true
	plan_mode_entered.emit()


func exit_plan_mode() -> void:
	get_tree().paused = false
	plan_mode_exited.emit()


func get_current_charge() -> float:
	return _current_charge_time


func fetch(fetchable: Fetchable) -> void:
	off_to_fetch.emit()
	_is_fetching = true
	_current_time_fetching = 0
	_resource_being_fetched = fetchable

	_current_charge_time = 0
	charge_changed.emit(_current_charge_time)


func _process(delta: float) -> void:
	if !get_tree().paused && _update_times:
		if _current_charge_time < RECHARGE_TIME:
			_current_charge_time = min(_current_charge_time + delta, RECHARGE_TIME)
			charge_changed.emit(_current_charge_time)

		if _is_fetching && _current_time_fetching < CatManager.FETCH_TIME:
			_current_time_fetching = min(_current_time_fetching + delta, CatManager.FETCH_TIME)
			if _current_time_fetching == CatManager.FETCH_TIME:
				var min_quantity: int = FETCHABLE_TO_MIN_FETCH_AMOUNT.get(_resource_being_fetched)
				var max_quantity: int = FETCHABLE_TO_MAX_FETCH_AMOUNT.get(_resource_being_fetched)
				var fetch_amount: int = randi_range(min_quantity, max_quantity)

				match _resource_being_fetched:
					Fetchable.PUMPKIN, Fetchable.SPIDER, Fetchable.CORN:
						var ingredient: RecipeManager.Ingredient = FETCHABLE_TO_INGREDIENT.get(
							_resource_being_fetched
						)
						InventoryManager.change_ingredient_count(ingredient, fetch_amount)
					Fetchable.COIN:
						InventoryManager.change_coins(fetch_amount)
					_:
						push_error("Unhandled fetchable in CatManager")

				_is_fetching = false
				resource_fetched.emit(_resource_being_fetched, fetch_amount)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	TimeManager.night_started.connect(func() -> void: _update_times = true)
	TimeManager.end_of_night_reached.connect(func() -> void: _update_times = false)
