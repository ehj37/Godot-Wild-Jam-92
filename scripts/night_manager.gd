extends Node

const MAX_NIGHT_NUMBER: int = 7
const CUSTOMER_DESPAWN_X: float = 360.0
const ORDER_WINDOW_POSITION: Vector2 = Vector2(140, 132)
const ORDER_WINDOW_MAX_X_VARIANCE: float = 10.0
const ORDER_WINDOW_MAX_Y_VARIANCE: float = 2.0
const TIME_BETWEEN_SCREENS: float = 1.0

var current_night: Night

@onready var _night_packed_scene: PackedScene = preload("res://night.tscn")
@onready var _night_transition_screen_packed_scene: PackedScene = preload(
	"res://scenes/night_transition_screen/night_transition_screen.tscn"
)
@onready var _night_1_config: NightConfig = preload("res://resources/night_configs/night_1.tres")
@onready var _night_2_config: NightConfig = preload("res://resources/night_configs/night_2.tres")
@onready var _night_3_config: NightConfig = preload("res://resources/night_configs/night_3.tres")
@onready var _night_4_config: NightConfig = preload("res://resources/night_configs/night_4.tres")
@onready var _night_5_config: NightConfig = preload("res://resources/night_configs/night_5.tres")
@onready var _night_6_config: NightConfig = preload("res://resources/night_configs/night_6.tres")
@onready var _night_7_config: NightConfig = preload("res://resources/night_configs/night_7.tres")
@onready var _night_num_to_config: Dictionary = {
	1: _night_1_config,
	2: _night_2_config,
	3: _night_3_config,
	4: _night_4_config,
	5: _night_5_config,
	6: _night_6_config,
	7: _night_7_config,
}


func get_night_config(night_number: int) -> NightConfig:
	return _night_num_to_config.get(night_number)


func start_next_night() -> void:
	TimeManager.increment_night()
	TimeManager.start_night()

	get_tree().paused = true

	MusicManager.fade_music_out(MusicManager.Song.SHOP)
	MusicManager.fade_music_in(MusicManager.Song.NIGHT)

	ScreenFadeManager.fade_out()
	await ScreenFadeManager.fade_complete

	var night: Night = _night_packed_scene.instantiate()
	# Dunno how I feel about the TimeManager owning the night number. Whatever.
	var night_config: NightConfig = get_night_config(TimeManager.get_night_number())
	night.night_config = night_config
	var tree: SceneTree = get_tree()
	var current_scene: Node = tree.current_scene
	current_scene.queue_free()
	tree.root.add_child(night)
	tree.set_current_scene(night)
	current_night = night

	await get_tree().create_timer(TIME_BETWEEN_SCREENS).timeout

	ScreenFadeManager.fade_in()
	await ScreenFadeManager.fade_complete

	get_tree().paused = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	TimeManager.end_of_night_reached.connect(_on_end_of_night_reached)


func _on_end_of_night_reached() -> void:
	get_tree().paused = true

	# TODO: Communicate that the night is over to the player somehow pre-fade

	MusicManager.fade_music_out(MusicManager.Song.NIGHT)
	MusicManager.fade_music_in(MusicManager.Song.SHOP)

	ScreenFadeManager.fade_out()
	await ScreenFadeManager.fade_complete

	var night_transition_screen: NightTransitionScreen = (
		_night_transition_screen_packed_scene.instantiate()
	)
	var tree: SceneTree = get_tree()
	var current_scene: Node = tree.current_scene
	current_scene.queue_free()
	tree.root.add_child(night_transition_screen)
	tree.set_current_scene(night_transition_screen)

	await get_tree().create_timer(TIME_BETWEEN_SCREENS).timeout

	ScreenFadeManager.fade_in()
	get_tree().paused = false
