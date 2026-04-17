extends Node2D

const MAX_LOG_ENTRIES: int = 10
const LOG_ENTRY_PRE_FADE_OUT_TIME: float = 1.25
const LOG_ENTRY_FADE_OUT_TIME: float = 0.25

var _log_entries: Array[HBoxContainer] = []

@onready var _customer_purchase_entry_packed_scene: PackedScene = preload(
	"res://scenes/activity_log_widget/log_entries/customer_purchase_entry/customer_purchase_entry.tscn"
)
@onready var _cat_fetch_entry_packed_scene: PackedScene = preload(
	"res://scenes/activity_log_widget/log_entries/cat_fetch_entry/cat_fetch_entry.tscn"
)
@onready var _log_entry_container: VBoxContainer = $LogEntryContainer


func _ready() -> void:
	InventoryManager.order_fulfilled.connect(_on_order_fulfilled)
	CatManager.resource_fetched.connect(_on_resource_fetched)


func _on_order_fulfilled(price: int) -> void:
	_add_customer_purchase_entry(price)


func _add_customer_purchase_entry(amount: int) -> void:
	var new_entry: CustomerPurchaseEntry = _customer_purchase_entry_packed_scene.instantiate()
	new_entry.amount = amount
	_add_log_entry(new_entry)


func _on_resource_fetched(resource: CatManager.Fetchable, amount: int) -> void:
	var new_entry: CatFetchEntry = _cat_fetch_entry_packed_scene.instantiate()
	new_entry.resource = resource
	new_entry.amount = amount
	_add_log_entry(new_entry)


func _add_log_entry(log_entry: HBoxContainer) -> void:
	_evict_oldest_entry_if_necessary()

	_log_entries.append(log_entry)
	_log_entry_container.add_child(log_entry)
	_log_entry_container.move_child(log_entry, 0)

	get_tree().create_timer(LOG_ENTRY_PRE_FADE_OUT_TIME).timeout.connect(
		func() -> void: _fade_out_log_entry(log_entry)
	)


func _remove_log_entry(log_entry: HBoxContainer) -> void:
	_log_entries.erase(log_entry)
	log_entry.queue_free()


func _evict_oldest_entry_if_necessary() -> void:
	if _log_entries.size() == MAX_LOG_ENTRIES:
		var entry_to_evict: HBoxContainer = _log_entries.front()
		_remove_log_entry(entry_to_evict)


func _fade_out_log_entry(log_entry: HBoxContainer) -> void:
	if !is_instance_valid(log_entry):
		return

	var fade_out_tween: Tween = get_tree().create_tween()
	fade_out_tween.tween_property(log_entry, "modulate:a", 0.0, LOG_ENTRY_FADE_OUT_TIME)
	fade_out_tween.bind_node(log_entry)

	fade_out_tween.finished.connect(func() -> void: _remove_log_entry(log_entry))
