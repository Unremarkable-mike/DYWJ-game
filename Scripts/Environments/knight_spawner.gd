extends Node2D

var knight: PackedScene
var spawnTimer = 4
var counter = 0
var maxSpawns = 10
var knight_count = 0
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	knight = preload("res://Scenes/Characters/knight.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += delta
	
	if player == null:
		return
	if counter > spawnTimer:
		var new_knight = knight.instantiate()
		new_knight.player = player
		new_knight.position = position
		get_parent().add_child(new_knight)
		counter = 0
