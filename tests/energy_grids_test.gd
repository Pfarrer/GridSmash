extends GutTest

var affecting_structure1 = LaserStructure.new(Vector2.ZERO)
var affecting_structure2 = LaserStructure.new(Vector2.ZERO)
var affecting_structure3 = ShockwaveStructure.new(Vector2.ZERO)

var grid_node_structure1 = GridNodeStructure.new(Vector2.ZERO)
var grid_node_structure2 = GridNodeStructure.new(Vector2.ZERO)
var grid_node_structure3 = GridNodeStructure.new(Vector2.ZERO)
var grid_node_structure4 = GridNodeStructure.new(Vector2.ZERO)

var energy_grids: EnergyGrids

func before_each():
	energy_grids = autofree(EnergyGrids.new())
	watch_signals(energy_grids)


func test_add_connections_to_single_grid():
	assert_eq(energy_grids.grids().size(), 0)

	var connection1 = GridConnection.new(grid_node_structure1, grid_node_structure2)
	energy_grids.on_grid_connection_added(connection1)
	assert_signal_emitted(energy_grids, "grid_added")
	assert_eq(energy_grids.grids().size(), 1)
	
	var connection2 = GridConnection.new(grid_node_structure1, grid_node_structure3)
	energy_grids.on_grid_connection_added(connection2)
	assert_signal_emit_count(energy_grids, "grid_added", 1)
	assert_eq(energy_grids.grids().size(), 1)

	var connection3 = GridConnection.new(grid_node_structure2, grid_node_structure3)
	energy_grids.on_grid_connection_added(connection3)
	assert_signal_emit_count(energy_grids, "grid_added", 1)
	assert_eq(energy_grids.grids().size(), 1)

	var connection4 = GridConnection.new(grid_node_structure2, affecting_structure1)
	energy_grids.on_grid_connection_added(connection4)
	assert_signal_emit_count(energy_grids, "grid_added", 1)
	assert_eq(energy_grids.grids().size(), 1)



func test_two_distinct_grids():
	assert_eq(energy_grids.grids().size(), 0)

	var connection1 = GridConnection.new(grid_node_structure1, grid_node_structure2)
	energy_grids.on_grid_connection_added(connection1)
	assert_signal_emitted(energy_grids, "grid_added")
	assert_eq(energy_grids.grids().size(), 1)
	
	var connection2 = GridConnection.new(affecting_structure1, affecting_structure2)
	energy_grids.on_grid_connection_added(connection2)
	assert_signal_emit_count(energy_grids, "grid_added", 2)
	assert_eq(energy_grids.grids().size(), 2)

	# Add one more connectin to each grid
	var connection3 = GridConnection.new(grid_node_structure1, grid_node_structure3)
	energy_grids.on_grid_connection_added(connection3)
	assert_signal_emit_count(energy_grids, "grid_added", 2)
	assert_eq(energy_grids.grids().size(), 2)

	var connection4 = GridConnection.new(affecting_structure2, affecting_structure3)
	energy_grids.on_grid_connection_added(connection4)
	assert_signal_emit_count(energy_grids, "grid_added", 2)
	assert_eq(energy_grids.grids().size(), 2)


func test_merge_two_grids():
	assert_eq(energy_grids.grids().size(), 0)

	var connection1 = GridConnection.new(grid_node_structure1, grid_node_structure2)
	energy_grids.on_grid_connection_added(connection1)
	assert_signal_emitted(energy_grids, "grid_added")
	
	var connection2 = GridConnection.new(affecting_structure1, affecting_structure2)
	energy_grids.on_grid_connection_added(connection2)
	assert_signal_emitted(energy_grids, "grid_added")
	assert_eq(energy_grids.grids().size(), 2)

	# Connect both grids
	var connection3 = GridConnection.new(grid_node_structure1, affecting_structure1)
	energy_grids.on_grid_connection_added(connection3)
	assert_signal_emit_count(energy_grids, "grid_added", 2)
	assert_signal_emitted(energy_grids, "grid_removed")
	assert_eq(energy_grids.grids().size(), 1)


func test_split_grid_by_removing_connections():
	# Prepare a grid with 4 structures and 3 connections in a chain
	var connection1 = GridConnection.new(grid_node_structure1, grid_node_structure2)
	energy_grids.on_grid_connection_added(connection1)
	var connection2 = GridConnection.new(grid_node_structure2, grid_node_structure3)
	energy_grids.on_grid_connection_added(connection2)
	var connection3 = GridConnection.new(grid_node_structure3, grid_node_structure4)
	energy_grids.on_grid_connection_added(connection3)
	assert_eq(energy_grids.grids().size(), 1)

	# Remove connection in the middle
	energy_grids.on_grid_connection_removed(connection2)
	assert_signal_emitted(energy_grids, "grid_added")
	assert_eq(energy_grids.grids().size(), 2)

	var grid1 = energy_grids.grids()[0]
	assert_eq(grid1.structures(), [grid_node_structure1, grid_node_structure2])
	assert_eq(grid1.energy_flow._energy_generation_max, grid_node_structure1.energy_generation + grid_node_structure2.energy_generation)

	var grid2 = energy_grids.grids()[1]
	assert_eq(grid2.structures(), [grid_node_structure3, grid_node_structure4])
	assert_eq(grid2.energy_flow._energy_generation_max, grid_node_structure3.energy_generation + grid_node_structure4.energy_generation)

	# Remove connection in grid2
	energy_grids.on_grid_connection_removed(connection3)
	assert_signal_emitted(energy_grids, "grid_removed")
	assert_eq(energy_grids.grids().size(), 1)
