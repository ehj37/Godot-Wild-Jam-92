class_name NightTransitionScreen

extends Control

@onready var previous_night_summary: CenterContainer = $PreviousNightSummary
@onready var shop: CenterContainer = $Shop


func _ready() -> void:
	previous_night_summary.visible = true
	shop.visible = false


func _on_shop_button_pressed() -> void:
	previous_night_summary.visible = false
	shop.visible = true


func _on_start_night_button_pressed() -> void:
	NightManager.start_next_night()
