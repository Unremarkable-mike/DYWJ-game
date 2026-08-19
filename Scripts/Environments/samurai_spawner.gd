extends Node2D

var samurai: PackedScene
var spawnTimer = 4
var counter = 0
var maxSpawns = 10
var samurai_count = 0
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	samurai = preload("res://Scenes/Characters/samurai.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += delta
	
	if player == null:
		return
	if counter > spawnTimer:
		var new_samurai = samurai.instantiate()
		new_samurai.player = player
		new_samurai.position = position
		get_parent().add_child(new_samurai)
		samurai_count += 1
		counter = 0
