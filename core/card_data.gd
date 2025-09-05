class_name CardData
extends RefCounted

var title:String
var suits :Array[Constants.Suit]
var values:Array[int]
var description:String
var shop_rarity:Constants.ShopRarity
var image:Texture
var image_coord:Vector2i


## var discard_value:int
## idk what else I'd want to include


func _init(
	_title:String,
	_suits :Array[Constants.Suit],
	_values:Array[int],
	_description:String,
	_shop_rarity:Constants.ShopRarity,
	_image:Texture,
	_image_coord:Vector2i,
) -> void:
	title       = _title
	suits       = _suits
	values      = _values
	description = _description
	shop_rarity = _shop_rarity
	image       = _image
	image_coord = _image_coord
