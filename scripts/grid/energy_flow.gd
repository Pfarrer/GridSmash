class_name EnergyFlow

signal energy_generation_max_changed(energy_generation: int)
signal energy_consumption_max_changed(energy_generation: int)
signal energy_capacity_max_changed(energy_stored: int)

var _energy_generation_max: int = 0
var _energy_consumption_max: int = 0
var _energy_capacity_max: int = 0

var current_energy_flow = 0
var current_energy_charge = 0

var _energy_grid: EnergyGrid

func _init(energy_grid: EnergyGrid):
	self._energy_grid = energy_grid


func on_structures_changed() -> void:
	var updated_generation: int = 0
	var updated_consumption: int = 0
	var updated_capacity: int = 0

	for structure in _energy_grid.structures():
		updated_generation += structure.energy_generation
		if structure is BatteryStructure:
			updated_consumption += structure.energy_capacity
		else:
			updated_capacity += structure.energy_consumption
	
	if _energy_generation_max != updated_generation:
		_energy_generation_max = updated_generation
		energy_generation_max_changed.emit(_energy_generation_max)
	if _energy_consumption_max != updated_consumption:
		_energy_consumption_max = updated_consumption
		energy_consumption_max_changed.emit(_energy_consumption_max)
	if _energy_capacity_max != updated_capacity:
		_energy_capacity_max = updated_capacity
		energy_capacity_max_changed.emit(_energy_capacity_max)


func energy_generation_max() -> int:
	return _energy_generation_max


func energy_consumption_max() -> int:
	return _energy_consumption_max


func energy_capacity_max() -> int:
	return _energy_capacity_max



func update_flow(delta: float) -> void:
	current_energy_flow = 0
	current_energy_charge = 0

	var remaining_generation = _energy_generation_max
	current_energy_charge = _total_energy_charge()
	var original_charge = current_energy_charge

	for priority in range(1, 4):
		var demand = _total_energy_demand(priority)
		var original_demand = demand
		if demand == 0:
			continue

		if remaining_generation >= demand:
			# Enough energy is generated to meet the demand
			current_energy_flow += demand
			_update_structure_charges(priority, delta, 1.0)
			remaining_generation -= demand
			demand = 0
		elif remaining_generation > 0:
			# Use the remaining generation as much as possible
			current_energy_flow += remaining_generation
			_update_structure_charges(priority, delta, float(remaining_generation) / demand)
			demand -= remaining_generation
			remaining_generation = 0
		
		if remaining_generation == 0 && current_energy_charge > 0:
			# Use the remaining charge to meet as much demand as possible
			if current_energy_charge >= demand:
				current_energy_flow += demand
				_update_structure_charges(priority, delta, float(demand) / original_demand)
				_update_structure_charge(delta, float(demand) / original_charge)
				current_energy_charge -= demand
				demand = 0
			else:
				# Demand is larger than the remaining charge
				current_energy_flow += current_energy_charge
				_update_structure_charges(priority, delta, float(current_energy_charge) / original_demand)
				_update_structure_charge(delta, float(current_energy_charge) / original_charge)
				demand -= current_energy_charge
				current_energy_charge = 0


func _update_structure_charges(priority: int, delta: float, ratio: float) -> void:
	for structure in _energy_grid.structures():
		if structure.energy_priority == priority && structure.has_energy_demand():
			structure.add_energy_charge(structure.energy_consumption * ratio * delta)


func _update_structure_charge(delta: float, ratio: float) -> void:
	for structure in _energy_grid.structures():
		if structure is BatteryStructure:
			structure.add_energy_charge(- structure.energy_charge * ratio * delta)


func _total_energy_demand(priority: int) -> int:
	var total_demand = 0
	for structure in _energy_grid.structures():
		if structure.energy_priority == priority && structure.has_energy_demand():
			total_demand += structure.energy_consumption
	return total_demand


func _total_energy_charge() -> int:
	var total_charge = 0
	for structure in _energy_grid.structures():
		if structure is BatteryStructure:
			total_charge += structure.energy_charge
	return total_charge
