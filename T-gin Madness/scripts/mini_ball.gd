extends Area2D

var speed = 140.0
var target_position = Vector2.ZERO
var damage = 10
var delay = 0.35
var active = false

func _ready():
	add_to_group("boss_projectile")
	body_entered.connect(_on_body_entered)
	modulate.a = 0
	monitoring = false

func setup(pos):
	target_position = pos

func _process(delta):
	if not active:
		delay -= delta
		modulate.a = 1 - delay / 0.35
		if delay <= 0:
			modulate.a = 1
			active = true
			monitoring = true
		return

	global_position += global_position.direction_to(target_position) * speed * delta
	if global_position.distance_to(target_position) < 10:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
