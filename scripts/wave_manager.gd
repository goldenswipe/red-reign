extends Node

class_name WaveManager

@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var spawn_point: Vector2 = Vector2(100, 360)

var current_wave: int = 0
var enemies_spawned: int = 0
var enemies_remaining: int = 0
var wave_active: bool = false

# Wave data
var wave_data: Array = [
	{"count": 5, "type": "basic", "delay": 0.5},
	{"count": 8, "type": "basic", "delay": 0.4},
	{"count": 10, "type": "basic", "delay": 0.3, "mixed": [{"type": "fast", "count": 3, "delay": 0.5}]},
	{"count": 12, "type": "basic", "delay": 0.3, "mixed": [{"type": "tank", "count": 2, "delay": 1.0}]},
	{"count": 15, "type": "fast", "delay": 0.3},
	{"count": 10, "type": "tank", "delay": 0.6},
	{"count": 20, "type": "basic", "delay": 0.2},
	{"count": 8, "type": "blimp", "delay": 1.0},
	{"count": 30, "type": "mixed", "delay": 0.2},
	{"count": 50, "type": "mixed", "delay": 0.15},
]

func _ready():
	pass

func start_wave(wave_num: int):
	current_wave = wave_num
	wave_active = true
	enemies_spawned = 0
	enemies_remaining = 0
	
	if current_wave <= wave_data.size():
		spawn_wave(wave_data[current_wave - 1])
	else:
		# Endless waves scale difficulty
		spawn_endless_wave(current_wave)

func spawn_wave(wave_info: Dictionary):
	if wave_info.get("mixed"):
		# Spawn main wave type
		spawn_enemy_group(wave_info["type"], wave_info["count"], wave_info["delay"])
		
		# Spawn mixed types
		for mixed in wave_info["mixed"]:
			await get_tree().create_timer(1.0).timeout
			spawn_enemy_group(mixed["type"], mixed["count"], mixed["delay"])
	else:
		spawn_enemy_group(wave_info["type"], wave_info["count"], wave_info["delay"])

func spawn_enemy_group(enemy_type: String, count: int, delay: float):
	for i in range(count):
		spawn_enemy(enemy_type)
		enemies_remaining += 1
		
		if i < count - 1:
			await get_tree().create_timer(delay).timeout

func spawn_enemy(enemy_type: String):
	var enemy = enemy_scene.instantiate()
	enemy.enemy_type = enemy_type
	
	# Set stats based on type
	match enemy_type:
		"basic":
			enemy.speed = 200
			enemy.max_health = 30
			enemy.gold_reward = 50
		"fast":
			enemy.speed = 300
			enemy.max_health = 15
			enemy.gold_reward = 75
		"tank":
			enemy.speed = 100
			enemy.max_health = 80
			enemy.gold_reward = 150
		"blimp":
			enemy.speed = 150
			enemy.max_health = 50
			enemy.gold_reward = 100
	
	enemy.current_health = enemy.max_health
	enemy.set_color()
	get_parent().add_child(enemy)
	enemies_spawned += 1

func check_wave_complete():
	enemies_remaining -= 1
	if enemies_remaining <= 0 and wave_active:
		wave_active = false
		await get_tree().create_timer(2.0).timeout
		var game_manager = get_parent()
		
		# Check if it's the final wave
		if current_wave >= wave_data.size():
			game_manager.end_game(true)
		else:
			game_manager.start_wave()

func spawn_endless_wave(wave_num: int):
	var difficulty = 1.0 + (wave_num - wave_data.size()) * 0.15
	var enemy_count = int(20 + (wave_num - wave_data.size()) * 5)
	var delay = 0.3 - (wave_num - wave_data.size()) * 0.02
	
	spawn_enemy_group("basic", enemy_count, max(0.1, delay))
