extends Control

class_name GameOverScreen

@onready var container = $VBoxContainer

func _ready():
	pass

func show_victory():
	visible = true
	_show_result(true)

func show_defeat():
	visible = true
	_show_result(false)

func _show_result(victory: bool):
	# Clear existing children
	for child in container.get_children():
		child.queue_free()
	
	var title = Label.new()
	title.text = "VICTORY!" if victory else "DEFEAT!"
	title.add_theme_font_size_override("font_size", 64)
	title.modulate = Color.YELLOW if victory else Color.RED
	container.add_child(title)
	
	var game_manager = get_tree().get_root().find_child("GameManager", true, false)
	var stats = Label.new()
	if game_manager:
		stats.text = "Wave: %d\nGold: %d\nLives: %d" % [
			game_manager.wave,
			game_manager.gold,
			game_manager.lives
		]
	stats.add_theme_font_size_override("font_size", 24)
	container.add_child(stats)
	
	# Add spacing
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	container.add_child(spacer)
	
	var retry_btn = Button.new()
	retry_btn.text = "Play Again"
	retry_btn.pressed.connect(_on_retry_pressed)
	retry_btn.custom_minimum_size = Vector2(200, 50)
	container.add_child(retry_btn)
	
	var quit_btn = Button.new()
	quit_btn.text = "Main Menu"
	quit_btn.pressed.connect(_on_quit_pressed)
	quit_btn.custom_minimum_size = Vector2(200, 50)
	container.add_child(quit_btn)

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")
