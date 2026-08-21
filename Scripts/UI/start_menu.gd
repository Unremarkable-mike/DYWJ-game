extends Control

@onready var play_button = $play_button
@onready var exit_button = $exit_button
@onready var controls_button = $controls_button

var play: bool = false
var exit: bool = false
var controls: bool = false

func _ready() -> void:
	play_button.pressed.connect(play_pressed)
	exit_button.pressed.connect(exit_pressed)
	controls_button.pressed.connect(controls_pressed)

func exit_pressed():
	exit = true
	
func play_pressed():
	play = true
	
func controls_pressed():
	controls = true
