extends GutTest

var map_params = [
	preload("res://scenes/maps/basic_map/basic_map.tscn"),
	preload("res://scenes/maps/spiral_map/spiral_map.tscn"),
]

func _before_each(map_scene: PackedScene) -> Node2D:
	var map = partial_double(map_scene).instantiate()
	map.game_controller = partial_double(GameController).new()
	add_child_autofree(map)
	return map


func test_passing_creeps_are_detected(map_scene = use_parameters(map_params)):
	var map = _before_each(map_scene)
	
	var creep = map.game_controller.receive_creep(StrongCreep)
	creep.speed *= 100
	await wait_seconds(0.5)

	assert_called(map.game_controller, "creep_passed", [creep])
