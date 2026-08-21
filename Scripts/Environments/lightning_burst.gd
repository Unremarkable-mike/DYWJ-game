extends Area2D

@onready var sprite = $lightning_animation

var animation = ["burst_1","burst_2","burst_3"]

func _ready() -> void:
	sprite.animation_looped.connect(cycle_complete)
	var burst = randi_range(0,2)
	sprite.play(animation[burst])

func _process(delta: float) -> void:
	if sprite.frame == 4:
		for body in get_overlapping_bodies():
			if body is CharacterBody2D:
				body.take_damage(20,"magic")

func cycle_complete():
	queue_free()
