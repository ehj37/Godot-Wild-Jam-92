class_name CustomerPurchaseEntry

extends HBoxContainer

var amount: int

@onready var _label: Label = $Label


func _ready() -> void:
	_label.text = "+" + str(amount)
