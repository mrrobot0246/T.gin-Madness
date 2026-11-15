extends Area2D

@export var activated_color = Color(0.4, 1.0, 0.4)

var activated = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if activated:
		return
	if body.is_in_group("player"):
		activated = true
		get_tree().current_scene.set_checkpoint(body.global_position)
		modulate = activated_color
