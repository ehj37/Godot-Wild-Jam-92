extends Node

signal recipe_changed
signal ingredient_added(new_ingredient: Ingredient)
signal ingredient_removed(removed_ingredient: Ingredient)

enum Ingredient { PUMPKIN, SPIDER, CORN }

const MAX_ALLOWED_INGREDIENTS: int = 2
const DEFAULT_PUMPKIN_AMOUNT: int = 1
const DEFAULT_RECIPE: Dictionary = { Ingredient.PUMPKIN: DEFAULT_PUMPKIN_AMOUNT }

var _recipe: Dictionary = DEFAULT_RECIPE.duplicate()


# Returns a duplicate of the recipe
func get_recipe() -> Dictionary:
	return _recipe.duplicate()


func get_ingredients() -> Array:
	return _recipe.keys()


func get_required_amount_for(ingredient: Ingredient) -> int:
	return _recipe.get(ingredient, 0)


func change_required_amount(ingredient: Ingredient, amount: int) -> void:
	if amount == get_required_amount_for(ingredient):
		return

	if amount == 0:
		_recipe.erase(ingredient)
		ingredient_removed.emit(ingredient)
	else:
		var new_to_recipe: bool = !_recipe.has(ingredient)
		_recipe.set(ingredient, amount)
		assert(
			_recipe.keys().size() <= MAX_ALLOWED_INGREDIENTS,
			"Cannot add more than " + str(MAX_ALLOWED_INGREDIENTS) + " ingredients to recipe"
		)
		if new_to_recipe:
			ingredient_added.emit(ingredient)

	recipe_changed.emit()
