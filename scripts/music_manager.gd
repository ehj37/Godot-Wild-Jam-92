extends Node

enum Song { SHOP, NIGHT }

const MUSIC_FADE_IN_TIME: float = 2.0
const MUSIC_FADE_OUT_TIME: float = 6.0

var _song_to_audio_stream_player: Dictionary = {}

@onready var _shop_music: AudioStreamOggVorbis = preload("res://music/shop.ogg")
@onready var _night_music: AudioStreamOggVorbis = preload("res://music/night.ogg")
@onready var _song_to_stream: Dictionary = {Song.SHOP: _shop_music, Song.NIGHT: _night_music}


func fade_music_in(song: Song) -> void:
	if _song_to_audio_stream_player.has(song):
		_stop_playing(song)

	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	audio_stream_player.stream = _song_to_stream.get(song)
	_song_to_audio_stream_player.set(song, audio_stream_player)
	audio_stream_player.bus = "Music"

	audio_stream_player.volume_linear = 0.0
	var volume_tween: Tween = audio_stream_player.create_tween()
	volume_tween.tween_property(audio_stream_player, "volume_linear", 1.0, MUSIC_FADE_IN_TIME)

	add_child(audio_stream_player)
	audio_stream_player.play()


func fade_music_out(song: Song) -> void:
	if !_song_to_audio_stream_player.has(song):
		push_warning("Attempting to cancel song that's not playing")
		return

	var audio_stream_player: AudioStreamPlayer = _song_to_audio_stream_player.get(song)
	var volume_tween: Tween = audio_stream_player.create_tween()
	volume_tween.set_trans(Tween.TRANS_EXPO)
	volume_tween.tween_property(audio_stream_player, "volume_linear", 0.0, MUSIC_FADE_OUT_TIME)
	volume_tween.finished.connect(func() -> void: _stop_playing(song))


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _stop_playing(song: Song) -> void:
	if !_song_to_audio_stream_player.has(song):
		return

	var audio_stream_player: AudioStreamPlayer = _song_to_audio_stream_player.get(song)
	_song_to_audio_stream_player.erase(song)
	audio_stream_player.queue_free()
