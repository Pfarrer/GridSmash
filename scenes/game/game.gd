extends HBoxContainer


@export var map_scene: PackedScene


var game_controller: GameController


func _ready() -> void:
	game_controller = GameController.new($GameTimer.timeout)
	
	var map = map_scene.instantiate()
	$MapContainer.add_child(map)
	
	var menu = preload("res://scenes/game/menu/menu.tscn").instantiate()
	menu.game_controller = game_controller
	$MenuContainer.add_child(menu)
