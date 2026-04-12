extends Node2D

@onready
var _pumpkin_quantity_label: Label = $VBoxContainer/IngredientsContainer/PumpkinContainer/PumpkinQuantityLabel
@onready
var _spider_quantity_label: Label = $VBoxContainer/IngredientsContainer/SpiderContainer/SpiderQuantityLabel


func _ready() -> void:
	_update_labels()

	(
		InventoryManager
		. ingredient_changed
		. connect(
			func(_ingredient: RecipeManager.Ingredient, _new_amount: int, _delta: int) -> void: _update_labels()
		)
	)


# TODO
# Not being smart about which labels I'm updating - just doing everything.
# I'm just being lazy, and may want to clean this up.
func _update_labels() -> void:
	_pumpkin_quantity_label.text = str(
		InventoryManager.get_ingredient_count(RecipeManager.Ingredient.PUMPKIN)
	)
	_spider_quantity_label.text = str(
		InventoryManager.get_ingredient_count(RecipeManager.Ingredient.SPIDER)
	)
