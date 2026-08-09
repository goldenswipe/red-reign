extends Control

class_name TowerMenu

func _ready():
	pass

func show_at_position(position: Vector2, tower_info: Dictionary):
	visible = true
	global_position = position - size / 2
	
	# Create tower menu options
	for child in get_children():
		child.queue_free()
	
	var vbox = VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(150, 100)
	add_child(vbox)
	
	# Upgrade button
	var upgrade_btn = Button.new()
	upgrade_btn.text = "Upgrade ($25)"
	upgrade_btn.pressed.connect(_on_upgrade_pressed)
	vbox.add_child(upgrade_btn)
	
	# Sell button
	var sell_btn = Button.new()
	sell_btn.text = "Sell ($%d)" % int(tower_info.get("cost", 100) * 0.75)
	sell_btn.pressed.connect(_on_sell_pressed)
	vbox.add_child(sell_btn)
	
	# Close button
	var close_btn = Button.new()
	close_btn.text = "Close"
	close_btn.pressed.connect(func(): visible = false)
	vbox.add_child(close_btn)

func _on_upgrade_pressed():
	print("Tower would be upgraded here")
	visible = false

func _on_sell_pressed():
	print("Tower would be sold here")
	visible = false
