extends CustomerState


class IngredientReportCard:
	var pumpkin_score: float
	var spider_score: float
	var corn_score: float


class OrderReportCard:
	var price_score: float
	var variety_score: float
	var ingredient_report_card: IngredientReportCard

	func ingredient_score() -> float:
		return (
			ingredient_report_card.pumpkin_score
			+ ingredient_report_card.spider_score
			+ ingredient_report_card.corn_score
		)

	func total_score() -> float:
		return ingredient_score() + price_score + variety_score


# INGREDIENT SCORES
const _FRANK_INGREDIENT_SCORES: Dictionary = {
	RecipeManager.Ingredient.PUMPKIN: 0.6,
	RecipeManager.Ingredient.SPIDER: 0.2,
	RecipeManager.Ingredient.CORN: 0.1
}
const _SKELLY_INGREDIENT_SCORES: Dictionary = {
	RecipeManager.Ingredient.PUMPKIN: 0.4,
	RecipeManager.Ingredient.SPIDER: 0.4,
	RecipeManager.Ingredient.CORN: -0.1
}
const _PHANTOM_INGREDIENT_SCORES: Dictionary = {
	RecipeManager.Ingredient.PUMPKIN: 0.4,
	RecipeManager.Ingredient.SPIDER: 0.15,
	RecipeManager.Ingredient.CORN: 0.2
}
const _CUSTOMER_TYPE_TO_INGREDIENT_SCORES: Dictionary = {
	Customer.CustomerType.FRANK: _FRANK_INGREDIENT_SCORES,
	Customer.CustomerType.SKELLY: _SKELLY_INGREDIENT_SCORES,
	Customer.CustomerType.PHANTOM: _PHANTOM_INGREDIENT_SCORES
}

# PRICE DEBUFFS
const _FRANK_PRICE_DEBUFF: float = 0.04
const _SKELLY_PRICE_DEBUFF: float = 0.05
const _PHANTOM_PRICE_DEBUFF: float = 0.06
const _CUSTOMER_TYPE_TO_PRICE_DEBUFF: Dictionary = {
	Customer.CustomerType.FRANK: _FRANK_PRICE_DEBUFF,
	Customer.CustomerType.SKELLY: _SKELLY_PRICE_DEBUFF,
	Customer.CustomerType.PHANTOM: _PHANTOM_PRICE_DEBUFF
}

# VARIETY BONUSES
const _FRANK_VARIETY_BONUS: float = 0.2
const _SKELLY_VARIETY_BONUS: float = 0.25
const _PHANTOM_VARIETY_BONUS: float = 0.2
const _CUSTOMER_TYPE_TO_VARIETY_BONUS: Dictionary = {
	Customer.CustomerType.FRANK: _FRANK_VARIETY_BONUS,
	Customer.CustomerType.SKELLY: _SKELLY_VARIETY_BONUS,
	Customer.CustomerType.PHANTOM: _PHANTOM_VARIETY_BONUS
}

# TIP RANGES
const _FRANK_MIN_TIP_AMOUNT: int = 7
const _SKELLY_MIN_TIP_AMOUNT: int = 6
const _PHANTOM_MIN_TIP_AMOUNT: int = 5
const _CUSTOMER_TYPE_TO_MIN_TIP_AMOUNT: Dictionary = {
	Customer.CustomerType.FRANK: _FRANK_MIN_TIP_AMOUNT,
	Customer.CustomerType.SKELLY: _SKELLY_MIN_TIP_AMOUNT,
	Customer.CustomerType.PHANTOM: _PHANTOM_MIN_TIP_AMOUNT
}

const _FRANK_MAX_TIP_AMOUNT: int = 12
const _SKELLY_MAX_TIP_AMOUNT: int = 8
const _PHANTOM_MAX_TIP_AMOUNT: int = 8
const _CUSTOMER_TYPE_TO_MAX_TIP_AMOUNT: Dictionary = {
	Customer.CustomerType.FRANK: _FRANK_MAX_TIP_AMOUNT,
	Customer.CustomerType.SKELLY: _SKELLY_MAX_TIP_AMOUNT,
	Customer.CustomerType.PHANTOM: _PHANTOM_MAX_TIP_AMOUNT
}

const LARGE_NEGATIVE_REPUTATION_HIT: float = -0.1
const MEDIUM_NEGATIVE_REPUTATION_HIT: float = -0.03
const SMALL_NEGATIVE_REPUTATION_HIT: float = -0.01
const SMALL_POSITIVE_REPUTATION_BOOST: float = 0.01
const MEDIUM_POSITIVE_REPUTATION_BOOST: float = 0.03

const FEEDBACK_PROBABILITY: float = 0.5


func enter(data: Dictionary = {}) -> void:
	var animation_player: AnimationPlayer = customer.get_animation_player()
	animation_player.play("sip")
	await animation_player.animation_finished

	var recipe_at_time_of_order: Dictionary = data.get("recipe_at_time_of_order")
	var price_at_time_of_order: int = data.get("price_at_time_of_order")

	var report_card: OrderReportCard = _get_report_card(
		recipe_at_time_of_order, price_at_time_of_order
	)
	var total_score: float = report_card.total_score()
	var customer_type: Customer.CustomerType = customer.customer_type

	if total_score < 0.25:
		# Serving cauldron juice on its own is treated as a war crime
		var serving_cauldron_water: bool = recipe_at_time_of_order.is_empty()
		if serving_cauldron_water:
			ReputationManager.update_reputation(LARGE_NEGATIVE_REPUTATION_HIT)
		else:
			ReputationManager.update_reputation(MEDIUM_NEGATIVE_REPUTATION_HIT)

		if serving_cauldron_water:
			var feedback: String = FeedbackManager.CUSTOMER_TYPE_TO_CAULDRON_WATER_FEEDBACK.get(
				customer_type
			)
			FeedbackManager.give_feedback(customer_type, feedback)
		elif randf() < FEEDBACK_PROBABILITY:
			FeedbackManager.give_feedback(customer_type, _get_negative_feedback(report_card))
	elif total_score < 0.5:
		ReputationManager.update_reputation(SMALL_NEGATIVE_REPUTATION_HIT)
	elif total_score < 0.75:
		ReputationManager.update_reputation(SMALL_POSITIVE_REPUTATION_BOOST)
	if total_score > 0.75:
		ReputationManager.update_reputation(MEDIUM_POSITIVE_REPUTATION_BOOST)

		var min_tip_amount: int = _CUSTOMER_TYPE_TO_MIN_TIP_AMOUNT.get(customer_type)
		var max_tip_amount: int = _CUSTOMER_TYPE_TO_MAX_TIP_AMOUNT.get(customer_type)
		var tip_amount: int = randi_range(min_tip_amount, max_tip_amount)
		InventoryManager.add_tip(customer_type, tip_amount)

		if randf() < FEEDBACK_PROBABILITY:
			FeedbackManager.give_feedback(customer_type, _get_positive_feedback(report_card))

	transition_to("Walk")


func _get_report_card(
	recipe_at_time_of_order: Dictionary, price_at_time_of_order: int
) -> OrderReportCard:
	var customer_type: Customer.CustomerType = customer.customer_type

	var price_score: float = (
		-_CUSTOMER_TYPE_TO_PRICE_DEBUFF.get(customer_type) * price_at_time_of_order
	)
	var variety_score: float
	if recipe_at_time_of_order.size() > 1:
		variety_score = _CUSTOMER_TYPE_TO_VARIETY_BONUS.get(customer_type)
	else:
		variety_score = 0.0
	var ingredient_scores: Dictionary = _CUSTOMER_TYPE_TO_INGREDIENT_SCORES.get(customer_type)
	var ingredient_report_card: IngredientReportCard = IngredientReportCard.new()
	for ingredient: RecipeManager.Ingredient in recipe_at_time_of_order:
		var ingredient_amount: int = recipe_at_time_of_order.get(ingredient)
		var ingredient_score: float = ingredient_amount * ingredient_scores.get(ingredient)
		match ingredient:
			RecipeManager.Ingredient.PUMPKIN:
				ingredient_report_card.pumpkin_score = ingredient_score
			RecipeManager.Ingredient.SPIDER:
				ingredient_report_card.spider_score = ingredient_score
			RecipeManager.Ingredient.CORN:
				ingredient_report_card.corn_score = ingredient_score

	var order_report_card: OrderReportCard = OrderReportCard.new()
	order_report_card.price_score = price_score
	order_report_card.variety_score = variety_score
	order_report_card.ingredient_report_card = ingredient_report_card

	return order_report_card


# Ideally more of this would be deferred to the feedback manager
func _get_positive_feedback(report_card: OrderReportCard) -> String:
	var customer_type: Customer.CustomerType = customer.customer_type

	match customer_type:
		Customer.CustomerType.FRANK:
			if report_card.ingredient_report_card.pumpkin_score > 0:
				return FeedbackManager.FRANK_PUMPKIN_FEEDBACK
		Customer.CustomerType.SKELLY:
			if report_card.ingredient_report_card.spider_score > 0.5:
				return FeedbackManager.SKELLY_SPIDER_FEEDBACK
		Customer.CustomerType.PHANTOM:
			if report_card.ingredient_report_card.corn_score > 0:
				return FeedbackManager.PHANTOM_CORN_FEEDBACK

	return FeedbackManager.CUSTOMER_TYPE_TO_FAIR_PRICE_FEEDBACK[customer_type]


func _get_negative_feedback(report_card: OrderReportCard) -> String:
	var customer_type: Customer.CustomerType = customer.customer_type

	# Specialty feedback
	match customer_type:
		Customer.CustomerType.FRANK:
			pass
		Customer.CustomerType.SKELLY:
			if report_card.ingredient_report_card.corn_score < 0:
				return FeedbackManager.SKELLY_CORN_FEEDBACK
		Customer.CustomerType.PHANTOM:
			pass

	if report_card.total_score() < 0:
		return FeedbackManager.CUSTOMER_TYPE_TO_TOO_EXPENSIVE_FEEDBACK.get(customer_type)

	var ingredient_scores: Array[float] = [
		report_card.ingredient_report_card.pumpkin_score,
		report_card.ingredient_report_card.spider_score,
		report_card.ingredient_report_card.corn_score
	]
	var nonzero_ingredient_count: int = ingredient_scores.size() - ingredient_scores.count(0.0)
	if nonzero_ingredient_count == 1:
		return FeedbackManager.CUSTOMER_TYPE_TO_VARIETY_FEEDBACK[customer_type]

	return FeedbackManager.CUSTOMER_TYPE_TO_GENERIC_NEGATIVE_FEEDBACK[customer_type]
