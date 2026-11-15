extends CanvasLayer

@onready var button = $Overlay/CenterContainer/VBoxContainer/Button
@onready var overlay_control = $Overlay

static var shown_once = false


func _ready():
	if shown_once:
		get_tree().paused = false
		queue_free()
		return



	shown_once = true
	get_tree().paused = true


	if not button.pressed.is_connected(_on_begin_pressed):
		button.pressed.connect(_on_begin_pressed)

func _on_begin_pressed():
	button.disabled = true





	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(overlay_control, "modulate:a", 0.0, 0.5)

	await tween.finished



	get_tree().paused = false
	queue_free()
