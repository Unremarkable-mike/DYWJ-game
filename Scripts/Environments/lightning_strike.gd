extends Area2D

@onready var sprite = $lightning_animation
@onready var effect_area = $area_of_effect

func _ready() -> void:
	sprite.animation_looped.connect(cycle_complete)

func _process(delta: float) -> void:
	if sprite.frame == 4:
		for body in get_overlapping_bodies():
			if body is CharacterBody2D:
				body.take_damage(20,"magic")

func cycle_complete():
	queue_free()
