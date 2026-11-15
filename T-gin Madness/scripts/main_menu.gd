extends Control

const GameScript = preload("res://scripts/game.gd")

@onready var play_button = $Center/Panel/VBox/Play
@onready var quit_button = $Center/Panel/VBox/Quit

func _ready():
	get_tree().paused = false
	GameScript.clear_checkpoint()
	GameState.reset()
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	play_button.grab_focus()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	get_tree().quit()
