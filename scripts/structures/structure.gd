class_name Structure
extends RefCounted

var is_floating = false
var position: Vector2
var structure_radius
var structure_price
var max_grid_connection_length = 100

var energy_priority: float = 2
var energy_generation: float = 0
var energy_consumption: float = 0
var energy_capacity: float = 0
var energy_charge: float = 0.0

func _init(pos: Vector2, radius: int, price: int) -> void:
	self.position = pos
	self.structure_radius = radius
	self.structure_price = price


func has_energy_demand() -> bool:
	return energy_capacity > energy_charge 


### Add energy to the structure
### Returns the excess energy that could not be added
func add_energy_charge(charge: float) -> float:
	energy_charge += charge
	if energy_charge > energy_capacity:
		var excess = energy_charge - energy_capacity
		energy_charge = energy_capacity
		return excess
	return 0.0

