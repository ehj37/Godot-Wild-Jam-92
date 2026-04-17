class_name RecipeWidget

extends Node2D

@onready var _recipe_slot_container: HBoxContainer = $VBoxContainer/RecipeSlotContainer


func _ready() -> void:
	var recipe: Dictionary = RecipeManager.get_recipe()
	var recipe_ingredients: Array = recipe.keys()
	var recipe_slots: Array = _recipe_slot_container.get_children()
	for i: int in recipe_slots.size():
		var recipe_slot: RecipeSlot = recipe_slots[i]
		if i < recipe_ingredients.size():
			var recipe_ingredient: RecipeManager.Ingredient = recipe_ingredients[i]
			recipe_slot.ingredient = _translate_ingredient(recipe_ingredient)
		else:
			recipe_slot.ingredient = RecipeSlot.Ingredient.NONE

	RecipeManager.ingredient_added.connect(_on_ingredient_added)
	RecipeManager.ingredient_removed.connect(_on_ingredient_removed)


func _translate_ingredient(ingredient: RecipeManager.Ingredient) -> RecipeSlot.Ingredient:
	match ingredient:
		RecipeManager.Ingredient.PUMPKIN:
			return RecipeSlot.Ingredient.PUMPKIN
		RecipeManager.Ingredient.SPIDER:
			return RecipeSlot.Ingredient.SPIDER
		RecipeManager.Ingredient.CORN:
			return RecipeSlot.Ingredient.CORN
		_:
			assert(false, "Unhandled ingredient in RecipeWidget")

	return RecipeSlot.Ingredient.NONE


# TODO: I may want to sort post recipe slot update.


func _on_ingredient_added(ingredient: RecipeManager.Ingredient) -> void:
	var recipe_slots: Array = _recipe_slot_container.get_children()
	for recipe_slot: RecipeSlot in recipe_slots:
		if recipe_slot.ingredient == RecipeSlot.Ingredient.NONE:
			recipe_slot.ingredient = _translate_ingredient(ingredient)
			return


func _on_ingredient_removed(ingredient: RecipeManager.Ingredient) -> void:
	var translated_ingredient: RecipeSlot.Ingredient = _translate_ingredient(ingredient)
	var recipe_slots: Array = _recipe_slot_container.get_children()
	for recipe_slot: RecipeSlot in recipe_slots:
		if recipe_slot.ingredient == translated_ingredient:
			recipe_slot.ingredient = RecipeSlot.Ingredient.NONE
			return
