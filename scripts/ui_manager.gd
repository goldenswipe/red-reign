extends CanvasLayer

class_name UIManager

@onready var gold_label = $HBoxContainer/GoldLabel
@onready var lives_label = $HBoxContainer/LivesLabel
@onready var wave_label = $HBoxContainer/WaveLabel
@onready var pause_menu = $PauseMenu
@onready var tower_menu = $TowerMenu
@onready var game_over_screen = $GameOverScreen

var game_manager: GameManager

func _ready():
	game_manager = get_tree().get_root().find_child("GameManager", true, false)
	
	if game_manager:
		game_manager.gold_changed.connect(_on_gold_changed)
		game_manager.lives_changed.connect(_on_lives_changed)
		game_manager.wave_started.connect(_on_wave_started)
	
	update_display()

func update_display():
	if game_manager:
		gold_label.text = "Gold: %d" % game_manager.gold
		lives_label.text = "Lives: %d" % game_manager.lives
		wave_label.text = "Wave: %d" % game_manager.wave

func _on_gold_changed(new_gold: int):
	gold_label.text = "Gold: %d" % new_gold

func _on_lives_changed(new_lives: int):
	lives_label.text = "Lives: %d" % new_lives

func _on_wave_started(wave_number: int):
	wave_label.text = "Wave: %d" % wave_number
	# Show wave start animation
	wave_label.modulate = Color.YELLOW
	await get_tree().create_timer(0.5).timeout
	wave_label.modulate = Color.WHITE

func show_tower_menu(position: Vector2, tower_info: Dictionary):
	tower_menu.show_at_position(position, tower_info)

func hide_tower_menu():
	tower_menu.hide()
