extends Area2D

var speed = 150.0
var damage = 30
var delay = 0.35
var active = false

func _ready():
	add_to_group("boss_projectile")
	damage = randi_range(25, 35)
	body_entered.connect(_on_body_entered)
	modulate.a = 0
	monitoring = false

func _process(delta):
	if not active:
		delay -= delta
		modulate.a = 1 - delay / 0.35
		if delay <= 0:
			modulate.a = 1
			active = true
			monitoring = true
		return

	position.x -= speed * delta
	if global_position.x < -260:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
