extends Node

var deck_rng:RandomNumberGenerator ## used for shuffling the deck
var card_rng:RandomNumberGenerator ## used for card effect outcomes
var shop_rng:RandomNumberGenerator ## used for shop contents

var deck:Array[Card]
var discard:Array[Card]
var trash:Array[Card]

var hand:Array[Card]

var actions:int
var round:int
var score_threshold:float
var money:int

func _ready() -> void:
	pass
func setup_game() -> void:
	discard.clear()
	deck.clear()
	trash.clear()
	hand.clear()
	actions = 4
	round = 0
	
	for i:int in range(0,51):
		var card:Card = Card.new()
		card.id = i
		deck.push_back(card)
	
	deck.shuffle()
	
	for card:Card in deck:
		card.print_state()

var tween:Tween
var animation_tick:int = 0

func _on_score_selection_pressed() -> void:
	#if selected_in_hand.size() == 0: return
	actions -= 1
	check_round_ended()

func _on_discard_selection_pressed() -> void:
	#if selected_in_hand.size() == 0: return
	actions -= 1
	check_round_ended()

func _on_cut_selection_pressed() -> void:
	#if selected_in_hand.size() == 0: return
	actions -= 1
	check_round_ended()

func check_round_ended() -> void:
	assert(actions >= 0)
	if actions != 0: return

func _on_exit_round() -> void:
	pass
func _on_enter_round() -> void:
	pass
	
	
func search_for_pair(cards:Array[Card]) -> bool:
	if cards.size() < 2: return false
	
	
	return false
