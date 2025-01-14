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


func test_empty_energy_grid():
	assert_eq(energy_grid.is_empty(), true)
	assert_eq(energy_grid.energy_generation(), 0)
	assert_eq(energy_grid.energy_consumption(), 0)
	assert_eq(energy_grid.energy_stored(), 0)


func test_grid_node_only_energy_grid():
	var connection1 = GridConnection.new(grid_node_structure1, grid_node_structure2)
	energy_grid.add_grid_connection(connection1)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_generation(), 2 * GN_ENERGY_GENERATION)
	assert_signal_emitted_with_parameters(energy_grid, "energy_generation_changed", [2 * GN_ENERGY_GENERATION])
	
	var connection2 = GridConnection.new(grid_node_structure1, grid_node_structure3)
	energy_grid.add_grid_connection(connection2)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_generation(), 3 * GN_ENERGY_GENERATION)
	assert_signal_emitted_with_parameters(energy_grid, "energy_generation_changed", [3 * GN_ENERGY_GENERATION])
	
	var connection3 = GridConnection.new(grid_node_structure3, grid_node_structure2)
	energy_grid.add_grid_connection(connection3)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_generation(), 3 * GN_ENERGY_GENERATION)
	assert_signal_emit_count(energy_grid, "energy_generation_changed", 2)

	energy_grid.remove_grid_connection(connection2)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_generation(), 3 * GN_ENERGY_GENERATION)
	assert_signal_emit_count(energy_grid, "energy_generation_changed", 2)
	
	energy_grid.remove_grid_connection(connection3)
	assert_eq(energy_grid.is_empty(), false)
	assert_eq(energy_grid.energy_generation(), 2 * GN_ENERGY_GENERATION)
	assert_signal_emitted_with_parameters(energy_grid, "energy_generation_changed", [2 * GN_ENERGY_GENERATION])
	
	energy_grid.remove_grid_connection(connection1)
	assert_eq(energy_grid.is_empty(), true)
	assert_eq(energy_grid.energy_generation(), 0)
	assert_signal_emitted_with_parameters(energy_grid, "energy_generation_changed", [0])
	
	assert_signal_emit_count(energy_grid, "energy_generation_changed", 4)


func test_merge_with_grid():
	var other_grid = autofree(EnergyGrid.new())
	other_grid.add_grid_connection(GridConnection.new(grid_node_structure1, grid_node_structure2))
	other_grid.add_grid_connection(GridConnection.new(grid_node_structure2, grid_node_structure3))
	other_grid.add_grid_connection(GridConnection.new(grid_node_structure1, grid_node_structure3))
	
	energy_grid.add_grid_connection(GridConnection.new(affecting_structure1, affecting_structure2))

	var expected_generation = energy_grid.energy_generation() + other_grid.energy_generation()
	var expected_consumption = energy_grid.energy_consumption() + other_grid.energy_consumption() 
	energy_grid.merge_with_grid(other_grid)

	assert_eq(energy_grid.energy_generation(), expected_generation)
	assert_eq(energy_grid.energy_consumption(), expected_consumption)
	assert_eq(energy_grid._connections.size(), 4)
