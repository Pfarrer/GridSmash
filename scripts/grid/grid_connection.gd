class_name GridConnection
extends RefCounted

var structure1: Structure
var structure2: Structure

func _init(structure1: Structure, structure2: Structure):
	assert(structure1 != structure2)
	self.structure1 = structure1
	self.structure2 = structure2


func connects_to(structure: Structure) -> bool:
	return structure == structure1 || structure == structure2
