class_name GeneratorStructure
extends Structure

func _init(pos: Vector2) -> void:
	super(pos, 15, 300)
	energy_generation = 10


func _to_string() -> String:
	return "GeneratorStructure(%s, floating=%s)" % [position, is_floating]
