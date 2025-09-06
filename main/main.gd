extends Node2D


func _ready() -> void:
	GameLogic.setup_game()
	
	for card:Card in %Hand.get_children():
		var id:int
		if randi() % 2 == 0:
			id = randi_range(52,54)
		else:
			id = randi_range(0,51)
		card.id = id
