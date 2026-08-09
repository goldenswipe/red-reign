extends CharacterBody2D

class_name Enemy

@export var speed: float = 200.0
@export var max_health: int = 30
@export var gold_reward: int = 50
@export var enemy_type: String = "basic"

var current_health: int
var path_progress: float = 0.0
var path: Path2D
var path_follow: PathFollow2D
var is_dead: bool = false

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var health_bar = $HealthBar

func _ready():
	current_health = max_health
	update_health_bar()
	
	# Setup path following
	path = get_tree().get_root().find_child("EnemyPath", true, false)
	if path:
		path_follow = path.get_node("PathFollow2D")
		path_follow.add_child(self)
		global_position = path_follow.global_position

func _process(delta):
	if is_dead:
		return
	
	if path_follow:
		path_follow.progress += speed * delta
		path_progress = path_follow.unit_offset
		
		# Check if reached end
		if path_follow.unit_offset >= 1.0:
			reach_end()

func take_damage(damage: int):
	current_health -= damage
	update_health_bar()
	
	if current_health <= 0:
		die()

func update_health_bar():
	var health_percent = float(current_health) / max_health
	health_bar.scale.x = health_percent
	health_bar.modulate = Color.interpolate(Color.RED, Color.GREEN, health_percent)

func die():
	if is_dead:
		return

	is_dead = true
	var game_manager = get_tree().get_root().find_child("GameManager", true, false)
	if game_manager:
		game_manager.add_gold(gold_reward)

	var wave_manager = get_tree().get_root().find_child("WaveManager", true, false)
	if wave_manager:
		wave_manager.check_wave_complete()

	# Death animation
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.3)
	tween.tween_callback(queue_free)

func reach_end():
	is_dead = true
	var game_manager = get_tree().get_root().find_child("GameManager", true, false)
	if game_manager:
		game_manager.lose_life()

	var wave_manager = get_tree().get_root().find_child("WaveManager", true, false)
	if wave_manager:
		wave_manager.check_wave_complete()

	queue_free()

func is_alive() -> bool:
	return !is_dead and current_health > 0

func get_color_by_type() -> Color:
	match enemy_type:
		"basic":
			return Color.DARK_GRAY
		"fast":
			return Color.YELLOW
		"tank":
			return Color.ORANGE
		"blimp":
			return Color.PURPLE
		_:
			return Color.RED
	
func set_color():
	sprite.modulate = get_color_by_type()
