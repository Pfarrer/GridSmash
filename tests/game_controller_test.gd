extends GutTest

signal game_clock()
var game_controller: GameController

func before_each():
	game_controller = autofree(GameController.new(game_clock))
	watch_signals(game_controller)


func test_creep_is_removed_after_destroyed():
	var creep = game_controller.send_creep()
	assert_eq(game_controller.creeps.size(), 1)

	creep.handle_affect(creep.health)
	
	assert_eq(game_controller.creeps.size(), 0)
