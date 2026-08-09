extends Node2D

class_name PlacementGrid

var grid_size: int = 40
var grid_visible: bool = false
var path_buffer: float = 80.0

@onready var path = get_tree().get_root().find_child("EnemyPath", true, false)

func _ready():
	pass

func _draw():
	if grid_visible:
		draw_grid()

func draw_grid():
	var viewport_size = get_viewport_rect().size
	var color = Color(0.4, 0.4, 0.4, 0.2)
	
	for x in range(0, int(viewport_size.x), grid_size):
		draw_line(Vector2(x, 0), Vector2(x, viewport_size.y), color, 1)
	
	for y in range(0, int(viewport_size.y), grid_size):
		draw_line(Vector2(0, y), Vector2(viewport_size.x, y), color, 1)

func is_near_path(position: Vector2) -> bool:
	if not path:
		return false
	
	# Check distance to path
	var closest_distance = path.curve.get_closest_point(position).distance_to(position)
	return closest_distance < path_buffer

func toggle_grid_visibility():
	grid_visible = !grid_visible
	queue_redraw()
