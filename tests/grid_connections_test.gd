extends GutTest

var grid_connections: GridConnections

func before_each():
	grid_connections = autofree(GridConnections.new())
	watch_signals(grid_connections)


func test_add_grid_connection():
	var structure1 = autofree(Structure.new(Vector2(0, 0), 10, 100))
	var structure2 = autofree(Structure.new(Vector2(0, 0), 10, 100))
	var structure3 = autofree(Structure.new(Vector2(0, 0), 10, 100))
	
	# No connections yet
	assert_eq(grid_connections.connections.size(), 0)

	# Connect structure1 to structure2
	grid_connections.add_grid_connection_between(structure1, structure2)
	assert_eq(grid_connections.connections.size(), 1)
	assert(grid_connections.is_grid_connected(structure1, structure2))
	assert(grid_connections.is_grid_connected(structure2, structure1))
	assert_false(grid_connections.is_grid_connected(structure1, structure3))
	assert_false(grid_connections.is_grid_connected(structure3, structure2))

	# Connect structure2 to structure3
	grid_connections.add_grid_connection_between(structure2, structure3)
	assert_eq(grid_connections.connections.size(), 2)
	assert(grid_connections.is_grid_connected(structure2, structure3))
	assert_false(grid_connections.is_grid_connected(structure1, structure3))

	# Connect structure3 to structure1
	grid_connections.add_grid_connection_between(structure3, structure1)
	assert_eq(grid_connections.connections.size(), 3)
	assert(grid_connections.is_grid_connected(structure1, structure3))


func test_disconnect_grid_connections():
	var structure1 = autofree(Structure.new(Vector2(0, 0), 10, 100))
	var structure2 = autofree(Structure.new(Vector2(0, 0), 10, 100))
	var structure3 = autofree(Structure.new(Vector2(0, 0), 10, 100))
	
	grid_connections.add_grid_connection_between(structure1, structure2)
	grid_connections.add_grid_connection_between(structure2, structure3)
	grid_connections.add_grid_connection_between(structure3, structure1)

	# Completely disconnect structure1
	grid_connections.remove_grid_connection_between(structure1, structure2)
	grid_connections.remove_grid_connection_between(structure1, structure3)
	assert_eq(grid_connections.connections.size(), 1)
	assert(grid_connections.is_grid_connected(structure2, structure3))
	assert_false(grid_connections.is_grid_connected(structure1, structure3))
	
	# Disconnect structure2 from structure3
	grid_connections.remove_grid_connection_between(structure3, structure2)
	assert_eq(grid_connections.connections.size(), 0)
