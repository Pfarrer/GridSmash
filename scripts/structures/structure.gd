class_name Structure
extends RefCounted

var is_floating = false
var position: Vector2
var structure_radius

func _init(pos: Vector2, radius: int) -> void:
	self.position = pos
	self.structure_radius = radius
