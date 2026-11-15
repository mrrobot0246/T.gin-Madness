extends Node2D

var max_hp = 250
var current_hp = 250
var is_vulnerable = false
var defeated = false
var attack_count = 0
var hit_cooldown = 0.0
var player = null
var start_y = 0.0
var time = 0.0

@export var mini_ball_scene = null
@export var cross_projectile_scene = null

@onready var sprite = $Sprite2D
@onready var shoot_point = $ShootPoint
@onready var attack_timer = $AttackTimer
@onready var vulnerable_timer = $VulnerableTimer
@onready var hitbox = $Hitbox
@onready var hit_sound = $HitSound
@onready var power_sound = $PowerSound
@onready var death_sound = $DeathSound

func _ready():
	current_hp = max_hp
	start_y = position.y
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	vulnerable_timer.timeout.connect(_on_vulnerable_timeout)
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	time += delta * 3
	position.y = start_y + sin(time) * 20
	if hit_cooldown > 0:
		hit_cooldown -= delta
	if defeated:
		return

	for body in hitbox.get_overlapping_bodies():
		if body.is_in_group("player"):
			if is_vulnerable:
				hit_boss()
			else:
				body.take_damage(15)

func _on_attack_timer_timeout():
	if defeated or is_vulnerable:
		return

	attack_timer.stop()
	attack_count += 1

	if attack_count >= 3:
		attack_count = 0
		await fire_cross_volley()
		if is_inside_tree():
			enter_vulnerability_window()
	else:
		fire_mini_ball_spread()
		attack_timer.start()

func fire_mini_ball_spread():
	if not mini_ball_scene or not player:
		return

	var origin = shoot_point.global_position
	var direction = origin.direction_to(player.global_position)

	for angle in [-0.34, -0.17, 0, 0.17, 0.34]:
		var ball = mini_ball_scene.instantiate()
		ball.global_position = origin
		ball.setup(origin + direction.rotated(angle) * 700)
		get_tree().current_scene.add_child(ball)

func fire_cross_volley():
	if not cross_projectile_scene or not player:
		return

	_spawn_cross(player.global_position.y, 170)
	await get_tree().create_timer(0.55, false).timeout
	if not is_inside_tree():
		return
	_spawn_cross(player.global_position.y - 42, 150)
	await get_tree().create_timer(0.55, false).timeout
	if not is_inside_tree():
		return
	_spawn_cross(player.global_position.y - 84, 130)

func _spawn_cross(y, speed):
	var cross = cross_projectile_scene.instantiate()
	cross.global_position = Vector2(shoot_point.global_position.x, y)
	cross.speed = speed
	get_tree().current_scene.add_child(cross)

func enter_vulnerability_window():
	is_vulnerable = true
	sprite.modulate = Color(0.5, 1, 1)
	power_sound.play()
	vulnerable_timer.start()

func _on_vulnerable_timeout():
	is_vulnerable = false
	sprite.modulate = Color.WHITE
	attack_timer.start()

func hit_boss():
	if hit_cooldown > 0 or defeated:
		return

	hit_cooldown = 0.8
	current_hp -= 25
	hit_sound.play()
	if current_hp <= 0:
		current_hp = 0
		defeat()

func defeat():
	defeated = true
	attack_timer.stop()
	vulnerable_timer.stop()
	hitbox.set_deferred("monitoring", false)
	death_sound.play()

	for projectile in get_tree().get_nodes_in_group("boss_projectile"):
		projectile.queue_free()

	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0, 0.8)
	await tween.finished
	await get_tree().create_timer(0.4, false).timeout
	get_tree().change_scene_to_file("res://scenes/ending_cutscene.tscn")
