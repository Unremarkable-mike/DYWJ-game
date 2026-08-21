extends CharacterBody2D

@onready var sprite = $knight_sprite
@onready var attack_area = $area_of_attack
@onready var health_bar = $health_bar
@onready var collision_area = $"knight_collition area"
@onready var environemt_detection = $environment_detection

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
const id: String = "enemy"
const speed: float = 1000
const max_health: float = 100
const max_scale: float = 0.31
const damage: float = 3

var player: CharacterBody2D
var inRangeOfAttack: bool = false
var current_health: float = 100
var dead: bool = false
var loop_counter: int = 0
var healthbar_fade: float = 2
var isMoving: bool = true
var last_position: Vector2
var rest_cooldown = 0.5
var rest_counter = 0

func _ready() -> void:
	last_position = Vector2(0,0)
	z_index = 1
	environemt_detection.body_entered.connect(went_behind_an_object)
	environemt_detection.body_exited.connect(moved_away_from_object)
	
	sprite.animation_looped.connect(death_animation_looped)
	attack_area.body_entered.connect(player_entered)
	attack_area.body_exited.connect(player_exited)

func _physics_process(delta: float) -> void:
	if player == null:
		sprite.play("Idle")
		return
	rest_counter += delta
	var target_position = player.position
	
	if dead:
		collision_area.disabled = true
		sprite.play("Death")
		return
	var x = round(last_position.x) == round(position.x)
	var y = round(last_position.y) == round(position.y)
	
	var timer_complete = rest_counter > rest_cooldown
	
	if x and y and timer_complete:
		isMoving = false
	elif timer_complete: isMoving = true
	
	if timer_complete:
		last_position = position
		rest_counter = 0
	
	healthbar_fade -= delta
	if healthbar_fade <= 0:
		health_bar.visible = false
		healthbar_fade = 0
	else:
		health_bar.visible = true
	
	if !inRangeOfAttack:
		var direction_x = -1
		var direction_y = -1
		var distance_x = position.x - target_position.x
		var distance_y = position.y - target_position.y
		
		if distance_x < 0:
			distance_x *= -1
			direction_x = 1
		if distance_y < 0:
			distance_y *= -1
			direction_y = 1
		
		var sum = distance_x + distance_y
		var ratio_x = distance_x / sum
		var ratio_y = distance_y / sum 
		velocity.x = speed * delta * ratio_x * direction_x
		velocity.y = speed * delta * ratio_y * direction_y
	else:
		if sprite.frame == 4:
			for body in attack_area.get_overlapping_bodies():
				if body is CharacterBody2D and body.id == "player":
					body.take_damage(damage,"physical")
		velocity.x = 0
		velocity.y = 0
	update_animation()
	move_and_slide()


func update_animation():
	
	if inRangeOfAttack:
		sprite.play("Attack3")
		return
	
	if velocity.x > 0 and isMoving:
		sprite.flip_h = false
		sprite.play("Run")
	elif velocity.x < 0 and isMoving:
		sprite.flip_h = true
		sprite.play("Run")
	else:
		sprite.play("Idle")

func take_damage(damage: float, damage_type: String):
	health_bar.visible = true
	current_health -= damage
	current_health = clamp(current_health, 0, max_health)
	
	var percentage = current_health / max_health
	health_bar.scale.x = percentage * max_scale
	health_bar.scale.x = clamp(health_bar.scale.x, 0, max_scale)
	if current_health == 0:
		dead = true
	healthbar_fade = 3

func player_entered(body:Node2D):
	if body is CharacterBody2D and body.id == "player":
		inRangeOfAttack = true
		
func player_exited(body:Node2D):
	if body is CharacterBody2D and body.id == "player":
		inRangeOfAttack = false

func death_animation_looped():
	if sprite.animation == "Death":
		player.update_kills()
		queue_free()

func went_behind_an_object(body: Node2D):
	if body is TileMapLayer:
		z_index = 0
	
func moved_away_from_object(body: Node2D):
	if body is TileMapLayer:
		z_index = 1
