extends VBoxContainer

func _on_start_button_pressed() -> void:
	var game_scene = preload("res://scenes/game/game.tscn").instantiate()
	game_scene.map_scene = _get_selected_map()
	game_scene.game_controller = GameController.new()
	
	for i in range(0, $FellowPlayerSlider.value):
		game_scene.game_controller.add_fellow_player(FellowPlayer.new())
	
	var current_scene = get_tree().root.get_child(0)
	get_tree().root.add_child(game_scene)
	get_tree().root.remove_child(current_scene)
	current_scene.queue_free()


func _get_selected_map() -> PackedScene:
	var map_id = $MapControl.selected
	if map_id == 0:
		return preload("res://scenes/maps/basic_map/basic_map.tscn")
	else:
		return preload("res://scenes/maps/spiral_map/spiral_map.tscn")
