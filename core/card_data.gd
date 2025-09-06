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
	ranks      = _ranks
	suits       = _suits
	description = _description
	shop_rarity = _shop_rarity
	texture       = _texture
	texture_coord = _texture_coord
