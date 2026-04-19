extends VBoxContainer

@onready var _main_volume_slider: HSlider = $MainVolumeContainer/MainVolumeSlider
@onready var _sfx_volume_slider: HSlider = $SFXVolumeContainer/SFXVolumeSlider
@onready var _music_volume_slider: HSlider = $MusicVolumeContainer/MusicVolumeSlider


func _ready() -> void:
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	_main_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))

	var sound_effects_bus_index: int = AudioServer.get_bus_index("SFX")
	_sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sound_effects_bus_index))

	var music_bus_index: int = AudioServer.get_bus_index("Music")
	_music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))


func _on_main_volume_slider_value_changed(value: float) -> void:
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(master_bus_index, value)


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	var sfx_bus_index: int = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(sfx_bus_index, value)


func _on_music_volume_slider_value_changed(value: float) -> void:
	var music_bus_index: int = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(music_bus_index, value)
