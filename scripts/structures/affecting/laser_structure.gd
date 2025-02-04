class_name LaserStructure
extends AffectingStructure

func _init(pos: Vector2) -> void:
	super(pos, 20, 300, 90, 20, 5)


func _affect_creeps() -> void:
	var target_creep = creeps_in_range.front()
	creeps_affected.emit([target_creep])
	target_creep.handle_affect(affect_damage)
