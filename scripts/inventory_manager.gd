extends Node

signal coins_changed(new_amount: int, delta: int)
signal ingredient_changed(ingredient: RecipeManager.Ingredient, new_amount: int, delta: int)

const INITIAL_COINS: int = 0
const INITIAL_CUPS: int = 20
const INITIAL_PUMPKINS: int = 20
const INITIAL_SPIDERS: int = 5

var _coins: int = INITIAL_COINS
var _pumpkins: int = INITIAL_PUMPKINS
var _spiders: int = INITIAL_SPIDERS


func get_ingredient_count(ingredient: RecipeManager.Ingredient) -> int:
	match ingredient:
		RecipeManager.Ingredient.PUMPKIN:
			return _pumpkins
		RecipeManager.Ingredient.SPIDER:
			return _spiders
		_:
			assert(false, "Unhandled ingredient in InventoryManager.get_ingredient_count")

	return 0


func change_ingredient_count(ingredient: RecipeManager.Ingredient, delta: int) -> void:
	match ingredient:
		RecipeManager.Ingredient.PUMPKIN:
			_pumpkins += delta
			ingredient_changed.emit(ingredient, _pumpkins, delta)
		RecipeManager.Ingredient.SPIDER:
			_spiders += delta
			ingredient_changed.emit(ingredient, _spiders, delta)
		_:
			assert(false, "Unhandled ingredient in InventoryManager.change_ingredient_count")


func update_from_order() -> void:
	_coins += PriceManager.current_price

	var recipe: Dictionary = RecipeManager.recipe
	for ingredient: RecipeManager.Ingredient in recipe.keys():
		var amount: int = recipe.get(ingredient)
		change_ingredient_count(ingredient, -amount)


func get_coins() -> int:
	return _coins


func change_coins(amount: int) -> void:
	if amount == 0:
		return

	_coins += amount
	coins_changed.emit(_coins, amount)
