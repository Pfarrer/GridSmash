class_name ShockwaveStructure
extends AffectingStructure

const PRICE = 250

func _init(pos: Vector2) -> void:
	super(pos, 20, PRICE, 60, 5, 5)


func _affect_creeps() -> void:
	for target_creep in creeps_in_range:
		target_creep.handle_affect(affect_damage)
	creeps_affected.emit(creeps_in_range)
