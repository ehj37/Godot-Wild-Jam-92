extends Node

var _audio_stream_info_by_config_resource_path: Dictionary = {}


func play(sound_effect_config: SoundEffectConfig) -> void:
	var config_resource_path: String = sound_effect_config.resource_path
	if !_audio_stream_info_by_config_resource_path.has(config_resource_path):
		_audio_stream_info_by_config_resource_path.set(config_resource_path, [])
	var same_config_audio_stream_players: Array = _audio_stream_info_by_config_resource_path.get(
		config_resource_path
	)
	for audio_stream_player: AudioStreamPlayer in same_config_audio_stream_players:
		_remove_audio_stream_player(audio_stream_player, config_resource_path)

	var new_audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	new_audio_stream_player.stream = sound_effect_config.audio_stream
	new_audio_stream_player.bus = "SFX"
	same_config_audio_stream_players.append(new_audio_stream_player)
	add_child(new_audio_stream_player)
	new_audio_stream_player.play()
	new_audio_stream_player.finished.connect(
		func() -> void: _remove_audio_stream_player(new_audio_stream_player, config_resource_path)
	)


func _remove_audio_stream_player(
	audio_stream_player: AudioStreamPlayer, config_resource_path: String
) -> void:
	var same_config_stream_players: Array = _audio_stream_info_by_config_resource_path.get(
		config_resource_path
	)
	same_config_stream_players.erase(audio_stream_player)

	audio_stream_player.queue_free()
