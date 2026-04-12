extends CanvasLayer

@onready var coin_count_label: Label = $VBoxContainer/CoinContainer/CoinCountLabel
@onready var night_number_label: Label = $VBoxContainer/NightContainer/NightNumberLabel
@onready var time_label: Label = $VBoxContainer/TimeContainer/TimeLabel


func _ready() -> void:
	InventoryManager.coins_changed.connect(_on_coins_changed)
	TimeManager.night_number_changed.connect(_on_night_number_changed)
	TimeManager.time_changed.connect(_on_time_changed)

	_on_coins_changed(InventoryManager.get_coins())
	_on_night_number_changed(TimeManager.get_night_number())
	_on_time_changed(TimeManager.get_hour(), TimeManager.get_minute())


func _on_coins_changed(new_amount: int) -> void:
	coin_count_label.text = str(new_amount)


func _on_night_number_changed(new_night_number: int) -> void:
	night_number_label.text = "NIGHT " + str(new_night_number)


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

	time_label.text = hour_text + ":" + minute_text + " " + suffix
