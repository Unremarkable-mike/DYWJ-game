extends Node2D

var level: PackedScene
var menu: PackedScene

var lvl: bool = false
var start_menu: bool = true
var scene_index: int = 1

func _ready() -> void:
	menu = preload("res://Scenes/UI/start_menu.tscn")
	level = preload("res://Scenes/Levels/prototype_level.tscn")

func _process(delta: float) -> void:
	if get_child_count() <= 1:
		transition_scenes()
	manage_scenes()

func transition_scenes(): 
	if start_menu:
		add_child(menu.instantiate())
	elif lvl:
		add_child(level.instantiate())
		
func manage_scenes():
	if start_menu:
		var current_scene = get_child(scene_index)
		if current_scene.play:
			lvl = true
			start_menu = false
			remove_child(current_scene)
		elif current_scene.exit:
			get_tree().quit()
	elif lvl:
		pass
#		var current_scene = get_child(scene_index)
		
		
	
