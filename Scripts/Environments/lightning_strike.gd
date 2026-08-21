extends Area2D

@onready var sprite = $lightning_animation

func _ready() -> void:
	sprite.animation_looped.connect(cycle_complete)

func cycle_complete():
	queue_free()
