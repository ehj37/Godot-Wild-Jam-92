extends Node


class NightStats:
	var cups_sold: int = 0
	var coins_earned: int = 0
	var successful_fetches: int = 0


var _night_number_to_stats: Dictionary = {}


func get_night_stats(night_number: int) -> NightStats:
	if _night_number_to_stats.has(night_number):
		return _night_number_to_stats.get(night_number)

	var new_night_stats: NightStats = NightStats.new()
	_night_number_to_stats[night_number] = new_night_stats
	return new_night_stats


func _ready() -> void:
	InventoryManager.order_fulfilled.connect(_on_order_fulfilled)
	CatManager.resource_fetched.connect(_on_resource_fetched)


func _on_order_fulfilled(price: int) -> void:
	var night_stats: NightStats = get_night_stats(TimeManager.get_night_number())
	night_stats.coins_earned += price
	night_stats.cups_sold += 1


func _on_resource_fetched(fetchable: CatManager.Fetchable, amount: int) -> void:
	if fetchable == CatManager.Fetchable.COIN:
		var night_stats: NightStats = get_night_stats(TimeManager.get_night_number())
		night_stats.coins_earned += amount
