extends GutTest

var game_controller: GameController

func before_each():
	game_controller = autofree(GameController.new())
	watch_signals(game_controller)


func test_creep_is_removed_after_destroyed():
	var creep = game_controller.receive_creep(StrongCreep)
	assert_eq(game_controller.creeps.size(), 1)

	creep.handle_affect(creep.health)
	
	assert_eq(game_controller.creeps.size(), 0)
