extends Node2D


func _ready() -> void:
	SignalBus.menu_updated.connect(_on_menu_updated)
	GameLogic.hand_node = %Hand

func _on_menu_updated(cur:Constants.Menu, prev:Constants.Menu) -> void:
	pass

func _on_cut_pressed() -> void:
	SignalBus.cut_pressed.emit()

func _on_play_pressed() -> void:
	SignalBus.play_pressed.emit()

func _on_discard_pressed() -> void:
	SignalBus.discard_pressed.emit()
