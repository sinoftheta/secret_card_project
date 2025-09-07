extends Node2D


func _ready() -> void:
	GameLogic.setup_game()
	
	for card:Card in GameLogic.hand:
		%Hand.add_child(card)
