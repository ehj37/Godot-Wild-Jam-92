@tool

class_name TutorialDialog

extends Control

signal dismissed

@export var tutorial_text: String:
	set(new_value):
		tutorial_text = new_value
		var tutorial_text_label: Label = $PanelContainer/MarginContainer/VBoxContainer/TutorialTextLabel
		tutorial_text_label.text = tutorial_text
		
		
@export var dismiss_button_text: String:
	set(new_value):
		dismiss_button_text = new_value
		var dismiss_button: Button = $PanelContainer/MarginContainer/VBoxContainer/DismissButton
		dismiss_button.text = new_value


func pause_and_show() -> void:
	get_tree().paused = true
	visible = true


func _ready() -> void:
	if !Engine.is_editor_hint():
		visible = false


func _on_dismiss_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	dismissed.emit()
