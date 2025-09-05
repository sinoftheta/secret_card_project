extends Node

func is_card_standard(id:Constants.CardID) -> bool:
	return Constants.CardID.c2 <= id and id <= Constants.CardID.da

func seeded_shuffle(arr:Array, rng:RandomNumberGenerator) -> void:
	seed(rng.randi())
	arr.shuffle()
	
