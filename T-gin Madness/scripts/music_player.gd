extends AudioStreamPlayer


const MUSIC = preload("res://assets/music/time_for_adventure.mp3")


var music_volume = 0.6


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	stream = MUSIC
	_apply_volume()
	play()



func set_music_volume(value):
	music_volume = clamp(value, 0.0, 1.0)
	_apply_volume()




func _apply_volume():
	if music_volume <= 0.001:
		volume_db = -80.0
	else:
		volume_db = linear_to_db(music_volume)
