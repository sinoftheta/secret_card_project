class_name CardSpawn
extends HBoxContainer

var id:Constants.CardID:
	set(value):
		id = value
		#%Label.text = Constants.CardID.keys()[value]
		%Label.text = Constants.card_data[value].title

func _on_spawn_in_deck_pressed() -> void:
	SignalBus.debug_spawn_in_deck.emit(id)

func _on_spawn_in_hand_pressed() -> void:
	SignalBus.debug_spawn_in_hand.emit(id)
