class_name CustomerTipEntry

extends HBoxContainer

var customer_type: Customer.CustomerType
var amount: int

@onready var _frank_icon: TextureRect = $Icons/FrankIcon
@onready var _phantom_icon: TextureRect = $Icons/PhantomIcon
@onready var _skelly_icon: TextureRect = $Icons/SkellyIcon
@onready var _quantity_label: Label = $QuantityLabel


func _ready() -> void:
	var icon_to_show: TextureRect
	match customer_type:
		Customer.CustomerType.FRANK:
			icon_to_show = _frank_icon
		Customer.CustomerType.SKELLY:
			icon_to_show = _skelly_icon
		Customer.CustomerType.PHANTOM:
			icon_to_show = _phantom_icon

	for icon: TextureRect in [_frank_icon, _phantom_icon, _skelly_icon]:
		icon.visible = icon == icon_to_show

	_quantity_label.text = str(amount)
