extends Control

var slides = [
	["res://assets/cutscenes/ending_01.png", "Angela: Great job, guys! You defeated the angel!"],
	["res://assets/cutscenes/ending_02.png", "Angela: I guess you want something in exchange..."],
	["res://assets/cutscenes/ending_02.png", "T.gin: Oh no! Not again!"],
	["res://assets/cutscenes/ending_03.png", ""]

]





var page = 0

@onready var picture = $Slide
@onready var caption = $CaptionPanel/Label
@onready var panel = $CaptionPanel
@onready var number = $SlideNumber
@onready var skip = $Skip




func _ready():
	skip.pressed.connect(_go_to_menu)
	_show_page()


func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		_next()




func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_go_to_menu()
	elif event.is_action_pressed("ui_accept"):
		_next()




func _next():
	if page < slides.size() - 1:
		page += 1
		_show_page()
	else:
		_go_to_menu()


func _show_page():
	picture.texture = load(slides[page][0])
	caption.text = slides[page][1]
	panel.visible = caption.text != ""
	number.text = str(page + 1) + " / " + str(slides.size())





func _go_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
