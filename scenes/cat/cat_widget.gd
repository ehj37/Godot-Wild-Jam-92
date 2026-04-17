extends Control


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	CatManager.plan_mode_entered.connect(_on_plan_mode_entered)


func _on_plan_mode_entered() -> void:
	_display()


func _display() -> void:
	visible = true


func _hide() -> void:
	visible = false
	CatManager.exit_plan_mode()


func _on_fetch_pumpkin_button_pressed() -> void:
	CatManager.fetch(CatManager.Fetchable.PUMPKIN)
	_hide()


func _on_fetch_spider_button_pressed() -> void:
	CatManager.fetch(CatManager.Fetchable.SPIDER)
	_hide()


func _on_fetch_coin_button_pressed() -> void:
	CatManager.fetch(CatManager.Fetchable.COIN)
	_hide()
