class_name NightTransitionScreen

extends Control

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


func _ready() -> void:
	var night_number: int = TimeManager.get_night_number()
	_night_number_label.text = "NIGHT " + str(night_number)
	var night_stats: StatsManager.NightStats = StatsManager.get_night_stats(night_number)
	_cups_sold_quantity_label.text = str(night_stats.cups_sold)
	_coins_earned_quantity_label.text = str(night_stats.coins_earned)

	_previous_night_summary.visible = true
	_shop.visible = false


func _on_shop_button_pressed() -> void:
	_previous_night_summary.visible = false
	_shop.visible = true


func _on_start_night_button_pressed() -> void:
	NightManager.start_next_night()
