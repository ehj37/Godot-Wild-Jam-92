extends CanvasLayer

signal fade_complete

const FADE_IN_DURATION: float = 1.5
const FADE_OUT_DURATION: float = 1.0

@onready var color_rect: ColorRect = $ColorRect


func fade_in() -> void:
	var fade_in_tween: Tween = get_tree().create_tween()
	fade_in_tween.tween_property(color_rect, "color:a", 0.0, FADE_IN_DURATION)
	fade_in_tween.set_trans(Tween.TRANS_QUART)
	fade_in_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_in_tween.finished.connect(func() -> void: fade_complete.emit())


func fade_out() -> void:
	var fade_out_tween: Tween = get_tree().create_tween()
	fade_out_tween.tween_property(color_rect, "color:a", 1.0, FADE_OUT_DURATION)
	fade_out_tween.set_trans(Tween.TRANS_QUART)
	fade_out_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_out_tween.finished.connect(func() -> void: fade_complete.emit())


func _ready() -> void:
	color_rect.color.a = 1.0
	fade_in()
