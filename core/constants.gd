extends Node

enum Menu {
	gameplay, 
	deck_view,
	shop,
	between_rounds,
	
	main,
	options,
}

enum Suit {
	club,
	heart,
	spade,
	diamond,
}
enum ShopRarity {
	unavailable,
	common,
	uncommon,
	rare,
}

enum CardID {
	## standard playing cards
	c2,c3,c4,c5,c6,c7,c8,c9,ct,cj,cq,ck,ca,
	h2,h3,h4,h5,h6,h7,h8,h9,ht,hj,hq,hk,ha,
	s2,s3,s4,s5,s6,s7,s8,s9,st,sj,sq,sk,sa,
	d2,d3,d4,d5,d6,d7,d8,d9,dt,dj,dq,dk,da,
	
	## special 2s
	#snake_eyes, 
	#doppelganger, ## on play: clones the first played card (cannot clone itself) (implementation note: doppelganger can clone doppelganger)
	#seeing_double, ## on play: the hand is scored twice
	
	## special 3s
	#the_crab,
	#three_blind_mice, ## on play: draw three (additional) cards face down
	
	## special 4s
	#four_eyes,
	#four_seasons, ## counts as all four suits, no effect, mostly for a tutorial card
	#four_horsemen,
	#four_on_the_floor,
	
	## special 5s
	#high_five,
	#five_finger_discount, ## in hand: gain money from cutting
	
	## special 6s
	#six_feet_under,
	#watch_my_six, ## on draw: blind pick a six from your deck
	
	## "blind pick" is gonna be the deck selection view but all cards are face down
	## you can still sort by suit and rank like normal
	
	## special 7s
	#seven_deadly_sins,
	#lucky_sevens,
	
	## special 8s
	#arachnid,
	#hateful_eight,
	#quads 
	
	## special 9s
	#nine_lives,
	
	## special 10s
	#hangin_ten,
	
	## special jacks
	#jack_of_all_trades,
	
	## special queens
	#killer_queen,
	
	## special kings
	#king_of_the_hill,
	
	## special aces
	#ace_in_the_hole, ## on cut: grants an extra action ## fear not, bill clinton is the democrats ace in the hole
	#ace_up_the_sleeve, ## on discard this card returns to your hand
	#ace_from_space, ## on draw, search your deck for any ace
	#the_last_survivor, ## on play, cuts all other played cards
	#flushed_away, ## an ace that counts as all suits (I could change this to any card)
	
	
	
	
	## multivalued cards
	nine_to_five, ## counts as a 9 and a 5
	major_chord, ## counts as a 1,3, and 5
	dog, ## counts as a king or a 9, no effect, mostly for tutorial
	a4, ## a4 paper
	k4, ## 4K television
	#forty_niner,
	
	#seven_eleven, ## "convinience store"
	#straight_to_the_point, ## counts as all values, gives a bonus if used in a straight
	#one_step_back_two_steps_forward,
	#two_steps_forward_one_step_back,
	
	## eight six, the initial D car, idk what the effect will be
	
	
	
	#fifty_two_card_pickup, ## on play: shuffle all cards in hand into deck, draw the same number of cards into your hand as you had, +1 action (negates the action of playing)
	#twenty_six_keys, counts as a 2 and a six, idk what it does lol
	## OH MY GOD YOU CAN USE ALL THE TEXAS HOLDEM HOLE CARD NAMES
}

var base_cards_tex:Texture2D = preload("res://texture/base_cards.png")
var special_cards_tex:Texture2D = preload("res://texture/special_cards.png")
var card_data:Dictionary[CardID, CardData] = {
	CardID.c2:CardData.new("2 of Clubs",     [2],  [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(0,0)),
	CardID.c3:CardData.new("3 of Clubs",     [3],  [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(1,0)),
	CardID.c4:CardData.new("4 of Clubs",     [4],  [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(2,0)),
	CardID.c5:CardData.new("5 of Clubs",     [5],  [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(3,0)),
	CardID.c6:CardData.new("6 of Clubs",     [6],  [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(4,0)),
	CardID.c7:CardData.new("7 of Clubs",     [7],  [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(5,0)),
	CardID.c8:CardData.new("8 of Clubs",     [8],  [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(6,0)),
	CardID.c9:CardData.new("9 of Clubs",     [9],  [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(7,0)),
	CardID.ct:CardData.new("10 of Clubs",    [10], [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(8,0)),
	CardID.cj:CardData.new("Jack of Clubs",  [11], [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(9,0)),
	CardID.cq:CardData.new("Queen of Clubs", [12], [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(10,0)),
	CardID.ck:CardData.new("King of Clubs",  [13], [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(11,0)),
	CardID.ca:CardData.new("Ace of Clubs",   [14], [Suit.club], "", ShopRarity.unavailable, base_cards_tex, Vector2i(12,0)),
	
	CardID.h2:CardData.new("2 of Hearts",     [2],  [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(0,1)),
	CardID.h3:CardData.new("3 of Hearts",     [3],  [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(1,1)),
	CardID.h4:CardData.new("4 of Hearts",     [4],  [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(2,1)),
	CardID.h5:CardData.new("5 of Hearts",     [5],  [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(3,1)),
	CardID.h6:CardData.new("6 of Hearts",     [6],  [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(4,1)),
	CardID.h7:CardData.new("7 of Hearts",     [7],  [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(5,1)),
	CardID.h8:CardData.new("8 of Hearts",     [8],  [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(6,1)),
	CardID.h9:CardData.new("9 of Hearts",     [9],  [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(7,1)),
	CardID.ht:CardData.new("10 of Hearts",    [10], [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(8,1)),
	CardID.hj:CardData.new("Jack of Hearts",  [11], [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(9,1)),
	CardID.hq:CardData.new("Queen of Hearts", [12], [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(10,1)),
	CardID.hk:CardData.new("King of Hearts",  [13], [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(11,1)),
	CardID.ha:CardData.new("Ace of Hearts",   [14], [Suit.heart], "", ShopRarity.unavailable, base_cards_tex, Vector2i(12,1)),
	
	CardID.s2:CardData.new("2 of Spades",     [2],  [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(0,2)),
	CardID.s3:CardData.new("3 of Spades",     [3],  [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(1,2)),
	CardID.s4:CardData.new("4 of Spades",     [4],  [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(2,2)),
	CardID.s5:CardData.new("5 of Spades",     [5],  [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(3,2)),
	CardID.s6:CardData.new("6 of Spades",     [6],  [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(4,2)),
	CardID.s7:CardData.new("7 of Spades",     [7],  [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(5,2)),
	CardID.s8:CardData.new("8 of Spades",     [8],  [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(6,2)),
	CardID.s9:CardData.new("9 of Spades",     [9],  [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(7,2)),
	CardID.st:CardData.new("10 of Spades",    [10], [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(8,2)),
	CardID.sj:CardData.new("Jack of Spades",  [11], [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(9,2)),
	CardID.sq:CardData.new("Queen of Spades", [12], [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(10,2)),
	CardID.sk:CardData.new("King of Spades",  [13], [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(11,2)),
	CardID.sa:CardData.new("Ace of Spades",   [14], [Suit.spade], "", ShopRarity.unavailable, base_cards_tex, Vector2i(12,2)),
	
	CardID.d2:CardData.new("2 of Diamonds",     [2],  [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(0,3)),
	CardID.d3:CardData.new("3 of Diamonds",     [3],  [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(1,3)),
	CardID.d4:CardData.new("4 of Diamonds",     [4],  [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(2,3)),
	CardID.d5:CardData.new("5 of Diamonds",     [5],  [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(3,3)),
	CardID.d6:CardData.new("6 of Diamonds",     [6],  [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(4,3)),
	CardID.d7:CardData.new("7 of Diamonds",     [7],  [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(5,3)),
	CardID.d8:CardData.new("8 of Diamonds",     [8],  [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(6,3)),
	CardID.d9:CardData.new("9 of Diamonds",     [9],  [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(7,3)),
	CardID.dt:CardData.new("10 of Diamonds",    [10], [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(8,3)),
	CardID.dj:CardData.new("Jack of Diamonds",  [11], [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(9,3)),
	CardID.dq:CardData.new("Queen of Diamonds", [12], [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(10,3)),
	CardID.dk:CardData.new("King of Diamonds",  [13], [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(11,3)),
	CardID.da:CardData.new("Ace of Diamonds",   [14], [Suit.diamond], "", ShopRarity.unavailable, base_cards_tex, Vector2i(12,3)),
	
	CardID.dog:          CardData.new("Canine",       [13,9],  [Suit.heart], "", ShopRarity.unavailable, special_cards_tex, Vector2i(0,0)),
	CardID.nine_to_five: CardData.new("Workday",      [9,5],   [Suit.spade], "", ShopRarity.unavailable, special_cards_tex, Vector2i(1,0)),
	CardID.major_chord:  CardData.new("Major Chord",  [14, 3, 5], [Suit.club],   "", ShopRarity.unavailable, special_cards_tex, Vector2i(2,0)),
	CardID.a4:           CardData.new("Paper",        [14,4],  [Suit.diamond], "", ShopRarity.unavailable, special_cards_tex, Vector2i(3,0)),
	CardID.k4:           CardData.new("Flatscreen",   [13,4],  [Suit.diamond], "", ShopRarity.unavailable, special_cards_tex, Vector2i(4,0)),
}
