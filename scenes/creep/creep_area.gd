extends CharacterBody2D

func get_creep() -> Creep:
	return get_parent().creep
