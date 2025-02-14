class_name CreepArea
extends Area2D

func get_creep() -> Creep:
	return get_parent().creep
