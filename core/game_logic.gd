extends Node

var card_tscn = preload("res://card/card.tscn")

var deck_rng:RandomNumberGenerator ## used for shuffling the deck
var card_rng:RandomNumberGenerator ## used for card effect outcomes
var shop_rng:RandomNumberGenerator ## used for shop contents

var deck:Array[Card]
var discard:Array[Card]
var trash:Array[Card]

var hand_node:Node2D
var selected_in_hand:Array[Card]:
	get():
		return []

var actions:int
var round:int
var score_threshold:float
var money:int

func _ready() -> void:
	SignalBus.play_pressed.connect(_on_play_pressed)
	SignalBus.cut_pressed.connect(_on_cut_pressed)
	SignalBus.discard_pressed.connect(_on_discard_pressed)
func _on_play_pressed() -> void:
	pass
func _on_cut_pressed() -> void:
	pass
func _on_discard_pressed() -> void:
	pass
func setup_game() -> void:
	discard.clear()
	deck.clear()
	trash.clear()
	while hand_node.get_child_count() > 0:
		var card:Card = hand_node.get_child(0)
		hand_node.remove_child(card)
		card.queue_free()
	#hand.clear()
	actions = 4
	round = 0
	
	#for i:int in range(15,23): #range(0,51):
		### Don't use Card.new() its a scene not a bare class
		#var card:Card = card_tscn.instantiate()
		#card.id = i
		#deck.push_back(card)
	#
	#deck.shuffle()
	
	var test_ids:Array[Constants.CardID] = [
		Constants.CardID.c2,
		Constants.CardID.c3,
		Constants.CardID.dog,
		Constants.CardID.nine_to_five,
		Constants.CardID.a4,
		Constants.CardID.k4,
		Constants.CardID.c4,
		Constants.CardID.c5,
		Constants.CardID.c6
	]
	test_ids.shuffle()
	for id:Constants.CardID in test_ids:
		var card:Card = card_tscn.instantiate()
		card.id = id
		#hand.push_back(card)

	find_hand_type(selected_in_hand)

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
	
	cards.sort_custom(func (a:Card, b:Card) -> bool: return a.ranks[0] )
	
	## categorize cards by rank and suit
	var cards_with_rank:Dictionary[int, Array] = { ## pretend the type is Dictionary[int, Array[Card]]
		14:[],13:[],12:[],11:[],10:[],9:[],8:[],7:[],6:[],5:[],4:[],3:[],2:[],
	}
	var cards_with_suit:Dictionary[Constants.Suit, Array] = { ## pretend the type is Dictionary[int, Array[Card]]
		Constants.Suit.club:[],Constants.Suit.heart:[],
		Constants.Suit.spade:[],Constants.Suit.diamond:[],
	}
	## there are only 24 (4!) "flavors" of flushes, could be a cool mechanic to play with? idk
	
	for card:Card in cards:
		#print(card)
		for rank:int in card.ranks:
			cards_with_rank[rank].push_back(card)
		for suit:Constants.Suit in card.suits:
			cards_with_suit[suit].push_back(card)
			
	## check for each hand type
	
	
	## flush
	## keep in mind flushes NEED 5 cards to exist
	var flush_count:int = 0
	for suit:Constants.Suit in cards_with_suit.keys():
		if cards_with_suit[suit].size() == 5:
			## I DO want to double count cards for suit
			## one card CAN contribute to multiple suits
			print("hand contains a ", Constants.Suit.keys()[suit]," flush!")
			flush_count += 1
	
	if cards.size() == 5:
		## check for a "true" straight
		## check for the existance of each straight
		## we don't have the luxury of sorting the cards before checking for the straight
		## if a straight exists, there must be an ordering of cards that makes that straight
		## we check all 5! orderings
		for ordered_straight_ranks:Array in Util.five_straights:
			for perm:Array in Util.perms5:
				for i:int in range(5):
					if not cards[perm[i]].ranks.has(ordered_straight_ranks[i]):
						break
					if i == 4:
						print("straight found!")
	
	
	## check for "weak" straights
	## only pick the single longest straight
	## ignore aces at first
	var longest_run:int = 0
	var high_rank_in_longest_run:int = 0
	var curent_run:int = 0
	
	for rank:int in range(2,14):
		if cards_with_rank[rank].size() > 0:
			curent_run += 1
		else:
			curent_run = 0
		
		if curent_run >= longest_run:
			longest_run = curent_run
			high_rank_in_longest_run = rank
			
	## analyze aces low/high
	
	
	

	## five of a kind
	var ranks_with_5_cards:Array[int]
	for rank:int in cards_with_rank.keys():
		if cards_with_rank[rank].size() == 5:
			ranks_with_5_cards.push_back(rank)
