extends Control

var game_scene = preload("res://scenes/game/game.tscn")

func _on_start_button_pressed() -> void:
	var game = game_scene.instantiate()
	game.map_scene = _get_selected_map()
	game.game_controller = GameController.new(game.find_child("GameTimer").timeout)
	
	var current_scene = get_tree().root.get_child(0)
	get_tree().root.add_child(game)
	get_tree().root.remove_child(current_scene)
	current_scene.queue_free()


func _get_selected_map() -> PackedScene:
	var map_id = $CenterContainer/VBoxContainer/HBoxContainer/SinglePlayerContainer/MapControl.selected
	if map_id == 0:
		return preload("res://scenes/maps/basic_map/basic_map.tscn")
	else:
		return preload("res://scenes/maps/spiral_map/spiral_map.tscn")
