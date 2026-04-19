extends Node

const CUSTOMER_DESPAWN_X: float = 360.0
const ORDER_WINDOW_POSITION: Vector2 = Vector2(140, 132)
const ORDER_WINDOW_MAX_X_VARIANCE: float = 10.0
const ORDER_WINDOW_MAX_Y_VARIANCE: float = 2.0
const TIME_BETWEEN_SCREENS: float = 1.0

var current_night: Night

@onready var night_packed_scene: PackedScene = preload("res://night.tscn")
@onready var night_transition_screen_packed_scene: PackedScene = preload(
	"res://scenes/night_transition_screen/night_transition_screen.tscn"
)


func start_next_night() -> void:
	TimeManager.increment_night()
	TimeManager.start_night()

	get_tree().paused = true

	MusicManager.fade_music_out(MusicManager.Song.SHOP)
	MusicManager.fade_music_in(MusicManager.Song.NIGHT)

	ScreenFadeManager.fade_out()
	await ScreenFadeManager.fade_complete

	var night: Night = night_packed_scene.instantiate()
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

	# TODO: Fade out the night music, maybe wait for it to fully stop before
	# fading in the shop music.
	MusicManager.fade_music_out(MusicManager.Song.NIGHT)
	MusicManager.fade_music_in(MusicManager.Song.SHOP)

	ScreenFadeManager.fade_out()
	await ScreenFadeManager.fade_complete

	var night_transition_screen: NightTransitionScreen = (
		night_transition_screen_packed_scene.instantiate()
	)
	var tree: SceneTree = get_tree()
	var current_scene: Node = tree.current_scene
	current_scene.queue_free()
	tree.root.add_child(night_transition_screen)
	tree.set_current_scene(night_transition_screen)

	await get_tree().create_timer(TIME_BETWEEN_SCREENS).timeout

	ScreenFadeManager.fade_in()
	# Technically could you attempt a fade out while we're fading in?
	# I.e. slamming the "Next night" button ASAP
	# May want to handle that in the fade manager, should be easy.
	get_tree().paused = false
