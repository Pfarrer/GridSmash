extends HBoxContainer

@export var map_scene: PackedScene

var game_controller: GameController

func _ready() -> void:
	assert(game_controller)

	for fellow_player in game_controller.fellow_players:
		var fellow_player_map = map_scene.instantiate()
		fellow_player_map.game_controller = fellow_player
		$FellowPlayerContainer.add_child(fellow_player_map)
	if game_controller.fellow_players.is_empty():
		$FellowPlayerContainer.hide()

	var map = map_scene.instantiate()
	map.game_controller = game_controller
	$MapContainer.add_child(map)

	var connection_layer = preload("res://scenes/game/connection_layer/ConnectionLayer.tscn").instantiate()
	connection_layer.game_controller = game_controller
	$MapContainer.add_child(connection_layer)

	var menu = preload("res://scenes/game/menu/menu.tscn").instantiate()
	menu.game_controller = game_controller
	menu.build_structure.connect(on_build_structure)
	$MenuContainer.add_child(menu)


func on_build_structure(type: Variant):
	var build_layer = preload("res://scenes/game/build_layer/build_layer.tscn").instantiate()
	build_layer.game_controller = game_controller
	build_layer.structure_type = type
	$MapContainer.add_child(build_layer)


func _process(delta: float) -> void:
	game_controller.energy_grids.update_energy_flows(delta)


func _on_game_timer_timeout() -> void:
	game_controller.on_clock_tick()
