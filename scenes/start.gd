extends Control

var game_scene = preload("res://scenes/game/game.tscn")

func _on_start_button_pressed() -> void:
	var game = game_scene.instantiate()
	var game_controller = GameController.new(game.find_child("GameTimer").timeout)
	game_controller.enable_seed_game_state = $CenterContainer/VBoxContainer/DevStateControl.button_pressed
	game.game_controller = game_controller
	
	var current_scene = get_tree().root.get_child(0)
	get_tree().root.add_child(game)
	get_tree().root.remove_child(current_scene)
	current_scene.queue_free()
