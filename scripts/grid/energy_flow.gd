class_name EnergyFlow
extends RefCounted

var current_energy_flow = 0

var _energy_grid: EnergyGrid

func _init(energy_grid: EnergyGrid):
	self._energy_grid = energy_grid


func update_flow(delta: float) -> void:
	var demand = _total_energy_demand()
	var generation = _energy_grid._energy_generation_max

	if generation >= demand:
		# Enough energy is generated to meet the demand
		current_energy_flow = demand
		_update_structure_charges(delta, 1.0)
	else:
		current_energy_flow = generation
		_update_structure_charges(delta, float(generation) / demand)


func _update_structure_charges(delta: float, rate: float) -> void:
	for structure in _energy_grid.structures():
		if structure.has_energy_demand():
			structure.add_energy_charge(structure.energy_consumption * rate * delta)


func _total_energy_demand() -> int:
	var total_demand = 0
	for structure in _energy_grid.structures():
		if structure.has_energy_demand():
			total_demand += structure.energy_consumption
	return total_demand
