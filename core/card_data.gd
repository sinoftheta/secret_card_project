class_name CardData
extends RefCounted

var title:String
var ranks:Array[int]
var suits :Array[Constants.Suit]
var description:String
var shop_rarity:Constants.ShopRarity
var texture:Texture
var texture_coord:Vector2i


## var discard_value:int
## idk what else I'd want to include


func _init(
	_title:String,
	_ranks:Array[int],
	_suits :Array[Constants.Suit],
	_description:String,
	_shop_rarity:Constants.ShopRarity,
	_texture:Texture,
	_texture_coord:Vector2i,
) -> void:
	title       = _title
	
	## normalize rank data
	ranks      = _ranks
	assert(ranks.size() > 0)
	ranks.sort()
	var rank_counts:Dictionary[int,int] = {}
	for rank:int in ranks:
		assert(2 <= rank and rank <= 14)
		if not rank_counts.has(rank):
			rank_counts[rank] = 1
		else:
			rank_counts[rank] = rank_counts[rank] + 1
	for count:int in rank_counts.values():
		assert(count == 1)
	
	## normalize suit data
	suits       = _suits
	assert(suits.size() > 0)
	suits.sort()
	var suit_counts:Dictionary[int,int] = {}
	for suit:int in suits:
		assert(Constants.Suit.values().has(suit))
		if not suit_counts.has(suit):
			suit_counts[suit] = 1
		else:
			suit_counts[suit] = suit_counts[suit] + 1
	for count:int in suit_counts.values():
		assert(count == 1)

	description = _description
	shop_rarity = _shop_rarity
	texture       = _texture
	texture_coord = _texture_coord
