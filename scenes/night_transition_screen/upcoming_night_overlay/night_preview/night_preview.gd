class_name NightPreview

extends VBoxContainer

enum SpawnAmount { MANY, SOME, NONE }

# Hardcoding these all hurts my soul, but is what it is.
const _NIGHT_NUMBER_TO_FRANK_SPAWN_AMOUNT: Dictionary = {
	1: SpawnAmount.MANY,
	2: SpawnAmount.MANY,
	3: SpawnAmount.SOME,
	4: SpawnAmount.SOME,
	5: SpawnAmount.MANY,
	6: SpawnAmount.NONE,
	7: SpawnAmount.MANY,
}
const _NIGHT_NUMBER_TO_SKELLY_SPAWN_AMOUNT: Dictionary = {
	1: SpawnAmount.SOME,
	2: SpawnAmount.NONE,
	3: SpawnAmount.MANY,
	4: SpawnAmount.SOME,
	5: SpawnAmount.NONE,
	6: SpawnAmount.MANY,
	7: SpawnAmount.MANY,
}
const _NIGHT_NUMBER_TO_PHANTOM_SPAWN_AMOUNT: Dictionary = {
	1: SpawnAmount.NONE,
	2: SpawnAmount.SOME,
	3: SpawnAmount.MANY,
	4: SpawnAmount.SOME,
	5: SpawnAmount.MANY,
	6: SpawnAmount.MANY,
	7: SpawnAmount.MANY,
}

var night_number: int

@onready var _night_number_label: Label = $HeaderLabelContainer/NightNumberLabel
@onready var _frank_spawn_amount_label: Label = $FrankRow/SpawnAmountLabel
@onready var _skelly_spawn_amount_label: Label = $SkellyRow/SpawnAmountLabel
@onready var _phantom_spawn_amount_label: Label = $PhantomRow/SpawnAmountLabel


func _ready() -> void:
	_night_number_label.text = str(night_number)

	var frank_spawn_amount: SpawnAmount = _NIGHT_NUMBER_TO_FRANK_SPAWN_AMOUNT.get(night_number)
	_frank_spawn_amount_label.text = _spawn_amount_to_text(frank_spawn_amount)
	var skelly_spawn_amount: SpawnAmount = _NIGHT_NUMBER_TO_SKELLY_SPAWN_AMOUNT.get(night_number)
	_skelly_spawn_amount_label.text = _spawn_amount_to_text(skelly_spawn_amount)
	var phantom_spawn_amount: SpawnAmount = _NIGHT_NUMBER_TO_PHANTOM_SPAWN_AMOUNT.get(night_number)
	_phantom_spawn_amount_label.text = _spawn_amount_to_text(phantom_spawn_amount)


func _spawn_amount_to_text(spawn_amount: SpawnAmount) -> String:
	var text: String
	match spawn_amount:
		SpawnAmount.MANY:
			text = "MANY"
		SpawnAmount.SOME:
			text = "SOME"
		SpawnAmount.NONE:
			text = "NONE"

	return text
