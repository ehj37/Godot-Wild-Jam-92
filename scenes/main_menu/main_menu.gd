extends CenterContainer

@onready var _night_packed_scene: PackedScene = preload("res://night.tscn")
@onready var _main_buttons: VBoxContainer = $MainButtons
@onready var _settings_container: VBoxContainer = $SettingsContainer


func _ready() -> void:
	_main_buttons.visible = true
	_settings_container.visible = false

	ScreenFadeManager.fade_in()
	MusicManager.fade_music_in(MusicManager.Song.SHOP)


func _on_start_button_pressed() -> void:
	_main_buttons.visible = false
	_settings_container.visible = false

	ScreenFadeManager.fade_out()
	MusicManager.fade_music_out(MusicManager.Song.SHOP)

	await MusicManager.fade_complete

	var night: Night = _night_packed_scene.instantiate()
	# Dunno how I feel about the TimeManager owning the night number. Whatever.
	var night_config: NightConfig = NightManager.get_night_config(1)
	night.night_config = night_config
	var tree: SceneTree = get_tree()
	var current_scene: Node = tree.current_scene
	current_scene.queue_free()
	tree.root.add_child(night)
	tree.set_current_scene(night)
	NightManager.current_night = night

	get_tree().change_scene_to_packed(_night_packed_scene)
	ScreenFadeManager.fade_in()

	MusicManager.fade_music_in(MusicManager.Song.NIGHT)


func _on_settings_button_pressed() -> void:
	_main_buttons.visible = false
	_settings_container.visible = true


func _on_back_button_pressed() -> void:
	_main_buttons.visible = true
	_settings_container.visible = false
