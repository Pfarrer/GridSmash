class_name EnergyGrid
extends RefCounted

signal energy_generation_max_changed(energy_generation: int)
signal energy_consumption_max_changed(energy_generation: int)
signal energy_capacity_max_changed(energy_stored: int)

var energy_flow = EnergyFlow.new(self)

var _connections: Array = []
var _structures_set = CountingSet.new()
var _energy_generation_max: int = 0
var _energy_consumption_max: int = 0
var _energy_capacity_max: int = 0

func is_structure_connected_to_grid(structure: Structure) -> bool:
	for connection in _connections:
		if connection.connects_to(structure):
			return true
	return false


func add_grid_connection(connection: GridConnection) -> void:
	if _connections.has(connection):
		return
	
	_connections.push_back(connection)

	var previous_generation = _energy_generation_max
	var previous_consumption = _energy_consumption_max
	var previous_capacity = _energy_capacity_max
	
	if _structures_set.add(connection.structure1) == 1:
		_energy_generation_max += connection.structure1.energy_generation
		_energy_consumption_max += connection.structure1.energy_consumption
		_energy_capacity_max += connection.structure1.energy_capacity
	if _structures_set.add(connection.structure2) == 1:
		_energy_generation_max += connection.structure2.energy_generation
		_energy_consumption_max += connection.structure2.energy_consumption
		_energy_capacity_max += connection.structure2.energy_capacity
	
	if _energy_generation_max != previous_generation:
		energy_generation_max_changed.emit(_energy_generation_max)
	if _energy_consumption_max != previous_consumption:
		energy_consumption_max_changed.emit(_energy_consumption_max)
	if _energy_capacity_max != previous_capacity:
		energy_capacity_max_changed.emit(_energy_capacity_max)


func remove_grid_connection(connection: GridConnection) -> void:
	var idx = _connections.find(connection)
	if idx != -1:
		_connections.remove_at(idx)
		
		var previous_generation = _energy_generation_max
		var previous_consumption = _energy_consumption_max
		var previous_capacity = _energy_capacity_max

		if _structures_set.sub(connection.structure1) == 0:
			_energy_generation_max -= connection.structure1.energy_generation
			_energy_consumption_max -= connection.structure1.energy_consumption
			_energy_capacity_max -= connection.structure1.energy_capacity
		if _structures_set.sub(connection.structure2) == 0:
			_energy_generation_max -= connection.structure2.energy_generation
			_energy_consumption_max -= connection.structure2.energy_consumption
			_energy_capacity_max -= connection.structure2.energy_capacity
		
		if _energy_generation_max != previous_generation:
			energy_generation_max_changed.emit(_energy_generation_max)
		if _energy_consumption_max != previous_consumption:
			energy_consumption_max_changed.emit(_energy_consumption_max)
		if _energy_capacity_max != previous_capacity:
			energy_capacity_max_changed.emit(_energy_capacity_max)


func merge_with_grid(other: EnergyGrid) -> void:
	for connection in other._connections:
		add_grid_connection(connection)


func energy_generation_max() -> int:
	return _energy_generation_max


func energy_consumption_max() -> int:
	return _energy_consumption_max


func energy_capacity_max() -> int:
	return _energy_capacity_max


func is_empty() -> bool:
	return _connections.size() == 0


func structures() -> Array:
	return _structures_set.items()
