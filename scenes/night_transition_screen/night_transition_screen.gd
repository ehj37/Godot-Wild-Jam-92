class_name NightTransitionScreen

extends Control

# Splitting the string up in this way because my formatter gets angry
const _SHOP_CONTAINER_BASE_PATH: String = (
	"NextNightSetupContainer/VBoxContainer/" + "UpperSectionContainer/ShopContainer"
)
const _RESULTS_CONTAINER_BASE_PATH: String = (
	"NextNightSetupContainer/" + "VBoxContainer/ResultsContainer"
)

var _current_order: Dictionary = {
	RecipeManager.Ingredient.PUMPKIN: 0,
	RecipeManager.Ingredient.SPIDER: 0,
	RecipeManager.Ingredient.CORN: 0
}

# I should probably break this up. Will I? Probably not.
@onready var _restock_tutorial_dialog: TutorialDialog = $RestockTutorialDialog
@onready var _calendar_button: TextureButton = $CalendarButton
@onready var _upcoming_night_overlay: UpcomingNightOverlay = $UpcomingNightOverlay

# PREVIOUS NIGHT SUMMARY
@onready var _previous_night_summary: CenterContainer = $PreviousNightSummary
@onready var _night_number_label: Label = get_node(
	"PreviousNightSummary/VBoxContainer/NightDescriptorContainer/LabelContainer/NumberLabel"
)
@onready var _cups_sold_quantity_label: Label = get_node(
	"PreviousNightSummary/VBoxContainer/StatsContainer/Quantities/CupsSoldLabel"
)
@onready var _coins_earned_quantity_label: Label = get_node(
	"PreviousNightSummary/VBoxContainer/StatsContainer/Quantities/CoinsEarnedLabel"
)
@onready var _shop_button: Button = $PreviousNightSummary/VBoxContainer/ShopButton
@onready var _continue_button: Button = $PreviousNightSummary/VBoxContainer/ContinueButton
# NEXT NIGHT SETUP
@onready var _next_night_setup_container: CenterContainer = $NextNightSetupContainer
@onready var _pumpkin_current_label: Label = get_node(
	(
		_SHOP_CONTAINER_BASE_PATH
		+ "/PanelContainer/IngredientContainer/CurrentColumn/PumpkinCurrentLabel"
	)
)
@onready var _spider_current_label: Label = get_node(
	(
		_SHOP_CONTAINER_BASE_PATH
		+ "/PanelContainer/IngredientContainer/CurrentColumn/SpiderCurrentLabel"
	)
)
@onready var _corn_current_label: Label = get_node(
	_SHOP_CONTAINER_BASE_PATH + "/PanelContainer/IngredientContainer/CurrentColumn/CornCurrentLabel"
)
@onready var _pumpkin_ordered_widget: OrderedWidget = get_node(
	(
		_SHOP_CONTAINER_BASE_PATH
		+ "/PanelContainer/IngredientContainer/OrderedColumn/PumpkinOrderedWidget"
	)
)
@onready var _spider_ordered_widget: OrderedWidget = get_node(
	(
		_SHOP_CONTAINER_BASE_PATH
		+ "/PanelContainer/IngredientContainer/OrderedColumn/SpiderOrderedWidget"
	)
)
@onready var _corn_ordered_widget: OrderedWidget = get_node(
	(
		_SHOP_CONTAINER_BASE_PATH
		+ "/PanelContainer/IngredientContainer/OrderedColumn/CornOrderedWidget"
	)
)
@onready var _ordered_widgets: Array[OrderedWidget] = [
	_pumpkin_ordered_widget, _spider_ordered_widget, _corn_ordered_widget
]
@onready var _pumpkin_cost_label: Label = get_node(
	_SHOP_CONTAINER_BASE_PATH + "/PanelContainer/IngredientContainer/CostColumn/PumpkinCostLabel"
)
@onready var _spider_cost_label: Label = get_node(
	_SHOP_CONTAINER_BASE_PATH + "/PanelContainer/IngredientContainer/CostColumn/SpiderCostLabel"
)
@onready var _corn_cost_label: Label = get_node(
	_SHOP_CONTAINER_BASE_PATH + "/PanelContainer/IngredientContainer/CostColumn/CornCostLabel"
)
@onready var _pumpkin_new_label: Label = get_node(
	_SHOP_CONTAINER_BASE_PATH + "/PanelContainer/IngredientContainer/NewColumn/PumpkinNewLabel"
)
@onready var _spider_new_label: Label = get_node(
	_SHOP_CONTAINER_BASE_PATH + "/PanelContainer/IngredientContainer/NewColumn/SpiderNewLabel"
)
@onready var _corn_new_label: Label = get_node(
	_SHOP_CONTAINER_BASE_PATH + "/PanelContainer/IngredientContainer/NewColumn/CornNewLabel"
)
@onready var _coins_remaining_quantity_label: Label = get_node(
	_RESULTS_CONTAINER_BASE_PATH + "/CoinsContainer/LabelContainer/CoinsRemainingQuantityLabel"
)
@onready var _coins_initial_quantity_label: Label = get_node(
	_RESULTS_CONTAINER_BASE_PATH + "/CoinsContainer/LabelContainer/CoinsInitialQuantityLabel"
)
@onready var _max_cups_quantity_label: Label = get_node(
	_RESULTS_CONTAINER_BASE_PATH + "/MaxCupsContainer/MaxCupsQuantityLabel"
)
# END OF GAME
@onready var _end_of_game_container: CenterContainer = $EndOfGameContainer
@onready var _final_cups_sold_quantity_label: Label = get_node(
	"EndOfGameContainer/VBoxContainer/CupsSoldContainer/CupsSoldQuantityLabel"
)
@onready var _final_coins_quantity_label: Label = get_node(
	"EndOfGameContainer/VBoxContainer/FinalCoinsContainer/FinalCoinsQuantityLabel"
)


func _ready() -> void:
	var night_number: int = TimeManager.get_night_number()
	var night_stats: StatsManager.NightStats = StatsManager.get_night_stats(night_number)
	
	
	if night_number == 1:
		get_tree().create_timer(2).timeout.connect(func() -> void: _restock_tutorial_dialog.pause_and_show())

	_night_number_label.text = str(night_number)
	if night_number < NightManager.MAX_NIGHT_NUMBER:
		_shop_button.visible = true
		_continue_button.visible = false
		_calendar_button.visible = true
	else:
		_shop_button.visible = false
		_continue_button.visible = true
		_calendar_button.visible = false
		var cups_sold: int = 0
		for i: int in range(NightManager.MAX_NIGHT_NUMBER):
			var night_stats_i: StatsManager.NightStats = StatsManager.get_night_stats(i)
			cups_sold += night_stats_i.cups_sold

		_final_cups_sold_quantity_label.text = str(cups_sold)
		_final_coins_quantity_label.text = str(InventoryManager.get_coins())

	_upcoming_night_overlay.visible = false

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

	_coins_remaining_quantity_label.text = str(InventoryManager.get_coins())
	_coins_initial_quantity_label.text = _coins_remaining_quantity_label.text
	_max_cups_quantity_label.text = str(_get_max_cups())

	_previous_night_summary.visible = true
	_next_night_setup_container.visible = false
	_end_of_game_container.visible = false

	RecipeManager.recipe_changed.connect(
		func() -> void: _max_cups_quantity_label.text = str(_get_max_cups())
	)


func _get_order_cost() -> int:
	var total_cost: int = 0
	for ingredient: RecipeManager.Ingredient in _current_order:
		var price: int = InventoryManager.INGREDIENT_TO_PRICE.get(ingredient)
		var quantity: int = _current_order.get(ingredient)
		total_cost += price * quantity

	return total_cost


func _get_max_cups() -> int:
	var recipe: Dictionary = RecipeManager.get_recipe()
	if recipe.is_empty():
		return 0

	# There's no integer infinity - this will be casted back into an int
	var max_cups: float = INF
	for ingredient: RecipeManager.Ingredient in recipe:
		var ingredient_count_for_recipe: int = recipe.get(ingredient)
		var amount_currently_held: int = InventoryManager.get_ingredient_count(ingredient)
		var amount_being_ordered: int = _current_order.get(ingredient)
		@warning_ignore("integer_division")
		var max_cups_for_ingredient: int = (
			(amount_currently_held + amount_being_ordered) / ingredient_count_for_recipe
		)
		max_cups = min(max_cups, max_cups_for_ingredient)

	return int(max_cups)


func _place_order() -> void:
	var order_cost: int = _get_order_cost()
	InventoryManager.change_coins(-order_cost)


func _on_shop_button_pressed() -> void:
	_previous_night_summary.visible = false
	_next_night_setup_container.visible = true


func _on_continue_button_pressed() -> void:
	_previous_night_summary.visible = false
	_end_of_game_container.visible = true


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

	_coins_remaining_quantity_label.text = str(InventoryManager.get_coins() - _get_order_cost())
	_max_cups_quantity_label.text = str(_get_max_cups())


func _on_calendar_button_pressed() -> void:
	_upcoming_night_overlay.visible = true
