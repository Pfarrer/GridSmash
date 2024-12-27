extends GutTest

var creep: Creep

func before_each():
	creep = autofree(Creep.new())
	watch_signals(creep)


func test_emits_destroyed_signal_when_health_reaches_0():
	assert_gt(creep.health, 1)
	creep.handle_affect(1)
	assert_gt(creep.health, 0)
	assert_signal_not_emitted(creep, "destroyed")
	
	creep.handle_affect(creep.health)
	assert_eq(creep.health, 0)
	assert_signal_emitted(creep, "destroyed")


func test_health_cannot_be_less_than_0():
	creep.handle_affect(2 * creep.health)
	assert_eq(creep.health, 0)
	assert_signal_emitted(creep, "destroyed")
