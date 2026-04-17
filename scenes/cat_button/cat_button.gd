extends TextureButton

@onready var _progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	disabled = CatManager.get_current_charge() != CatManager.RECHARGE_TIME
	CatManager.charge_changed.connect(_on_charge_changed)


func _on_charge_changed(new_charge: float) -> void:
	_progress_bar.value = new_charge / CatManager.RECHARGE_TIME
	_progress_bar.visible = _progress_bar.value != 1.0
	disabled = _progress_bar.value != 1.0


func _on_pressed() -> void:
	CatManager.enter_plan_mode()
