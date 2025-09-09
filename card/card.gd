class_name Card
extends Node2D


const SELECT_THRESHOLD:int = 10 ## this will go in options
const HAND_WIDTH:float = 400

const MAX_ANGLE:float = deg_to_rad(17)
const CURVE_HEIGHT:float = 60

const SPEED_LIMIT:float = 1000
const ACCELERATION:float = 16
#region Game Logic
var id:Constants.CardID:
	set(value):
		id = value
		if is_node_ready():
			(%Sprite as Sprite2D).texture = data.texture
			(%Sprite as Sprite2D).frame_coords = data.texture_coord
			
			(%Shadow as Sprite2D).texture = data.texture
			(%Shadow as Sprite2D).frame_coords = data.texture_coord
## other card state goes here
var disabled:bool
var selected:bool

func _ready() -> void:
	
	#var w:Array[float] = [1.0,0.75,0.5,0.25,0.0]
	#w.shuffle()
	#(%Interaction as ColorRect).color = Color(w[0],w[1],w[2])
	
	selected = false

	
## card specific state also goes here
var data:CardData:
	get(): return Constants.card_data[id]
var ranks:Array[int]:
	get(): return data.ranks
var suits:Array[Constants.Suit]:
	get(): return data.suits

func _to_string() -> String:
	var suits_str:Array = suits.map(func(suit:Constants.Suit) ->String: return Constants.Suit.keys()[suit])
	return "id: " + Constants.CardID.keys()[id] +\
		   #"\ntitle: " + data.title
		"\nranks: " + str(ranks) +\
		" suits: " + str(suits_str) #+\
		
#endregion


func hand_anchor_position() -> float:
	var ncards:float = float(get_parent().get_child_count())
	return (float(get_index()) + 0.5 - ncards * 0.5) / ncards * HAND_WIDTH
	
	
## moving to left causes an index change instantly
## moving to the right causes an index change too late
## I should probably be using roundi instead of int idfk
## also needs to scale based off of the hand node scale

func hand_anchor_position_inverse() -> int:
	var ncards:float = float(get_parent().get_child_count())
	
	var p:float =   get_parent().to_local(get_global_mouse_position()).x\
	#var p:float =   get_global_mouse_position().x\
					
				   + (%Interaction.size * 0.5 - drag_point).x * global_scale.x
				
	return int(p/HAND_WIDTH * ncards + ncards * 0.5 - 0.5)
	
#func _draw() -> void:
	#draw_circle(Vector2(0, 56), 5, (%Interaction as ColorRect).color)
func _process(delta: float) -> void:
	if not is_node_ready(): return
	
	position.x = hand_anchor_position()
	
	## NOTE: render.top_level == true
	if dragged:
		(%Render as Node2D).z_index = get_parent().get_child_count()
		## lerp render to mouse
		 
		#var next_position:Vector2 = lerp(
		(%Render as Node2D).position = lerp(
			(%Render as Node2D).position, 
			get_global_mouse_position() + (%Interaction.size * 0.5 - drag_point) * global_scale.x,
			minf(delta * ACCELERATION,1.0)
		)
		#(%Render as Node2D).position += (next_position - (%Render as Node2D).position).limit_length(delta * SPEED_LIMIT)
		
		
		#(%Render as Node2D).rotation = lerp
		
		## check if we need to re-arrange the card orders
		var hovered_index:int = clampi(
			## this is the INVERSE of position.x, defined earlier in _process()
			hand_anchor_position_inverse(),
			0,
			get_parent().get_child_count() - 1
		)
		if get_index() != hovered_index:
			get_parent().move_child(self,hovered_index)
		
	else:
		(%Render as Node2D).z_index = get_index()
		var selected_offset:Vector2
		if selected:
			selected_offset = Vector2(0,-60) * global_scale.x
		else:
			selected_offset = Vector2(0,0)
		
		var next_position:Vector2 = lerp(
			(%Render as Node2D).position, 
			global_position + selected_offset,
			minf(delta * ACCELERATION,1.0)
		)
		(%Render as Node2D).position += (next_position - (%Render as Node2D).position).limit_length(delta * SPEED_LIMIT)
	
var dragged:bool
var drag_point:Vector2
var drag_time_start:int
var drag_start_index:int

func _on_interaction_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	
	if (event as InputEventMouseButton).pressed:
		dragged = true
		drag_point = (event as InputEventMouseButton).position
		drag_time_start = Engine.get_frames_drawn()
		drag_start_index = get_index()
	else:
		dragged = false
		## check if input was a quick click, and that we have not moved;
		if (Engine.get_frames_drawn() - drag_time_start) < SELECT_THRESHOLD and\
		   drag_start_index == get_index():
			## we treat this release as a toggle input
			if selected:
				selected = false
			else:
				var total_selected:int = 0
				for card:Card in get_parent().get_children():
					if card.selected: total_selected += 1
				if total_selected < 5:
					selected = true


func _on_tree_entered() -> void:
	(%Sprite as Sprite2D).texture = data.texture
	(%Sprite as Sprite2D).frame_coords = data.texture_coord
	
	(%Shadow as Sprite2D).texture = data.texture
	(%Shadow as Sprite2D).frame_coords = data.texture_coord
	
	
	## NOTE: render.top_level == true
	(%Render as Node2D).scale = global_scale
