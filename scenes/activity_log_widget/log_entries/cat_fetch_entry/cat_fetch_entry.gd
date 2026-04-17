class_name CatFetchEntry

extends HBoxContainer

var resource: CatManager.Fetchable
var amount: int

@onready var _quantity_label: Label = $LabelContainer/QuantityLabel
@onready var _icons: Control = $Icons
@onready var _pumpkin_icon: TextureRect = $Icons/MiniPumpkinIcon
@onready var _spider_icon: TextureRect = $Icons/MiniSpiderIcon
@onready var _coin_icon: TextureRect = $Icons/MiniCoinIcon


func _ready() -> void:
	_set_icon()
	_quantity_label.text = str(amount)


func _set_icon() -> void:
	var icon_to_show: TextureRect
	match resource:
		CatManager.Fetchable.PUMPKIN:
			icon_to_show = _pumpkin_icon
		CatManager.Fetchable.SPIDER:
			icon_to_show = _spider_icon
		CatManager.Fetchable.COIN:
			icon_to_show = _coin_icon
		_:
			push_error("Unhandled fetchable in CatFetchEntry")

	var all_icons: Array = _icons.get_children()
	for icon: TextureRect in all_icons:
		icon.visible = icon == icon_to_show
