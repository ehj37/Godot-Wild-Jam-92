extends VBoxContainer

@onready var _reputation_progress_bar: ProgressBar = $ReputationProgressBar


func _ready() -> void:
	_reputation_progress_bar.value = ReputationManager.get_current_reputation() * 100
	ReputationManager.reputation_changed.connect(_on_reputation_changed)


func _on_reputation_changed(new_value: float) -> void:
	_reputation_progress_bar.value = new_value * 100
