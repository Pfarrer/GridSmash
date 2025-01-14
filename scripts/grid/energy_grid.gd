class_name EnergyGrid
extends RefCounted

signal energy_generation_changed(energy_generation: int)
signal energy_consumption_changed(energy_generation: int)
signal energy_stored_changed(energy_stored: int)

var _connections: Array = []
var _structures_set = CountingSet.new()
var _energy_generation: int = 0
var _energy_consumption: int = 0
var _energy_stored: int = 0

func is_structure_connected_to_grid(structure: Structure) -> bool:
	for connection in _connections:
		if connection.connects_to(structure):
			return true
	return false


func add_grid_connection(connection: GridConnection) -> void:
	if _connections.has(connection):
		return
	
	_connections.push_back(connection)

	var previous_energy_generation = _energy_generation
	var previous_energy_consumption = _energy_consumption
	
	if _structures_set.add(connection.structure1) == 1:
		_energy_generation += connection.structure1.energy_generation
	if _structures_set.add(connection.structure2) == 1:
		_energy_generation += connection.structure2.energy_generation
	
	if _energy_generation != previous_energy_generation:
		energy_generation_changed.emit(_energy_generation)
	if _energy_consumption != previous_energy_consumption:
		energy_consumption_changed.emit(_energy_consumption)


func remove_grid_connection(connection: GridConnection) -> void:
	var idx = _connections.find(connection)
	if idx != -1:
		_connections.remove_at(idx)
		
		var previous_energy_generation = _energy_generation
		var previous_energy_consumption = _energy_consumption
		
		if _structures_set.sub(connection.structure1) == 0:
			_energy_generation -= connection.structure1.energy_generation
		if _structures_set.sub(connection.structure2) == 0:
			_energy_generation -= connection.structure2.energy_generation
		
		if _energy_generation != previous_energy_generation:
			energy_generation_changed.emit(_energy_generation)
		if _energy_consumption != previous_energy_consumption:
			energy_consumption_changed.emit(_energy_consumption)


func merge_with_grid(other: EnergyGrid) -> void:
	for connection in other._connections:
		add_grid_connection(connection)


func energy_generation() -> int:
	return _energy_generation


func energy_consumption() -> int:
	return _energy_consumption


func energy_stored() -> int:
	return _energy_stored


func is_empty() -> bool:
	return _connections.size() == 0
