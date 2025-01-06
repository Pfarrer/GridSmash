class_name Structure
extends RefCounted

var is_floating = false
var position: Vector2
var structure_radius
var structure_price
var max_grid_connection_length = 100

func _init(pos: Vector2, radius: int, price: int) -> void:
	self.position = pos
	self.structure_radius = radius
	self.structure_price = price
