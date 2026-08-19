extends CharacterBody2D

@onready var character_sprite = $character_sprite
@onready var health_bar = $CanvasLayer/health_bar_top

const SPEED = 2000.0
var dash_count = 3
var isDashing = false
var counter = 0
var counter2 = 0
var fireball: PackedScene
var fireball_speed = 96
var fireball_timer = 0.5
var isAttacking = false
var id = "player"
var max_health = 100
var current_health
var max_scale = 3.315


func _ready() -> void:
	current_health = max_health
	character_sprite.animation_finished.connect(on_animatiofn_finished)
	fireball = preload("res://Scenes/Characters/fireball.tscn")

func _physics_process(delta: float) -> void:
	
	handle_player_input(delta)
	spawn_fireball(delta)
	update_animation()
	move_and_slide()

func handle_player_input(delta: float) -> void:
	
	isAttacking = Input.is_key_label_pressed(KEY_Q)
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
	health_bar.scale.x = health_percent * max_scale
	health_bar.scale.x = clamp(health_bar.scale.x, 0, max_scale)

func on_animatiofn_finished():
	isDashing = false
