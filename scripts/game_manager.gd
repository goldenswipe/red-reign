extends Node2D

class_name GameManager

# Game state
var is_paused = false
var current_level = 1
var gold = 500
var lives = 20
var wave = 0

# Signals
signal gold_changed(new_gold)
signal lives_changed(new_lives)
signal wave_started(wave_number)
signal game_over(victory)

func _ready():
	$AudioStreamPlayer.bus = "Master"
	start_game()

func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	$UI/PauseMenu.visible = is_paused

func add_gold(amount: int):
	gold += amount
	gold_changed.emit(gold)

func subtract_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		gold_changed.emit(gold)
		return true
	return false

func lose_life():
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		end_game(false)

func start_game():
	wave = 0
	start_wave()

func start_wave():
	wave += 1
	wave_started.emit(wave)
	$WaveManager.start_wave(wave)

func end_game(victory: bool):
	is_paused = true
	get_tree().paused = true
	game_over.emit(victory)
	if victory:
		$UI/GameOverScreen.show_victory()
	else:
		$UI/GameOverScreen.show_defeat()
