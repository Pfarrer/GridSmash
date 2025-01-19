extends GutTest

signal timer()

var map_scene

func before_each():
	map_scene = partial_double(preload("res://scenes/maps/basic_map/basic_map.tscn")).instantiate()
	map_scene.game_controller = partial_double(GameController).new(timer)
	add_child_autofree(map_scene)


func test_passing_creeps_are_detected():
	var creep = map_scene.game_controller.send_creep()
	creep.speed *= 100
	await wait_seconds(0.5)

	assert_called(map_scene.game_controller, "creep_passed", [creep])
