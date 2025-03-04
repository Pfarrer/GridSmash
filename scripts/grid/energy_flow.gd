class_name EnergyFlow

signal energy_generation_max_changed(energy_generation: float)
signal energy_consumption_max_changed(energy_generation: float)
signal energy_capacity_max_changed(energy_stored: float)

var _energy_generation_max: float = 0
var _energy_consumption_max: float = 0
var _energy_capacity_max: float = 0

var current_energy_flow: float = 0
var current_energy_charge = 0

var _energy_grid: EnergyGrid

func _init(energy_grid: EnergyGrid):
	self._energy_grid = energy_grid


func on_structures_changed() -> void:
	var updated_generation: float = 0
	var updated_consumption: float = 0
	var updated_capacity: float = 0

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


func energy_generation_max() -> float:
	return _energy_generation_max


func energy_consumption_max() -> float:
	return _energy_consumption_max


func energy_capacity_max() -> float:
	return _energy_capacity_max


func update_flow(delta: float) -> void:
	current_energy_flow = 0

	var loop_killer: int
	var remaining_generation = _energy_generation_max
	var remaining_battery_charge = _total_battery_charge()

	for priority in range(1, 4):
		var remaining_demand = _total_energy_demand(priority)

		loop_killer = 0
		while remaining_demand > .0 && remaining_generation > .0:		
			remaining_demand = _total_energy_demand(priority)

			if remaining_generation >= remaining_demand:
				# Enough energy is generated to meet the remaining demand
				var excess_energy = _update_structure_charges(priority, delta, 1.0)
				current_energy_flow += remaining_demand - excess_energy
				remaining_generation -= remaining_demand + excess_energy
				remaining_demand = 0.0
			elif remaining_generation > 0.0:
				# Use the remaining generation as much as possible
				var excess_energy = _update_structure_charges(priority, delta, remaining_generation / remaining_demand)
				current_energy_flow += remaining_generation - excess_energy
				remaining_demand -= remaining_generation
				remaining_generation = excess_energy
			
			loop_killer += 1
			if loop_killer > 8:
				print("EnergyFlow.update_flow generation loop iteration: ", loop_killer,
					" remaining_generation=", remaining_generation,
					" remaining_demand=", remaining_demand)
			if loop_killer == 10:
				print("EnergyFlow.update_flow generation loop did not settle, break now! ",
					" priority=", priority,
					" remaining_generation=", remaining_generation,
					" remaining_demand=", remaining_demand)
				break
		
		loop_killer = 0
		while priority < 3 && remaining_demand > 0. && remaining_battery_charge > 0.:
			remaining_demand = _total_energy_demand(priority)

			if remaining_battery_charge >= remaining_demand:
				# Enough battery charge available to meet the remaining demand
				var excess_energy = _update_structure_charges(priority, delta, 1.0)
				_drain_battery_charge(delta, (remaining_demand - excess_energy) / remaining_battery_charge)
				current_energy_flow += remaining_demand - excess_energy
				remaining_battery_charge -= remaining_demand + excess_energy
				remaining_demand = 0.0
			else:
				# Demand is larger than the remaining charge
				var excess_energy = _update_structure_charges(priority, delta, remaining_battery_charge / remaining_demand)
				_drain_battery_charge(delta, (remaining_demand - excess_energy) / remaining_battery_charge)
				current_energy_flow += remaining_demand - excess_energy
				remaining_demand -= remaining_battery_charge + excess_energy
				remaining_battery_charge = excess_energy

			loop_killer += 1
			if loop_killer > 8:
				print("EnergyFlow.update_flow battery loop iteration: ", loop_killer,
					" remaining_battery_charge=", remaining_battery_charge,
					" remaining_demand=", remaining_demand)
			if loop_killer == 10:
				print("EnergyFlow.update_flow battery loop did not settle, break now! ",
					" priority=", priority,
					" remaining_battery_charge=", remaining_battery_charge,
					" remaining_demand=", remaining_demand)
				break


func _update_structure_charges(priority: int, delta: float, ratio: float) -> float:
	var excess_energy = 0.0
	for structure in _energy_grid.structures():
		if structure.energy_priority == priority && structure.has_energy_demand():
			excess_energy += structure.add_energy_charge(structure.energy_consumption * ratio * delta)
	return excess_energy / delta


func _drain_battery_charge(delta: float, ratio: float) -> void:
	for structure in _energy_grid.structures():
		if structure is BatteryStructure:
			structure.add_energy_charge(- structure.energy_charge * ratio * delta)


func _total_energy_demand(priority: int) -> float:
	var total_demand = 0.0
	for structure in _energy_grid.structures():
		if structure.energy_priority == priority && structure.has_energy_demand():
			total_demand += structure.energy_consumption
	return total_demand


func _total_battery_charge() -> float:
	var total_charge = 0.
	for structure in _energy_grid.structures():
		if structure is BatteryStructure:
			total_charge += structure.energy_charge
	return total_charge
