class_name OrderedWidget

extends VBoxContainer

signal quantity_changed(ingredient: RecipeManager.Ingredient, new_quantity: int)

@export var ingredient: RecipeManager.Ingredient

@onready var _quantity_ordered_label: Label = $QuantityOrderedLabel
@onready var _price_amount_label: Label = $PriceContainer/PriceAmountLabel
@onready var _slider: HSlider = $SliderContainer/HSlider
@onready var _max_quantity_label: Label = $SliderContainer/MaxQuantityLabel


func adjust_for(order_cost: int) -> void:
	var total_coins: int = InventoryManager.get_coins()
	var available_coins: int = total_coins - order_cost
	var price: int = InventoryManager.INGREDIENT_TO_PRICE.get(ingredient)
	@warning_ignore("integer_division")
	var max_additional_units: int = available_coins / price
	var current_quantity: int = int(_slider.value)
	var max_quantity: int = current_quantity + max_additional_units
	_slider.max_value = max_quantity
	_max_quantity_label.text = str(max_quantity)


func _ready() -> void:
	_quantity_ordered_label.text = "0"
	_price_amount_label.text = str(InventoryManager.INGREDIENT_TO_PRICE.get(ingredient))

	_slider.min_value = 0
	# Assumes that the order begins with all 0 quantities
	_slider.value = 0
	var total_coins: int = InventoryManager.get_coins()
	var price: int = InventoryManager.INGREDIENT_TO_PRICE.get(ingredient)
	@warning_ignore("integer_division")
	var max_quantity: int = total_coins / price
	_slider.max_value = max_quantity
	_max_quantity_label.text = str(max_quantity)


func _on_h_slider_value_changed(value: float) -> void:
	var int_value: int = int(value)
	_quantity_ordered_label.text = str(int_value)
	quantity_changed.emit(ingredient, int_value)
