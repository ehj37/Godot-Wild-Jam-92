extends Node2D

@onready var price_amount_label: Label = $VBoxContainer/PriceLabelContainer/PriceAmountLabel
@onready var price_slider: HSlider = $VBoxContainer/PriceSliderContainer/PriceSlider


func _ready() -> void:
	price_amount_label.text = str(PriceManager.current_price)
	price_slider.value = PriceManager.current_price


func _on_price_slider_value_changed(value: float) -> void:
	var new_price: int = int(value)
	PriceManager.current_price = new_price
	price_amount_label.text = str(new_price)
