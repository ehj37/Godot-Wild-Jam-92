class_name NightTransitionScreen

extends Control

var _current_order: Dictionary = {
	RecipeManager.Ingredient.PUMPKIN: 0,
	RecipeManager.Ingredient.SPIDER: 0,
	RecipeManager.Ingredient.CORN: 0
}

@onready var _previous_night_summary: CenterContainer = $PreviousNightSummary
@onready var _night_number_label: Label = get_node(
	"PreviousNightSummary/VBoxContainer/NightDescriptorContainer/NightNumberLabel"
)
@onready var _cups_sold_quantity_label: Label = get_node(
	"PreviousNightSummary/VBoxContainer/StatsContainer/Quantities/CupsSoldLabel"
)
@onready var _coins_earned_quantity_label: Label = get_node(
	"PreviousNightSummary/VBoxContainer/StatsContainer/Quantities/CoinsEarnedLabel"
)
@onready var _shop: CenterContainer = $Shop
@onready var _pumpkin_current_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/CurrentColumn/PumpkinCurrentLabel"
)
@onready var _spider_current_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/CurrentColumn/SpiderCurrentLabel"
)
@onready var _corn_current_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/CurrentColumn/CornCurrentLabel"
)
@onready var _pumpkin_ordered_widget: OrderedWidget = get_node(
	"Shop/VBoxContainer/IngredientContainer/OrderedColumn/PumpkinOrderedWidget"
)
@onready var _spider_ordered_widget: OrderedWidget = get_node(
	"Shop/VBoxContainer/IngredientContainer/OrderedColumn/SpiderOrderedWidget"
)
@onready var _corn_ordered_widget: OrderedWidget = get_node(
	"Shop/VBoxContainer/IngredientContainer/OrderedColumn/CornOrderedWidget"
)
@onready var _ordered_widgets: Array[OrderedWidget] = [
	_pumpkin_ordered_widget, _spider_ordered_widget, _corn_ordered_widget
]
@onready var _pumpkin_cost_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/CostColumn/PumpkinCostLabel"
)
@onready var _spider_cost_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/CostColumn/SpiderCostLabel"
)
@onready var _corn_cost_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/CostColumn/CornCostLabel"
)
@onready var _pumpkin_new_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/NewColumn/PumpkinNewLabel"
)
@onready var _spider_new_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/NewColumn/SpiderNewLabel"
)
@onready var _corn_new_label: Label = get_node(
	"Shop/VBoxContainer/IngredientContainer/NewColumn/CornNewLabel"
)


func _ready() -> void:
	var night_number: int = TimeManager.get_night_number()
	_night_number_label.text = "NIGHT " + str(night_number)
	var night_stats: StatsManager.NightStats = StatsManager.get_night_stats(night_number)
	_cups_sold_quantity_label.text = str(night_stats.cups_sold)
	_coins_earned_quantity_label.text = str(night_stats.coins_earned)

	_pumpkin_current_label.text = str(
		InventoryManager.get_ingredient_count(RecipeManager.Ingredient.PUMPKIN)
	)
	_spider_current_label.text = str(
		InventoryManager.get_ingredient_count(RecipeManager.Ingredient.SPIDER)
	)
	_corn_current_label.text = str(
		InventoryManager.get_ingredient_count(RecipeManager.Ingredient.CORN)
	)

	_pumpkin_cost_label.text = "0"
	_spider_cost_label.text = "0"
	_corn_cost_label.text = "0"

	_pumpkin_new_label.text = _pumpkin_current_label.text
	_spider_new_label.text = _spider_current_label.text
	_corn_new_label.text = _corn_current_label.text

	_previous_night_summary.visible = true
	_shop.visible = false


func _get_order_cost() -> int:
	var total_cost: int = 0
	for ingredient: RecipeManager.Ingredient in _current_order:
		var price: int = InventoryManager.INGREDIENT_TO_PRICE.get(ingredient)
		var quantity: int = _current_order.get(ingredient)
		total_cost += price * quantity

	return total_cost


func _place_order() -> void:
	var order_cost: int = _get_order_cost()
	InventoryManager.change_coins(-order_cost)


func _on_shop_button_pressed() -> void:
	_previous_night_summary.visible = false
	_shop.visible = true


func _on_start_night_button_pressed() -> void:
	for ingredient: RecipeManager.Ingredient in _current_order:
		InventoryManager.change_coins(_get_order_cost())
		var order_ingredient_count: int = _current_order.get(ingredient)
		InventoryManager.change_ingredient_count(ingredient, order_ingredient_count)

	NightManager.start_next_night()


func _on_ordered_quantity_changed(ingredient: RecipeManager.Ingredient, new_quantity: int) -> void:
	_current_order.set(ingredient, new_quantity)
	var order_cost: int = _get_order_cost()
	for ordered_widget: OrderedWidget in _ordered_widgets:
		ordered_widget.adjust_for(order_cost)

	var total_quantity_text: String = str(
		InventoryManager.get_ingredient_count(ingredient) + new_quantity
	)
	var total_cost_text: String = str(
		InventoryManager.INGREDIENT_TO_PRICE.get(ingredient) * new_quantity
	)
	match ingredient:
		RecipeManager.Ingredient.PUMPKIN:
			_pumpkin_new_label.text = total_quantity_text
			_pumpkin_cost_label.text = total_cost_text
		RecipeManager.Ingredient.SPIDER:
			_spider_new_label.text = total_quantity_text
			_spider_cost_label.text = total_cost_text
		RecipeManager.Ingredient.CORN:
			_corn_new_label.text = total_quantity_text
			_corn_cost_label.text = total_cost_text
