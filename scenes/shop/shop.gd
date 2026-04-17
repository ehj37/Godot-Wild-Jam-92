extends Node2D

@onready var _shop_cat: ShopCat = $ShopCat


func _ready() -> void:
	CatManager.off_to_fetch.connect(func() -> void: _shop_cat.visible = false)
	CatManager.resource_fetched.connect(
		func(_resource: CatManager.Fetchable, _amount: int) -> void: _shop_cat.visible = true
	)
