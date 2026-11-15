extends CanvasLayer

@export var show_coins = true
@export var show_boss = false

@onready var coin_label = $Root/CoinLabel
@onready var player_label = $Root/PlayerHealth/Label
@onready var player_bar = $Root/PlayerHealth/Bar
@onready var boss_box = $Root/BossHealth
@onready var boss_label = $Root/BossHealth/Label
@onready var boss_bar = $Root/BossHealth/Bar




var player = null
var boss = null




func _ready():
	coin_label.visible = show_coins
	boss_box.visible = show_boss
	player = get_node_or_null("../Player")
	if show_boss:
		boss = get_node_or_null("../Boss")
	_update_hud()

func _process(_delta):
	_update_hud()

func _update_hud():
	if show_coins:
		coin_label.text = "COINS: %d" % GameState.coins

	if player and is_instance_valid(player):
		var health = int(player.health)
		var max_health = int(player.max_health)
		player_bar.max_value = max_health
		player_bar.value = health
		player_label.text = "HP %d/%d" % [health, max_health]

	if show_boss:
		var boss_alive = boss != null and is_instance_valid(boss) and int(boss.current_hp) > 0
		boss_box.visible = boss_alive
		if boss_alive:
			var boss_hp = int(boss.current_hp)
			var boss_max_hp = int(boss.max_hp)
			boss_bar.max_value = boss_max_hp
			boss_bar.value = boss_hp
			boss_label.text = "BOSS %d/%d" % [boss_hp, boss_max_hp]
