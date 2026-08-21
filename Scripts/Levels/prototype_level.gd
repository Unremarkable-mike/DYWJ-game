extends Node2D

@onready var knight = $Knight
@onready var samurai = $Samurai
@onready var player = $Player_character
@onready var knight_spawner = $knight_spawner
@onready var samurai_spawner = $samurai_spawner
@onready var magic = $random_magic_bursts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	samurai_spawner.player = player
	knight_spawner.player = player
	knight.player = player
	samurai.player = player
	magic.player = player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	magic.intensity = player.magic_stage
	magic.player = player
	
