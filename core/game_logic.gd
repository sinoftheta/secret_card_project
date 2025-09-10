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
		var s:Array[Card] = []
		for card:Card in hand_node.get_children():
			if card.selected:
				s.push_back(card)
		return s

var actions:int
var round:int
var score_threshold:float
var money:int

func _ready() -> void:
	SignalBus.play_pressed.connect(_on_play_pressed)
	SignalBus.cut_pressed.connect(_on_cut_pressed)
	SignalBus.discard_pressed.connect(_on_discard_pressed)
	
	SignalBus.debug_spawn_in_deck.connect(_on_debug_spawn_in_deck)
	SignalBus.debug_spawn_in_hand.connect(_on_debug_spawn_in_hand)
func _on_play_pressed() -> void:
	print("playing")
	find_hand_type(selected_in_hand)
func _on_cut_pressed() -> void:
	print("cutting")
	for card:Card in selected_in_hand:
		hand_node.remove_child(card)
		card.queue_free()
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
	if cards.size() == 0:
		print("no cards submitted!")
		return
	
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
			
			
	#print("cards_with_rank: ", cards_with_rank)
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
	
	#if cards.size() == 5:
		### check for a "true" straight
		### check for the existance of each straight
		### we don't have the luxury of sorting the cards before checking for the straight
		### if a straight exists, there must be an ordering of cards that makes that straight
		### we check all 5! orderings
		#for ordered_straight_ranks:Array in Util.five_straights:
			#for perm:Array in Util.perms5:
				#for i:int in range(5):
					#if not cards[perm[i]].ranks.has(ordered_straight_ranks[i]):
						#break
					#if i == 4:
						#print("true straight detected")
	
	
	## check for "weak" straights
	## only pick the single longest straight
	## ignore aces at first
	
	var runs:Array[Array] = []
	var run_index:int = 0
	for rank:int in range(2,14):
		## check if we need to start a new run
		if runs.size() == run_index:
			runs.push_back([])
		
		if cards_with_rank[rank].size() > 0:
			runs[-1].push_back(rank)
		else:
			run_index += 1
	runs = runs.filter(func(run:Array) -> bool: return run.size() > 0)
	runs.reverse() ## we do this because higher runs must be counted first
	print("runs: ", runs)
			
	var detected_straight:Array = []
	if cards_with_rank[14].size() == 0:
		## we have no aces, count straights normally
		for run:Array in runs:
			if run.size() >= 5:
				detected_straight = run
				break
	elif cards_with_rank[14].size() == 1:
		## we have one ace, need to test which way of counting it (low vs high)
		## results in a longer straight
		
		## check if we have a run with a 2 in front
		
		## check if we have a run with a 13 in back
		pass
	else:
		## we have two or more aces, they can both be used in one big straight
		pass
		
	if detected_straight.size() > 0:
		print("straight: ", detected_straight)
	
	

	## NOTE:
	## the highest rank will be located at the front
	## cus cards_with_rank has a reverse sorting
	var ranks_with_5_count:Array[int]
	var ranks_with_4_count:Array[int]
	var ranks_with_3_count:Array[int]
	var ranks_with_2_count:Array[int]
	var ranks_with_1_count:Array[int]
	for rank:int in cards_with_rank.keys():
		match cards_with_rank[rank].size():
			5: ranks_with_5_count.push_back(rank)
			4: ranks_with_4_count.push_back(rank)
			3: ranks_with_3_count.push_back(rank)
			2: ranks_with_2_count.push_back(rank)
			1: ranks_with_1_count.push_back(rank)
			_:pass
			
	print("ranks with 5 count: ", ranks_with_5_count)
	print("ranks with 4 count: ", ranks_with_4_count)
	print("ranks with 3 count: ", ranks_with_3_count)
	print("ranks with 2 count: ", ranks_with_2_count)
	print("ranks with 1 count: ", ranks_with_1_count)
			
	## check for hands containing 5 of a kind
	if ranks_with_5_count.size() >= 2:
		print("two quintets: ", ranks_with_5_count[0], "s and ",ranks_with_5_count[1], "s")
		## uhh fuck it, stuff more than double I'll add in The Future. I don't think they add much rn tbh
		## this is already pretty close to the max for a demo
	elif ranks_with_5_count.size() == 1:
		if ranks_with_4_count.size() > 0:
			print("full mansion: ", ranks_with_5_count[0], "s full of ", ranks_with_4_count[0], "s")
		else:
			print("five of a kind: ", ranks_with_5_count[0], "s")
	
	elif ranks_with_4_count.size() >= 2:
		print("two quartets: ", ranks_with_4_count[0],"s and ", ranks_with_4_count[1], "s")
	elif ranks_with_4_count.size() == 1:
		if ranks_with_3_count.size() > 0:
			print("full manor: ", ranks_with_4_count[0], "s full of ", ranks_with_3_count[0], "s")
		else:
			print("four of a kind: ", ranks_with_4_count[0], "s")
	
	
	elif ranks_with_3_count.size() >= 2:
		print("two triplets: ", ranks_with_3_count[0], "s and ", ranks_with_3_count[1], "s")
	elif ranks_with_3_count.size() == 1:
		if ranks_with_2_count.size() > 0:
			print("full manor: ", ranks_with_3_count[0], "s full of ", ranks_with_2_count[0], "s")
		else:
			print("three of a kind: ", ranks_with_3_count[0], "s")
	
	elif ranks_with_2_count.size() >= 2:
		print("two pair: ", ranks_with_2_count[0], "s and ", ranks_with_2_count[1], "s")
	elif ranks_with_2_count.size() == 1:
		print("pair of ", ranks_with_2_count[0], "s")
	else:
		print("high card: ", ranks_with_1_count[0])



func _on_debug_spawn_in_deck(id:Constants.CardID) -> void:
	var card:Card = card_tscn.instantiate()
	card.id = id
	deck.push_back(card)
func _on_debug_spawn_in_hand(id:Constants.CardID) -> void:
	var card:Card = card_tscn.instantiate()
	card.id = id
	hand_node.add_child(card)
