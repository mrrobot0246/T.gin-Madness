extends CanvasLayer

const GameScript = preload("res://scripts/game.gd")

@onready var resume_button = $Root/Center/Panel/VBox/Resume
@onready var main_menu_button = $Root/Center/Panel/VBox/MainMenu
@onready var music_slider = $Root/Center/Panel/VBox/MusicSlider

var is_open = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	music_slider.value = MusicPlayer.music_volume
	music_slider.value_changed.connect(_on_music_changed)
	resume_button.pressed.connect(close)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func _unhandled_input(event):
	if not event.is_action_pressed("ui_cancel"):
		return
	if get_tree().paused and not is_open:
		return
	if is_open:
		close()
	else:
		open()
	get_viewport().set_input_as_handled()

func open():
	is_open = true
	visible = true
	get_tree().paused = true
	resume_button.grab_focus()

func close():
	is_open = false
	visible = false
	get_tree().paused = false

func _on_music_changed(value):
	MusicPlayer.set_music_volume(value)

func _on_main_menu_pressed():
	get_tree().paused = false
	GameScript.clear_checkpoint()
	GameState.reset()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
