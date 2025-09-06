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
	
	#for card:Card in deck:
	#	card.print_state()
	
	for i:int in range(0,5):
		hand.push_back(deck.pop_back())

	find_hand_type(hand)

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
	
	
func find_hand_type(cards:Array[Card]) -> void:
	
	## categorize cards by rank and suit
	var cards_with_rank:Dictionary[int, Array] = { ## pretend the type is Dictionary[int, Array[Card]]
		2:[],3:[],4:[],5:[],6:[],7:[],8:[],9:[],10:[],11:[],12:[],13:[],14:[],
	}
	var cards_with_suit:Dictionary[Constants.Suit, Array] = { ## pretend the type is Dictionary[int, Array[Card]]
		Constants.Suit.club:[],Constants.Suit.heart:[],
		Constants.Suit.spade:[],Constants.Suit.diamond:[],
	}
	
	for card:Card in cards:
		print(card)
		for rank:int in card.ranks:
			cards_with_rank[rank].push_back(card)
		for suit:Constants.Suit in card.suits:
			cards_with_suit[suit].push_back(card)
			
	## check for each hand type
	
	## five of a kind/flush five
	var ranks_with_5_cards:Array[int]
	for rank:int in cards_with_rank.keys():
		print(rank)
		if cards_with_rank[rank].size() == 5:
			ranks_with_5_cards.push_back(rank)
	
	
	return
