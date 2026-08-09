extends Area2D

class_name Tower

@export var tower_type: String = "basic"
@export var damage: int = 10
@export var fire_rate: float = 1.0
@export var range_radius: float = 200.0
@export var cost: int = 100
@export var level: int = 1
@export var base_color: Color = Color.RED

var current_target: Enemy = null
var fire_timer: float = 0.0
var enemies_in_range: Array[Enemy] = []

@onready var sprite = $Sprite2D
@onready var range_indicator = $RangeIndicator

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	# Set up visuals
	sprite.modulate = base_color
	
	# Set up range indicator
	range_indicator.scale = Vector2.ONE * (range_radius * 2 / 100.0)
	range_indicator.modulate.a = 0.2

func _process(delta):
	update_target()
	
	if current_target and current_target.is_alive():
		fire_timer -= delta
		if fire_timer <= 0:
			fire()
			fire_timer = 1.0 / fire_rate

func update_target():
	# Find the furthest along enemy in range
	var best_target: Enemy = null
	var best_progress = 0.0
	
	for enemy in enemies_in_range:
		if enemy.is_alive():
			if enemy.path_progress > best_progress:
				best_progress = enemy.path_progress
				best_target = enemy
	
	current_target = best_target

func fire():
	if current_target == null:
		return
	
	# Create projectile
	var projectile = preload("res://scenes/projectile.tscn").instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.target = current_target
	projectile.damage = damage
	
	# Sound effect
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
	$AudioStreamPlayer2D.play()

func _on_area_entered(area):
	if area is Enemy:
		enemies_in_range.append(area)

func _on_area_exited(area):
	if area is Enemy:
		enemies_in_range.erase(area)
		if current_target == area:
			current_target = null

func upgrade():
	level += 1
	damage = int(damage * 1.2)
	fire_rate *= 1.1
	$Sprite2D.scale *= 1.1

func sell() -> int:
	var refund = int(cost * 0.75)
	queue_free()
	return refund

func show_range(show: bool):
	range_indicator.visible = show
