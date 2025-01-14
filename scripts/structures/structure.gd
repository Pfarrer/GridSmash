class_name Structure
extends RefCounted

var is_floating = false
var position: Vector2
var structure_radius
var structure_price
var max_grid_connection_length = 100

var energy_generation = 0
var energy_consumption = 0
var energy_capacity = 0
var energy_charge: float = 0.0

func _init(pos: Vector2, radius: int, price: int) -> void:
	self.position = pos
	self.structure_radius = radius
	self.structure_price = price


func has_energy_demand() -> bool:
	return energy_charge < energy_capacity


func add_energy_charge(charge: float) -> void:
	energy_charge += charge
