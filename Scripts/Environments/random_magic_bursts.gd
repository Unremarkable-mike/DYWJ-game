extends Node2D

var lightning_burst: PackedScene
var lightning_strike: PackedScene
var max_distance_x = 127
var max_distance_y = 70
var min_distance = 10
var intensity
var spawn_cooldown = 100
var spawn_timer = 0
var player

func _ready() -> void:
	lightning_burst = preload("res://Scenes/Enviroment/lightning_burst.tscn")
	lightning_strike = preload("res://Scenes/Enviroment/lightning_strike.tscn")


func _process(delta: float) -> void:
	if intensity == null or player == null:
		return
	
	match intensity:
		1.0:
			spawn_cooldown = 3
		2.0: 
			spawn_cooldown = 2
		3.0: 
			spawn_cooldown = 1
		4.0:
			spawn_cooldown = 0.5
	summon_magic(delta)
	

func summon_magic(delta: float):
	spawn_timer += delta
	var distance_x = randf_range(player.position.x - max_distance_x, player.position.x + max_distance_x )
	var distance_y = randf_range(player.position.y - max_distance_y, player.position.y + max_distance_y)
	
	if spawn_timer > spawn_cooldown:

		var magic_blast1 = lightning_burst.instantiate()
		get_parent().add_child(magic_blast1)
		spawn_timer = 0
		magic_blast1.position.x = distance_x
		magic_blast1.position.y = distance_y
		
		if intensity > 1:
			distance_x = randf_range(player.position.x - max_distance_x, player.position.x + max_distance_x )
			distance_y = randf_range(player.position.y - max_distance_y, player.position.y + max_distance_y)
			var lightning_stike = lightning_strike.instantiate()
			get_parent().add_child(lightning_stike)
			lightning_stike.position.x = distance_x
			lightning_stike.position.y = distance_y
		
	
