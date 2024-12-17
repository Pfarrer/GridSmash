extends Control


var game_scene = preload("res://scenes/game/game.tscn")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
