class_name GridConnection
extends RefCounted

var structure1: Structure
var structure2: Structure

func _init(_structure1: Structure, _structure2: Structure):
	assert(_structure1 != _structure2)
	self.structure1 = _structure1
	self.structure2 = _structure2


func connects_to(structure: Structure) -> bool:
	return structure == structure1 || structure == structure2


func _to_string():
	return "GridConnection(%s, %s)" % [structure1, structure2]
