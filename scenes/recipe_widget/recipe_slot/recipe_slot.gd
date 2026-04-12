class_name RecipeSlot

extends VBoxContainer

enum Ingredient { NONE, PUMPKIN, SPIDER }

const HAS_ENOUGH_OF_INGREDIENT_TEXT_COLOR: Color = Color.WHITE
const LACKING_INGREDIENT_TEXT_COLOR: Color = Color.RED

@export var ingredient: Ingredient:
	set(new_ingredient):
		ingredient = new_ingredient
		_update_ingredient_icon()

@onready var _pumpkin_icon: TextureRect = $Panel/IngredientIconContainer/PumpkinIcon
@onready var _spider_icon: TextureRect = $Panel/IngredientIconContainer/SpiderIcon
@onready var _ingredient_to_icon: Dictionary = {
	Ingredient.PUMPKIN: _pumpkin_icon,
	Ingredient.SPIDER: _spider_icon,
}
@onready var _quantity_slider: HSlider = $QuantitySlider
@onready var _quantity_label: Label = $QuantityLabel


func _ready() -> void:
	_update_ingredient_icon()
	_update_quantity_label()

	if ingredient != Ingredient.NONE:
		var translated_ingredient: RecipeManager.Ingredient = _get_translated_ingredient()
		_quantity_slider.value = RecipeManager.recipe.get(translated_ingredient, 0)

	InventoryManager.ingredient_changed.connect(_on_ingredient_changed)


# Returns -1 if ingredient cannot be translated
func _get_translated_ingredient() -> RecipeManager.Ingredient:
	match ingredient:
		Ingredient.PUMPKIN:
			return RecipeManager.Ingredient.PUMPKIN
		Ingredient.SPIDER:
			return RecipeManager.Ingredient.SPIDER
		Ingredient.NONE:
			@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
			return -1
		_:
			assert(false, "Unhandled recipe slot ingredient.")

	return RecipeManager.Ingredient.PUMPKIN


func _update_ingredient_icon() -> void:
	var icon_to_show: TextureRect = _ingredient_to_icon.get(ingredient)
	var all_icons: Array = _ingredient_to_icon.values()
	for icon: TextureRect in all_icons:
		icon.visible = icon == icon_to_show


func _update_quantity_label() -> void:
	if ingredient == Ingredient.NONE:
		_quantity_label.text = "-"
		return

	var translated_ingredient: RecipeManager.Ingredient = _get_translated_ingredient()
	var recipe_amount: int = RecipeManager.recipe.get(translated_ingredient, 0)
	_quantity_label.text = str(recipe_amount)

	if recipe_amount > InventoryManager.get_ingredient_count(translated_ingredient):
		_quantity_label.add_theme_color_override("font_color", LACKING_INGREDIENT_TEXT_COLOR)
	else:
		_quantity_label.add_theme_color_override("font_color", HAS_ENOUGH_OF_INGREDIENT_TEXT_COLOR)


func _on_ingredient_changed(
	inventory_manager_ingredient: RecipeManager.Ingredient, _new_amount: int, _delta: int
) -> void:
	var translated_ingredient: RecipeManager.Ingredient = _get_translated_ingredient()
	if translated_ingredient == inventory_manager_ingredient:
		_update_quantity_label()


func _on_quantity_slider_value_changed(value: float) -> void:
	if ingredient == Ingredient.NONE:
		push_warning("Slider should be disabled when ingredient is NONE")
		return

	var translated_ingredient: RecipeManager.Ingredient = _get_translated_ingredient()
	var new_quantity: int = int(value)
	RecipeManager.recipe.set(translated_ingredient, new_quantity)
	_update_quantity_label()
