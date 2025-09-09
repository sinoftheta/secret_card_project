extends Control
var card_tscn = preload("res://card/card.tscn")
const SEARCH_FAIL_MSG:String = "no matching cards!"

func _ready() -> void:
	apply_card_filters()
func apply_card_filters() -> void:
	## no checkboxes selected = no filters
	## ace checkbox selected = only search for aces
	
	#var any_suit_filters:bool = %SuitFilters.get_children().any(are_checked)
	#var any_rank_filters:bool = %RankFilters.get_children().any(are_checked)
	(%SpawnCard as OptionButton).clear()
	
	var suit_filters:Array[Constants.Suit] = []
	for checkbox:CheckBox in %SuitFilters.get_children():
		if checkbox.button_pressed:
			suit_filters.push_back(checkbox.get_index())
			
	var rank_filters:Array[int] = []
	for checkbox:CheckBox in %RankFilters.get_children():
		if checkbox.button_pressed:
			rank_filters.push_back(checkbox.get_index() + 2)
	
	
	
	for id:Constants.CardID in Constants.card_data.keys():
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
			if has_all_ranks and has_all_suits:
				(%SpawnCard as OptionButton).add_item(Constants.card_data[id].title,id)
		
		elif rank_filters.size() > 0:
			if has_all_ranks:
				(%SpawnCard as OptionButton).add_item(Constants.card_data[id].title,id)
		
		elif suit_filters.size() > 0:
			if has_all_suits:
				(%SpawnCard as OptionButton).add_item(Constants.card_data[id].title,id)
		
		else:
			## no filters applied, add the id
			(%SpawnCard as OptionButton).add_item(Constants.card_data[id].title,id)

	
	if (%SpawnCard as OptionButton).item_count == 0:
		(%SpawnCard as OptionButton).add_item(SEARCH_FAIL_MSG)
		(%SpawnCard as OptionButton).set_item_disabled(0,true)

func _on_add_to_hand_pressed() -> void:
	if (%SpawnCard as OptionButton).get_item_text((%SpawnCard as OptionButton).selected) == SEARCH_FAIL_MSG:
		return
	var card:Card = card_tscn.instantiate()
	card.id = (%SpawnCard as OptionButton).get_item_id((%SpawnCard as OptionButton).selected)
	GameLogic.hand_node.add_child(card)


func _on_add_to_deck_pressed() -> void:
	if (%SpawnCard as OptionButton).get_item_text((%SpawnCard as OptionButton).selected) == SEARCH_FAIL_MSG:
		return
	var card:Card = card_tscn.instantiate()
	card.id = (%SpawnCard as OptionButton).get_item_id((%SpawnCard as OptionButton).selected)
	GameLogic.deck.push_back(card)

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
