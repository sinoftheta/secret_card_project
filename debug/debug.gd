extends Control
var card_spawn_tscn:PackedScene = preload("res://debug/card_spawn.tscn")

func _ready() -> void:
	for id:Constants.CardID in Constants.card_data.keys():
		var card_spawn:CardSpawn = card_spawn_tscn.instantiate()
		card_spawn.id = id
		%CardSpawns.add_child(card_spawn)
	apply_card_filters()
func apply_card_filters() -> void:
	## no checkboxes selected = no filters
	## ace checkbox selected = only search for aces
	
	var suit_filters:Array[Constants.Suit] = []
	for checkbox:CheckBox in %SuitFilters.get_children():
		if checkbox.button_pressed:
			suit_filters.push_back(checkbox.get_index())
			
	var rank_filters:Array[int] = []
	for checkbox:CheckBox in %RankFilters.get_children():
		if checkbox.button_pressed:
			rank_filters.push_back(checkbox.get_index() + 2)
	
	
	
	for card_spawn:CardSpawn in %CardSpawns.get_children():
		var id:Constants.CardID = card_spawn.id
		var has_all_ranks:bool = true
		var has_all_suits:bool = true
		
		for rank:int in rank_filters:
			if not Constants.card_data[id].ranks.has(rank):
				has_all_ranks = false
				break
		
		for suit:Constants.Suit in suit_filters:
			if not Constants.card_data[id].suits.has(suit):
				has_all_suits = false
				break
		
		if rank_filters.size() > 0 and suit_filters.size() > 0:
			card_spawn.visible = has_all_ranks and has_all_suits
		
		elif rank_filters.size() > 0:
			card_spawn.visible = has_all_ranks
		
		elif suit_filters.size() > 0:
			card_spawn.visible = has_all_suits
		
		else:
			card_spawn.visible = true

func _on_clear_rank_filters_pressed() -> void:
	for checkbox:CheckBox in %RankFilters.get_children():
		checkbox.set_pressed_no_signal(false)
	apply_card_filters()


func _on_clear_suit_filters_pressed() -> void:
	for checkbox:CheckBox in %SuitFilters.get_children():
		checkbox.set_pressed_no_signal(false)
	apply_card_filters()
	


func _on_filter_option_toggled(toggled_on: bool) -> void:
	apply_card_filters()
