extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0
const INVULNERABILITY_TIME = 0.75

@export var max_health = 100
var health = 100
var is_dead = false
var is_invulnerable = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $Sprite2D
@onready var jump_sound = $JumpSound
@onready var hurt_sound = $HurtSound
@onready var coin_sound = $CoinSound

func _ready():
	health = max_health

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta




	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()


	var direction = Input.get_axis("move_left", "move_right")


	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true


	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()


func take_damage(amount):
	if is_dead or is_invulnerable:
		return


	health -= amount
	if health < 0:
		health = 0


	if health <= 0:
		die()
		return


	hurt_sound.play()
	is_invulnerable = true
	sprite.modulate = Color(1.0, 0.35, 0.35)
	await get_tree().create_timer(0.15, false).timeout
	sprite.modulate = Color(1.0, 1.0, 1.0, 0.45)
	await get_tree().create_timer(INVULNERABILITY_TIME - 0.15, false).timeout
	sprite.modulate = Color.WHITE
	is_invulnerable = false

func play_coin():
	coin_sound.play()

func die():
	if is_dead:
		return

	is_dead = true
	health = 0
	sprite.modulate = Color(1.0, 0.3, 0.3)
	velocity = Vector2.ZERO
	Engine.time_scale = 0.5
	await get_tree().create_timer(0.5, false).timeout
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
