class_name UpcomingNightOverlay

extends CanvasLayer

const LOOKAHEAD_AMOUNT: int = 2

@onready var _night_preview_packed_scene: PackedScene = preload(
	"res://scenes/night_transition_screen/upcoming_night_overlay/night_preview/night_preview.tscn"
)
@onready var _night_preview_container: VBoxContainer = get_node(
	"Control/CenterContainer/VBoxContainer/PanelContainer/NightPreviewContainer"
)


func _ready() -> void:
	var night_number: int = TimeManager.get_night_number()
	for i: int in LOOKAHEAD_AMOUNT:
		var lookahead_value: int = i + 1
		var preview_night_number: int = night_number + lookahead_value
		if preview_night_number <= NightManager.MAX_NIGHT_NUMBER:
			var night_preview: NightPreview = _night_preview_packed_scene.instantiate()
			night_preview.night_number = preview_night_number
			_night_preview_container.add_child(night_preview)


func _on_close_button_pressed() -> void:
	visible = false
