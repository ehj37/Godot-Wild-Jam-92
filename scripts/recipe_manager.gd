extends Node

enum Ingredient { PUMPKIN, SPIDER }

const DEFAULT_PUMPKIN_AMOUNT: int = 2
const DEFAULT_SPIDER_AMOUNT: int = 2
const DEFAULT_RECIPE: Dictionary = {
	Ingredient.PUMPKIN: DEFAULT_PUMPKIN_AMOUNT, Ingredient.SPIDER: DEFAULT_SPIDER_AMOUNT
}

var recipe: Dictionary = DEFAULT_RECIPE.duplicate()
