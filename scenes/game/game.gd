extends Node2D

@export var map_scene: PackedScene

var game_controller: GameController

func _ready() -> void:
	assert(game_controller)
	
	var viewport_size = _resize_window()

	for fellow_player_controller in game_controller.fellow_players:
		var layer = CanvasLayer.new()
		add_child(layer)
		_create_map_for_game_controller(fellow_player_controller, layer, Vector2(0, 0))
		
	_create_map_for_game_controller(game_controller, $MapLayer, Vector2(viewport_size.x - 960, 0))

	var menu = preload("res://scenes/game/menu/menu.tscn").instantiate()
	menu.game_controller = game_controller
	menu.build_structure.connect(on_build_structure)
	menu.position = Vector2(viewport_size.x - 300, 0)
	add_child(menu)


func on_build_structure(type: Variant):
	var build_layer = preload("res://scenes/game/build_layer/build_layer.tscn").instantiate()
	build_layer.game_controller = game_controller
	build_layer.structure_type = type
	$MapLayer.add_child(build_layer)


func _process(delta: float) -> void:
	game_controller.energy_grids.update_energy_flows(delta)


func _on_game_timer_timeout() -> void:
	game_controller.on_clock_tick()


func _resize_window() -> Vector2i:
	var fellow_payer_width = 0
	if game_controller.fellow_players.size() == 2:
		fellow_payer_width = 330
	elif game_controller.fellow_players.size() == 1:
		fellow_payer_width = 660
	get_window().size = Vector2i(960 + fellow_payer_width, 660)
	return get_window().size


func _create_map_for_game_controller(controller: GameController, layer: CanvasLayer, target_position: Vector2):
	var map = map_scene.instantiate()
	map.game_controller = controller
	map.position = target_position
	layer.add_child(map)

	var connection_layer = preload("res://scenes/game/connection_layer/ConnectionLayer.tscn").instantiate()
	connection_layer.game_controller = controller
	connection_layer.position = target_position
	layer.add_child(connection_layer)
