extends CharacterBody2D

@onready var character_sprite = $character_sprite
@onready var health_bar = $CanvasLayer/health_bar_top
@onready var character_collision = $player_collision
@onready var mana_bar = $CanvasLayer/BoxContainer

const SPEED = 2000.0
const fireball_speed: float = 96
const fireball_timer: float = 0.5
const max_health_scale: float = 3.315
const max_mana_size: float = 129.148
const max_mana: float = 100
const id: String = "player"
const max_health: float = 100

var dash_count: float = 3
var isDashing: bool = false
var counter: float = 0
var counter2: float = 0
var fireball: PackedScene
var isAttacking: bool = false
var current_health: float
var current_mana: float

func _ready() -> void:
	current_mana = 5
	current_health = max_health
	character_sprite.animation_finished.connect(on_animatiofn_finished)
	fireball = preload("res://Scenes/Characters/fireball.tscn")

func _physics_process(delta: float) -> void:
	
	handle_player_input(delta)
	spawn_fireball(delta)
	update_animation()
	move_and_slide()

func handle_player_input(delta: float) -> void:
	
	use_mana(-delta*6)
	#isAttacking = Input.is_key_label_pressed(KEY_Q)
	isAttacking = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	
	counter += delta * 2
	var left = Input.is_key_label_pressed(KEY_A)
	var right = Input.is_key_label_pressed(KEY_D)
	var up = Input.is_key_label_pressed(KEY_W)
	var down = Input.is_key_label_pressed(KEY_S)
	
	var horizontal_direction := Input.get_axis("ui_left", "ui_right")
	var vertical_direction := Input.get_axis("ui_up","ui_down")
	if Input.is_key_label_pressed(KEY_SPACE) and !isDashing:
		if counter > dash_count:
			isDashing = true
			counter = 0
	
	if left: horizontal_direction = -1
	if right: horizontal_direction = 1
	if up: vertical_direction = -1
	if down: vertical_direction = 1
	
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	if vertical_direction:
		velocity.y = vertical_direction * SPEED * delta
	else: 
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	if isDashing:
		if vertical_direction:
			velocity.y = SPEED * delta * 5 * vertical_direction
		elif vertical_direction:
			velocity.y = SPEED * delta * 5 * vertical_direction
		if character_sprite.flip_h:
			velocity.x = SPEED * delta * -5
		else:
			velocity.x = SPEED * delta * 5
	character_collision.disabled = isDashing
	

func spawn_fireball(delta: float) -> void:
	var target_position = get_global_mouse_position()
	var direction = (target_position - position).normalized()
	counter2 += delta
	
	if isAttacking and counter2 > fireball_timer:
		var launch_fireball = fireball.instantiate()
		launch_fireball.target_position = target_position
		get_parent().add_child(launch_fireball)
		launch_fireball.position = position
		launch_fireball.rotate(direction.angle())
		launch_fireball.linear_velocity = (target_position - position).normalized() * fireball_speed
		use_mana(2)
		isAttacking = false
		counter2 = 0

func update_animation():
	
	if isDashing:
		character_sprite.play("Dash")
		return
	
	if velocity.x > 0:
		character_sprite.flip_h = false
		character_sprite.play("Run")
	if velocity.x < 0:
		character_sprite.flip_h = true
		character_sprite.play("Run")
		
	if velocity.y != 0:
		character_sprite.play("Run")
		
	if velocity == Vector2(0,0):
		character_sprite.play("Idle")

func take_damage(damage: float):
	current_health -= damage
	current_health = clamp(current_health, 0, max_health)
	var health_percent = current_health / max_health
	health_bar.scale.x = health_percent * max_health_scale
	health_bar.scale.x = clamp(health_bar.scale.x, 0, max_health_scale)

func use_mana(amount: float):
	current_mana -= amount
	current_mana = clamp(current_mana, 0, max_mana)
	var mana_percent = current_mana / max_mana
	mana_bar.size.x = mana_percent * max_mana_size
	mana_bar.size.x = clamp(mana_bar.size.x, 0, max_mana_size)


func on_animatiofn_finished():
	isDashing = false
