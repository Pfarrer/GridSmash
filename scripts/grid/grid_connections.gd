class_name GridConnections
extends RefCounted

signal grid_connection_added(connection: GridConnection)
signal grid_connection_removed(connection: GridConnection)

var connections: Array = []

func add_grid_connection_between(structure1: Structure, structure2: Structure):
	add_grid_connection(GridConnection.new(structure1, structure2))


func add_grid_connection(connection: GridConnection):
	assert(connection.structure1 is GridNodeStructure || connection.structure2 is GridNodeStructure)
	if !is_grid_connected(connection.structure1, connection.structure2):
		connections.push_back(connection)
		grid_connection_added.emit(connection)
		
		print("add_grid_connection -- connection: ", connection)


func remove_grid_connection_between(structure1: Structure, structure2: Structure):
	for i in range(connections.size()):
		var connection = connections[i]
		if connection.connects_to(structure1) && connection.connects_to(structure2):
			connections.remove_at(i)
			grid_connection_removed.emit(connection)
			
			print("remove_grid_connection_between -- structure1: ", structure1, ", structure2: ", structure2)
			return


func is_grid_connected(structure1: Structure, structure2: Structure) -> bool:
	for connection in connections:
		if connection.connects_to(structure1) && connection.connects_to(structure2):
			return true
	return false


func find_grid_connections(structure: Structure) -> Array:
	var result = []
	for connection in connections:
		if connection.connects_to(structure):
			result.push_back(connection)
	return result
