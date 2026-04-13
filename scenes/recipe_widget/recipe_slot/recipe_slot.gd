class_name RecipeSlot

extends VBoxContainer

enum Ingredient { NONE, PUMPKIN, SPIDER }

const HAS_ENOUGH_OF_INGREDIENT_TEXT_COLOR: Color = Color.WHITE
const LACKING_INGREDIENT_TEXT_COLOR: Color = Color.RED

@export var ingredient: Ingredient:
	set(new_ingredient):
		ingredient = new_ingredient
		if not is_node_ready():
			await ready

		_update_remove_button()
		_update_ingredient_icon()
		_update_quantity_label()
		_update_quantity_slider()

@onready var _remove_button: TextureButton = $Panel/RemoveButton
@onready var _pumpkin_icon: TextureRect = $Panel/IngredientIconContainer/PumpkinIcon
@onready var _spider_icon: TextureRect = $Panel/IngredientIconContainer/SpiderIcon
@onready var _ingredient_to_icon: Dictionary = {
	Ingredient.PUMPKIN: _pumpkin_icon,
	Ingredient.SPIDER: _spider_icon,
}
@onready var _quantity_slider: HSlider = $QuantitySlider
@onready var _quantity_label: Label = $QuantityLabel


func _ready() -> void:
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


func _update_remove_button() -> void:
	_remove_button.visible = ingredient != Ingredient.NONE


func _update_ingredient_icon() -> void:
	var icon_to_show: TextureRect = _ingredient_to_icon.get(ingredient)
	var all_icons: Array = _ingredient_to_icon.values()
	for icon: TextureRect in all_icons:
		icon.visible = icon == icon_to_show


func _update_quantity_label() -> void:
	if ingredient == Ingredient.NONE:
		_quantity_label.text = "-"
		_quantity_label.add_theme_color_override("font_color", HAS_ENOUGH_OF_INGREDIENT_TEXT_COLOR)
		return

	var translated_ingredient: RecipeManager.Ingredient = _get_translated_ingredient()
	var recipe_amount: int = RecipeManager.get_required_amount_for(translated_ingredient)
	_quantity_label.text = str(recipe_amount)

	if recipe_amount > InventoryManager.get_ingredient_count(translated_ingredient):
		_quantity_label.add_theme_color_override("font_color", LACKING_INGREDIENT_TEXT_COLOR)
	else:
		_quantity_label.add_theme_color_override("font_color", HAS_ENOUGH_OF_INGREDIENT_TEXT_COLOR)


func _update_quantity_slider() -> void:
	if ingredient == Ingredient.NONE:
		_quantity_slider.visible = false
		return

	_quantity_slider.visible = true
	var translated_ingredient: RecipeManager.Ingredient = _get_translated_ingredient()
	_quantity_slider.value = RecipeManager.get_required_amount_for(translated_ingredient)


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
	RecipeManager.change_required_amount(translated_ingredient, new_quantity)
	_update_quantity_label()


func _on_remove_button_pressed() -> void:
	var translated_ingredient: RecipeManager.Ingredient = _get_translated_ingredient()
	RecipeManager.change_required_amount(translated_ingredient, 0)
	ingredient = Ingredient.NONE
	_update_ingredient_icon()
	_update_remove_button()
	_update_quantity_label()
