extends Node2D

@onready var boss_trigger = $BossTrigger

var triggered = false

func _ready():
	boss_trigger.body_entered.connect(_on_boss_trigger_entered)



func _on_boss_trigger_entered(body):
	if triggered:
		return
	if body.name == "Player" or body.is_in_group("player"):
		triggered = true
		get_tree().call_deferred("change_scene_to_file", "res://scenes/boss_arena.tscn")
