extends Node

signal play_pressed()
signal cut_pressed()
signal discard_pressed()

signal menu_updated(cur:Constants.Menu, prev:Constants.Menu)


signal debug_spawn_in_hand(id:Constants.CardID)
signal debug_spawn_in_deck(id:Constants.CardID)
