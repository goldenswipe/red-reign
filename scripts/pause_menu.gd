extends Control

class_name PauseMenu

@onready var container = $VBoxContainer

func _ready():
	pass

func show_menu():
	visible = true
	
	# Create pause UI
	var title = Label.new()
	title.text = "PAUSED"
	title.add_theme_font_size_override("font_size", 48)
	container.add_child(title)
	
	var resume_btn = Button.new()
	resume_btn.text = "Resume (P)"
	resume_btn.pressed.connect(_on_resume_pressed)
	container.add_child(resume_btn)
	
	var settings_btn = Button.new()
	settings_btn.text = "Settings"
	settings_btn.pressed.connect(_on_settings_pressed)
	container.add_child(settings_btn)
	
	var quit_btn = Button.new()
	quit_btn.text = "Quit to Menu"
	quit_btn.pressed.connect(_on_quit_pressed)
	container.add_child(quit_btn)

func _on_resume_pressed():
	var game_manager = get_tree().get_root().find_child("GameManager", true, false)
	if game_manager:
		game_manager.toggle_pause()

func _on_settings_pressed():
	print("Settings menu would open here")

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
