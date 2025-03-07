class_name GeneratorStructure
extends Structure

const PRICE = 300

func _init(pos: Vector2) -> void:
	super(pos, 15, PRICE)
	energy_generation = 10


func _to_string() -> String:
	return "GeneratorStructure(%s, floating=%s)" % [position, is_floating]
