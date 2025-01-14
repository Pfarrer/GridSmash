class_name EnergyGrids
extends RefCounted

signal grid_added(grid: EnergyGrid)
signal grid_removed(grid: EnergyGrid)

var _grids: Array = []

func on_grid_connection_added(connection: GridConnection) -> void:
	var connected_grids = _grids_connected_to(connection)
	if connected_grids.size() == 2:
		connected_grids[0].merge_with_grid(connected_grids[1])
		_grids.erase(connected_grids[1])
		grid_removed.emit(connected_grids[1])
	elif connected_grids.size() == 1:
		connected_grids[0].add_grid_connection(connection)
	else:
		var new_grid = EnergyGrid.new()
		new_grid.add_grid_connection(connection)
		_grids.push_back(new_grid)
		grid_added.emit(new_grid)


func on_grid_connection_removed(connection: GridConnection) -> void:
	for grid in _grids:
		if grid.is_structure_connected_to_grid(connection.structure1) || grid.is_structure_connected_to_grid(connection.structure2):
			grid.remove_grid_connection(connection)
		if grid.is_empty():
			_grids.erase(grid)
			grid_removed.emit(grid)


func grids() -> Array:
	return _grids


func _grids_connected_to(connection: GridConnection) -> Array:
	var results = []
	for grid in _grids:
		if grid.is_structure_connected_to_grid(connection.structure1) || grid.is_structure_connected_to_grid(connection.structure2):
			results.push_back(grid)
	return results
