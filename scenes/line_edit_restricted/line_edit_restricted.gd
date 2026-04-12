class_name LineEditRestricted

extends LineEdit

var _last_valid_text: String
var _last_submitted_text: String


func _is_pos_in(checkpos: Vector2) -> bool:
	var gr: Rect2 = get_global_rect()
	return (
		checkpos.x >= gr.position.x
		and checkpos.y >= gr.position.y
		and checkpos.x < gr.end.x
		and checkpos.y < gr.end.y
	)


func _input(event: InputEvent) -> void:
	# Effectively submit the text if clicking outside of the line edit
	if event is InputEventMouseButton:
		var global_rect: Rect2 = get_global_rect()
		var event_pos: Vector2 = (event as InputEventMouseButton).position
		var mouse_in_line_edit: bool = (
			event_pos.x >= global_rect.position.x
			and event_pos.y >= global_rect.position.y
			and event_pos.x < global_rect.end.x
			and event_pos.y < global_rect.end.y
		)
		if !mouse_in_line_edit:
			_on_text_submitted(_last_valid_text)
			release_focus()


func _ready() -> void:
	assert(text.is_valid_int(), "Line edit provided with non-int initial text.")
	_last_valid_text = text
	_last_submitted_text = text


func _on_text_changed(new_text: String) -> void:
	if !new_text.is_valid_int() && new_text != "":
		var previous_caret_column: int = caret_column - 1
		text = _last_valid_text
		caret_column = previous_caret_column
		return

	_last_valid_text = new_text


func _on_text_submitted(new_text: String) -> void:
	if new_text == "":
		text = _last_submitted_text
		_last_valid_text = _last_valid_text
	else:
		_last_submitted_text = new_text

	PriceManager.current_price = int(_last_submitted_text)
