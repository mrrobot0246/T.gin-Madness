extends Node2D

static var checkpoint_position = Vector2.ZERO
static var has_checkpoint = false

@onready var player = $Player

func _ready():
	Engine.time_scale = 1.0
	if has_checkpoint:
		player.global_position = checkpoint_position
		player.velocity = Vector2.ZERO

		var tutorial = get_node_or_null("Tutorial")
		if tutorial:
			tutorial.queue_free()
		get_tree().paused = false

func set_checkpoint(pos):
	checkpoint_position = pos
	has_checkpoint = true

static func clear_checkpoint():
	has_checkpoint = false
	checkpoint_position = Vector2.ZERO

func restart_level():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
