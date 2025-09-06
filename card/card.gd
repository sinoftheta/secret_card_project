class_name Card
extends Node2D


const SELECT_THRESHOLD:int = 10 ## this will go in options
const HAND_WIDTH:float = 400
#region Game Logic
var id:Constants.CardID:
	set(value):
		id = value
		if is_node_ready():
			(%Sprite as Sprite2D).texture = data.texture
			(%Sprite as Sprite2D).frame_coords = data.texture_coord
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

func print_state() -> void:
	print("id: ", Constants.CardID.keys()[id], "\ntitle: ", data.title)
#endregion

func _draw() -> void:
	draw_circle(Vector2(0, 56), 5, (%Interaction as ColorRect).color)
func _process(delta: float) -> void:
	position.x = float(get_index()) / float(get_parent().get_child_count()) * HAND_WIDTH
	
	## render.top_level == true
	if dragged:
		(%Render as Node2D).z_index = get_parent().get_child_count()
		## lerp render to mouse
		print( )
		(%Render as Node2D).position = lerp(
			(%Render as Node2D).position, 
			get_global_mouse_position() - drag_point + %Interaction.size * 0.5, 
			minf(delta * 16.0,1.0)
		)
		
		## check if we need to re-arrange the card orders
		var hovered_index:int = clampi(
			int(get_parent().to_local(get_global_mouse_position()).x / HAND_WIDTH * float(get_parent().get_child_count()) + 0.5),
			0,
			get_parent().get_child_count() - 1
		)
		if get_index() != hovered_index:
			get_parent().move_child(self,hovered_index)
		
	else:
		(%Render as Node2D).z_index = get_index()
		var selected_offset:Vector2
		if selected:
			selected_offset = Vector2(0,-60)
		else:
			selected_offset = Vector2(0,0)
		(%Render as Node2D).position = lerp(
			(%Render as Node2D).position, 
			global_position + selected_offset, 
			minf(delta * 16.0,1.0)
		)
	
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
	
	## hrmmm
	(%Render as Node2D).scale = get_parent().scale
