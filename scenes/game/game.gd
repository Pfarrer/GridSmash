extends HBoxContainer

@export var map_scene: PackedScene

var game_controller: GameController

func _ready() -> void:
	game_controller = GameController.new($GameTimer.timeout)
	
	var map = map_scene.instantiate()
	map.game_controller = game_controller
	$MapContainer.add_child(map)
	
	var menu = preload("res://scenes/game/menu/menu.tscn").instantiate()
	menu.game_controller = game_controller
	menu.build_tower.connect(_on_build_tower)
	$MenuContainer.add_child(menu)


func _on_build_tower():
	var build_layer = preload("res://scenes/game/build_layer/build_layer.tscn").instantiate()
	build_layer.game_controller = game_controller
	$MapContainer.add_child(build_layer)
