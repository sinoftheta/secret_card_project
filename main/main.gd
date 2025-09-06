extends Node2D


func _ready() -> void:
	GameLogic.setup_game()
	
	for card:Card in %Hand.get_children():
		card.id = randi_range(0,51)
