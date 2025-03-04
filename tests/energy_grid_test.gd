extends GutTest

var affecting_structure1 = GridNodeStructure.new(Vector2.ZERO)
var affecting_structure2 = GridNodeStructure.new(Vector2.ZERO)

var grid_node_structure1 = GridNodeStructure.new(Vector2.ZERO)
var grid_node_structure2 = GridNodeStructure.new(Vector2.ZERO)
var grid_node_structure3 = GridNodeStructure.new(Vector2.ZERO)

var GN_ENERGY_GENERATION = grid_node_structure1.energy_generation

var energy_grid: EnergyGrid

func before_each():
	energy_grid = autofree(EnergyGrid.new())
	watch_signals(energy_grid)
	watch_signals(energy_grid.energy_flow)


func test_empty_energy_grid():
	assert_eq(energy_grid.is_empty(), true)
	assert_eq(energy_grid.energy_flow.energy_generation_max(), 0.0)
	assert_eq(energy_grid.energy_flow.energy_consumption_max(), 0.0)
	assert_eq(energy_grid.energy_flow.energy_capacity_max(), 0.0)


func test_grid_node_only_energy_grid():
	var connection1 = GridConnection.new(grid_node_structure1, grid_node_structure2)
	energy_grid.add_grid_connection(connection1)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_flow.energy_generation_max(), 2 * GN_ENERGY_GENERATION)
	assert_signal_emitted_with_parameters(energy_grid.energy_flow, "energy_generation_max_changed", [2 * GN_ENERGY_GENERATION])
	
	var connection2 = GridConnection.new(grid_node_structure1, grid_node_structure3)
	energy_grid.add_grid_connection(connection2)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_flow.energy_generation_max(), 3 * GN_ENERGY_GENERATION)
	assert_signal_emitted_with_parameters(energy_grid.energy_flow, "energy_generation_max_changed", [3 * GN_ENERGY_GENERATION])
	
	var connection3 = GridConnection.new(grid_node_structure3, grid_node_structure2)
	energy_grid.add_grid_connection(connection3)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_flow.energy_generation_max(), 3 * GN_ENERGY_GENERATION)
	assert_signal_emit_count(energy_grid.energy_flow, "energy_generation_max_changed", 2.0)

	energy_grid.remove_grid_connection(connection2)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_flow.energy_generation_max(), 3 * GN_ENERGY_GENERATION)
	assert_signal_emit_count(energy_grid.energy_flow, "energy_generation_max_changed", 2.0)
	
	energy_grid.remove_grid_connection(connection3)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_flow.energy_generation_max(), 2 * GN_ENERGY_GENERATION)
	assert_signal_emitted_with_parameters(energy_grid.energy_flow, "energy_generation_max_changed", [2 * GN_ENERGY_GENERATION])
	
	energy_grid.remove_grid_connection(connection1)
	assert_eq(energy_grid.is_empty(), true)
	assert_eq(energy_grid.energy_flow.energy_generation_max(), 0.0)
	assert_signal_emitted_with_parameters(energy_grid.energy_flow, "energy_generation_max_changed", [0.0])
	
	assert_signal_emit_count(energy_grid.energy_flow, "energy_generation_max_changed", 4.0)


func test_merge_with_grid():
	var other_grid = autofree(EnergyGrid.new())
	other_grid.add_grid_connection(GridConnection.new(grid_node_structure1, grid_node_structure2))
	other_grid.add_grid_connection(GridConnection.new(grid_node_structure2, grid_node_structure3))
	other_grid.add_grid_connection(GridConnection.new(grid_node_structure1, grid_node_structure3))
	
	energy_grid.add_grid_connection(GridConnection.new(affecting_structure1, affecting_structure2))

	var expected_generation = energy_grid.energy_flow.energy_generation_max() + other_grid.energy_flow.energy_generation_max()
	var expected_consumption = energy_grid.energy_flow.energy_consumption_max() + other_grid.energy_flow.energy_consumption_max() 
	var expected_capacity = energy_grid.energy_flow.energy_capacity_max() + other_grid.energy_flow.energy_capacity_max() 
	energy_grid.merge_with_grid(other_grid)

	assert_eq(energy_grid.energy_flow.energy_generation_max(), expected_generation)
	assert_eq(energy_grid.energy_flow.energy_consumption_max(), expected_consumption)
	assert_eq(energy_grid.energy_flow.energy_capacity_max(), expected_capacity)
	assert_eq(energy_grid._connections.size(), 4)


func test_energy_flow_two_generators_one_consumer_no_battery():
	var expected_generation1 = 1.
	var expected_generation2 = expected_generation1
	var expected_total_generation = expected_generation1 + expected_generation2
	var expected_consumer_capacity = 5

	grid_node_structure1.energy_generation = expected_generation1
	grid_node_structure1.energy_generation = expected_generation2
	var connection1 = GridConnection.new(grid_node_structure1, grid_node_structure2)
	energy_grid.add_grid_connection(connection1)

	var consumer_structure = AffectingStructure.new(Vector2.ZERO, 0, 0, 0, 0, expected_consumer_capacity)
	var connection2 = GridConnection.new(grid_node_structure1, consumer_structure)
	energy_grid.add_grid_connection(connection2)
	
	energy_grid.energy_flow.update_flow(0.1)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_total_generation, .001)
	assert_almost_eq(consumer_structure.energy_charge, 0.1 * expected_total_generation, .001)

	energy_grid.energy_flow.update_flow(0.1)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_total_generation, .001)
	assert_almost_eq(consumer_structure.energy_charge, 0.2 * expected_total_generation, .001)

	energy_grid.energy_flow.update_flow(0.1)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_total_generation, .001)
	assert_almost_eq(consumer_structure.energy_charge, 0.3 * expected_total_generation, .001)

	energy_grid.energy_flow.update_flow(0.7)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_total_generation, .001)
	assert_almost_eq(consumer_structure.energy_charge, 1.0 * expected_total_generation, .001)

	energy_grid.energy_flow.update_flow(5.0)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, 3. / 5., .001) # 3 energy left to charge in 5 seconds, makes an avg. flow of 0.6
	assert_eq(consumer_structure.energy_charge, consumer_structure.energy_capacity)


func test_energy_flow_one_generators_two_consumers_charge_rate_equals_capcity():
	var expected_generation = 1.
	var expected_consumer_capcon1 = 1. # capcon = capacity & consumption
	var expected_consumer_capcon2 = 3. # capcon = capacity & consumption

	grid_node_structure1.energy_generation = expected_generation
	var consumer_structure1 = AffectingStructure.new(Vector2.ZERO, 0, 0, 0, 0, expected_consumer_capcon1)
	var connection1 = GridConnection.new(grid_node_structure1, consumer_structure1)
	energy_grid.add_grid_connection(connection1)

	var consumer_structure2 = AffectingStructure.new(Vector2.ZERO, 0, 0, 0, 0, expected_consumer_capcon2)
	var connection2 = GridConnection.new(grid_node_structure1, consumer_structure2)
	energy_grid.add_grid_connection(connection2)

	energy_grid.energy_flow.update_flow(1.)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_generation, .001)
	assert_almost_eq(consumer_structure1.energy_charge, .25, .001)
	assert_almost_eq(consumer_structure2.energy_charge, .75, .001)

	energy_grid.energy_flow.update_flow(3.)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_generation, .001)
	assert_almost_eq(consumer_structure1.energy_charge, expected_consumer_capcon1, .001)
	assert_almost_eq(consumer_structure2.energy_charge, expected_consumer_capcon2, .001)

	energy_grid.energy_flow.update_flow(.1)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, 0., .001)


func test_energy_flow_one_generators_two_consumers_charge_rate_different_to_capcity():
	var expected_generation = 1.
	var expected_consumer_capacity1 = 1.
	var expected_consumer_consumption1 = 2.
	var expected_consumer_capacity2 = 3.
	var expected_consumer_consumption2 = 2.

	grid_node_structure1.energy_generation = expected_generation
	var consumer_structure1 = AffectingStructure.new(Vector2.ZERO, 0, 0, 0, 0, expected_consumer_capacity1)
	consumer_structure1.energy_consumption = expected_consumer_consumption1
	var connection1 = GridConnection.new(grid_node_structure1, consumer_structure1)
	energy_grid.add_grid_connection(connection1)

	var consumer_structure2 = AffectingStructure.new(Vector2.ZERO, 0, 0, 0, 0, expected_consumer_capacity2)
	consumer_structure2.energy_consumption = expected_consumer_consumption2
	var connection2 = GridConnection.new(grid_node_structure1, consumer_structure2)
	energy_grid.add_grid_connection(connection2)

	energy_grid.energy_flow.update_flow(1.)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_generation, .001)
	assert_almost_eq(consumer_structure1.energy_charge, .5, .001)
	assert_almost_eq(consumer_structure2.energy_charge, .5, .001)

	energy_grid.energy_flow.update_flow(2.)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_generation, .001)
	assert_almost_eq(consumer_structure1.energy_charge, expected_consumer_capacity1, .001)
	assert_almost_eq(consumer_structure2.energy_charge, 2., .001)

	energy_grid.energy_flow.update_flow(2.)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, .5, .001)
	assert_almost_eq(consumer_structure2.energy_charge, expected_consumer_capacity2, .001)


func test_energy_flow_one_generator_one_consumer_one_battery():
	var expected_generation = 1.
	var expected_consumer_capcon = 2. # capcon = capacity & consumption
	var expected_battery_capcon = 3.
	
	grid_node_structure1.energy_generation = expected_generation
	var consumer_structure = AffectingStructure.new(Vector2.ZERO, 0, 0, 0, 0, expected_consumer_capcon)
	var connection1 = GridConnection.new(grid_node_structure1, consumer_structure)
	energy_grid.add_grid_connection(connection1)

	var battery_structure = BatteryStructure.new(Vector2.ZERO)
	battery_structure.energy_capacity = expected_battery_capcon
	battery_structure.energy_consumption = expected_battery_capcon
	var connection2 = GridConnection.new(grid_node_structure1, battery_structure)
	energy_grid.add_grid_connection(connection2)

	energy_grid.energy_flow.update_flow(1.)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_generation, .001)
	assert_almost_eq(consumer_structure.energy_charge, 1., .001)
	assert_almost_eq(battery_structure.energy_charge, 0., .001)

	energy_grid.energy_flow.update_flow(2.)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_generation, .001)
	assert_almost_eq(consumer_structure.energy_charge, expected_consumer_capcon, .001)
	assert_almost_eq(battery_structure.energy_charge, 1., .001)

	# Fully charge the battery
	energy_grid.energy_flow.update_flow(2.)
	assert_almost_eq(battery_structure.energy_charge, expected_battery_capcon, .001)

	# Decharge consumer such that it needs recharge from generator and battery
	consumer_structure.energy_charge = 0.

	energy_grid.energy_flow.update_flow(1.)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_consumer_capcon, .001)
	assert_almost_eq(consumer_structure.energy_charge, expected_consumer_capcon, .001)
	assert_almost_eq(battery_structure.energy_charge, 2., .001)

	energy_grid.energy_flow.update_flow(.5)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_generation, .001)
	assert_almost_eq(battery_structure.energy_charge, 2.5, .001)

	energy_grid.energy_flow.update_flow(.5)
	assert_almost_eq(energy_grid.energy_flow.current_energy_flow, expected_generation, .001)
	assert_almost_eq(battery_structure.energy_charge, expected_battery_capcon, .001)
