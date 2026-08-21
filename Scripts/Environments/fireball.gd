extends RigidBody2D

@onready var fireball = $fireball_area
@onready var fireball_sprite = $fireball_area/fireball_animation
@onready var explosion = $explosion_area/explosion_animation
@onready var explosion_area = $explosion_area
@onready var environemt_detection = $environment_detection

var target_position: Vector2
var fireball_despawn_counter = 4
var counter = 0
var stopped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 1
	environemt_detection.body_entered.connect(went_behind_an_object)
	environemt_detection.body_exited.connect(moved_away_from_object)
	
	explosion.set_frame_and_progress(0,0)
	explosion.visible = false
	explosion.animation_finished.connect(explotion_complete)
	fireball.body_entered.connect(fireball_collided)
	fireball_sprite.animation_looped.connect(creation_complete)
	gravity_scale = 0
	fireball_sprite.play("creation")

func _physics_process(delta: float) -> void:
	counter += delta*2
	
	if explosion.frame == 9:
		for body in explosion_area.get_overlapping_bodies():
			if body is CharacterBody2D and body.id == "enemy":
				body.take_damage(20,"magic")
		explosion.frame = 10
	
	if counter > fireball_despawn_counter:
		stopped = true
	
	if stopped:
		linear_velocity = Vector2(0,0)
		rotation = 0
		fireball_sprite.visible = false
		explosion.visible = true
		explosion.play("default")
		

func creation_complete():
	fireball_sprite.play("in_motion")

func fireball_collided(body: Node2D):
	if body is CharacterBody2D:
		if body.id == "enemy":
			stopped = true
			body.take_damage(10,"magic")
	elif body is not CharacterBody2D:
		stopped = true

func explotion_complete():
			
	queue_free()

func went_behind_an_object(body: Node2D):
	if body is TileMapLayer:
		z_index = 0
	
func moved_away_from_object(body: Node2D):
	if body is TileMapLayer:
		z_index = 1
