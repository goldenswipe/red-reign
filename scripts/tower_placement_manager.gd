extends Node2D

class_name TowerPlacementManager

var tower_templates: Dictionary = {
	"basic": preload("res://scenes/towers/basic_tower.tscn"),
	"sniper": preload("res://scenes/towers/sniper_tower.tscn"),
	"splash": preload("res://scenes/towers/splash_tower.tscn"),
}

var selected_tower_type: String = ""
var preview_tower: Node2D = null
var valid_placement: bool = false
var game_manager: GameManager

@onready var placement_grid = $PlacementGrid

func _ready():
	game_manager = get_parent()
	Input.mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if selected_tower_type != "":
				try_place_tower()

func _process(_delta):
	if selected_tower_type != "":
		update_preview_position()

func select_tower(tower_type: String):
	selected_tower_type = tower_type
	create_preview_tower()

func create_preview_tower():
	if preview_tower:
		preview_tower.queue_free()
	
	if tower_type in tower_templates:
		preview_tower = tower_templates[tower_type].instantiate()
		preview_tower.modulate.a = 0.5
		add_child(preview_tower)

func update_preview_position():
	if preview_tower:
		preview_tower.global_position = get_global_mouse_position()
		valid_placement = check_valid_placement(preview_tower.global_position)
		preview_tower.modulate.self_modulate.a = 0.7 if valid_placement else 0.3

func check_valid_placement(pos: Vector2) -> bool:
	# Check if within map bounds
	var map_rect = Rect2(Vector2.ZERO, get_viewport_rect().size)
	if not map_rect.has_point(pos):
		return false
	
	# Check distance from path
	if placement_grid.is_near_path(pos):
		return false
	
	# Check if tower already exists there
	for child in get_children():
		if child is Tower:
			if child.global_position.distance_to(pos) < 80:
				return false
	
	return true

func try_place_tower():
	if not valid_placement:
		return
	
	var tower_data = get_tower_data(selected_tower_type)
	if game_manager.subtract_gold(tower_data["cost"]):
		place_tower(selected_tower_type, get_global_mouse_position())
		selected_tower_type = ""
		if preview_tower:
			preview_tower.queue_free()
			preview_tower = null

func place_tower(tower_type: String, pos: Vector2):
	var tower_scene = tower_templates[tower_type]
	var tower = tower_scene.instantiate()
	tower.global_position = pos
	add_child(tower)

func get_tower_data(tower_type: String) -> Dictionary:
	match tower_type:
		"basic":
			return {"cost": 100, "damage": 10, "fire_rate": 1.0, "range": 200}
		"sniper":
			return {"cost": 200, "damage": 25, "fire_rate": 0.5, "range": 300}
		"splash":
			return {"cost": 150, "damage": 15, "fire_rate": 0.8, "range": 250}
		_:
			return {"cost": 100, "damage": 10, "fire_rate": 1.0, "range": 200}

func cancel_selection():
	selected_tower_type = ""
	if preview_tower:
		preview_tower.queue_free()
		preview_tower = null
