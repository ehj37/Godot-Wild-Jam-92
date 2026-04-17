extends Node

signal order_fulfilled(price: int)
signal coins_changed(new_amount: int, delta: int)
signal ingredient_changed(ingredient: RecipeManager.Ingredient, new_amount: int, delta: int)

const INITIAL_COINS: int = 0
const INITIAL_CUPS: int = 20
const INITIAL_PUMPKINS: int = 20
const INITIAL_SPIDERS: int = 5
const INITIAL_CORN: int = 2

var _coins: int = INITIAL_COINS
var _pumpkins: int = INITIAL_PUMPKINS
var _spiders: int = INITIAL_SPIDERS
var _corn: int = INITIAL_CORN

@onready
var _coin_add_sound_effect_config: SoundEffectConfig = preload("res://sound_effects/coin_add.tres")


func get_ingredient_count(ingredient: RecipeManager.Ingredient) -> int:
	match ingredient:
		RecipeManager.Ingredient.PUMPKIN:
			return _pumpkins
		RecipeManager.Ingredient.SPIDER:
			return _spiders
		RecipeManager.Ingredient.CORN:
			return _corn
		_:
			assert(false, "Unhandled ingredient in InventoryManager.get_ingredient_count")

	return 0


func change_ingredient_count(ingredient: RecipeManager.Ingredient, delta: int) -> void:
	if delta == 0:
		return

	match ingredient:
		RecipeManager.Ingredient.PUMPKIN:
			_pumpkins += delta
			ingredient_changed.emit(ingredient, _pumpkins, delta)
		RecipeManager.Ingredient.SPIDER:
			_spiders += delta
			ingredient_changed.emit(ingredient, _spiders, delta)
		RecipeManager.Ingredient.CORN:
			_corn += delta
			ingredient_changed.emit(ingredient, _corn, delta)
		_:
			assert(false, "Unhandled ingredient in InventoryManager.change_ingredient_count")


func has_enough_for_order() -> bool:
	for ingredient: RecipeManager.Ingredient in RecipeManager.Ingredient.values():
		if get_ingredient_count(ingredient) < RecipeManager.get_required_amount_for(ingredient):
			return false

	return true


func update_from_order() -> void:
	var current_price: int = PriceManager.current_price
	change_coins(current_price)

	for ingredient: RecipeManager.Ingredient in RecipeManager.Ingredient.values():
		var amount: int = RecipeManager.get_required_amount_for(ingredient)
		change_ingredient_count(ingredient, -amount)

	order_fulfilled.emit(current_price)


func get_coins() -> int:
	return _coins


func change_coins(amount: int) -> void:
	if amount == 0:
		return

	if amount > 0:
		SoundEffectManager.play(_coin_add_sound_effect_config)

	_coins += amount
	coins_changed.emit(_coins, amount)
