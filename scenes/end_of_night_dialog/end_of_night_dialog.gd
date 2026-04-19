class_name EndOfNightDialog

extends Control

const FADE_IN_TIME: float = 0.5

@onready var _night_number_label: Label = $HBoxContainer/LabelContainer/NightNumberLabel


func fade_in() -> void:
	var modulate_tween: Tween = self.create_tween()
	modulate_tween.tween_property(self, "modulate:a", 1.0, FADE_IN_TIME)


func _ready() -> void:
	modulate.a = 0
	_night_number_label.text = str(TimeManager.get_night_number())
