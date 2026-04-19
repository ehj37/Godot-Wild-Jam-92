class_name CustomerFeedbackEntry

extends HBoxContainer

var customer_type: Customer.CustomerType
var feedback: String

@onready var _frank_icon: TextureRect = $Icons/FrankIcon
@onready var _phantom_icon: TextureRect = $Icons/PhantomIcon
@onready var _skelly_icon: TextureRect = $Icons/SkellyIcon
@onready var _feedback_label: Label = $FeedbackLabel


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

	_feedback_label.text = feedback
