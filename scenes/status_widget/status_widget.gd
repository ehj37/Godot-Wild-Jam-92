extends Node2D

@onready var _coin_count_label: Label = $VBoxContainer/CoinContainer/CoinCountLabel
@onready var _night_number_label: Label = $VBoxContainer/NightContainer/NightNumberLabel
@onready var _night_progress_bar: ProgressBar = $VBoxContainer/NightContainer/NightProgressBar
@onready var _time_label: Label = $VBoxContainer/TimeContainer/TimeLabel


func _ready() -> void:
	InventoryManager.coins_changed.connect(_on_coins_changed)
	TimeManager.time_changed.connect(_on_time_changed)

	_night_number_label.text = "NIGHT " + str(TimeManager.get_night_number())
	_night_progress_bar.value = 0.0

	_on_coins_changed(InventoryManager.get_coins())
	_on_time_changed(TimeManager.get_hour(), TimeManager.get_minute())


func _on_coins_changed(new_amount: int, _delta: int = 0) -> void:
	_coin_count_label.text = str(new_amount)


func _on_time_changed(new_hour: int, new_minute: int) -> void:
	var twelve_hour_clock_hour: int
	if new_hour == 0:
		twelve_hour_clock_hour = 12
	else:
		twelve_hour_clock_hour = new_hour % 12

	var hour_text: String = str(twelve_hour_clock_hour)

	var minute_text: String
	if new_minute == 0:
		minute_text = "00"
	else:
		minute_text = str(new_minute)

	var suffix: String
	if new_hour >= 12:
		suffix = "PM"
	else:
		suffix = "AM"

	_time_label.text = hour_text + ":" + minute_text + " " + suffix

	_night_progress_bar.value = TimeManager.get_night_time_range().get_progress_in_time_range(
		new_hour, new_minute
	)
