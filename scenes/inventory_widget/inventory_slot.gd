class_name InventorySlot

extends HBoxContainer

@export var ingredient: RecipeManager.Ingredient

@onready var _add_button: TextureButton = $AddButton
@onready var _pumpkin_icon: TextureRect = $Panel/MiniPumpkinIcon
@onready var _spider_icon: TextureRect = $Panel/MiniSpiderIcon
@onready var _corn_icon: TextureRect = $Panel/MiniCornIcon
@onready var _ingredient_to_icon: Dictionary = {
	RecipeManager.Ingredient.PUMPKIN: _pumpkin_icon,
	RecipeManager.Ingredient.SPIDER: _spider_icon,
	RecipeManager.Ingredient.CORN: _corn_icon
}
@onready var _quantity_label: Label = $QuantityLabel


func _ready() -> void:
	_update_icon()
	var initial_ingredient_count: int = InventoryManager.get_ingredient_count(ingredient)
	_quantity_label.text = str(initial_ingredient_count)
	_add_button.disabled = _can_add_ingredient()

	InventoryManager.ingredient_changed.connect(_on_ingredient_changed)
	RecipeManager.recipe_changed.connect(_on_recipe_changed)


func _update_icon() -> void:
	for ingredient_with_icon: RecipeManager.Ingredient in _ingredient_to_icon.keys():
		var icon: TextureRect = _ingredient_to_icon.get(ingredient_with_icon)
		icon.visible = ingredient == ingredient_with_icon


func _can_add_ingredient() -> bool:
	var in_recipe: bool = RecipeManager.get_required_amount_for(ingredient) > 0
	var at_ingredient_limit: bool = (
		RecipeManager.get_ingredients().size() == RecipeManager.MAX_ALLOWED_INGREDIENTS
	)
	return in_recipe || at_ingredient_limit


func _on_ingredient_changed(
	changed_ingredient: RecipeManager.Ingredient, new_amount: int, _delta: int
) -> void:
	if changed_ingredient != ingredient:
		return

	_quantity_label.text = str(new_amount)
	_add_button.disabled = _can_add_ingredient()


func _on_recipe_changed() -> void:
	_add_button.disabled = _can_add_ingredient()


func _on_add_button_pressed() -> void:
	RecipeManager.change_required_amount(ingredient, 1)
