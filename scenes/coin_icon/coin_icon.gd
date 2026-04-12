extends TextureRect

const TIME_BETWEEN_GLIMMERS: float = 5.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var time_to_first_glimmer: float = randf_range(0.0, TIME_BETWEEN_GLIMMERS)
	get_tree().create_timer(time_to_first_glimmer).timeout.connect(_glimmer)


func _glimmer() -> void:
	animation_player.play("glimmer")
	get_tree().create_timer(TIME_BETWEEN_GLIMMERS).timeout.connect(_glimmer)
