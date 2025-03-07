class_name GridNodeStructure
extends Structure

const PRICE = 50

func _init(pos: Vector2) -> void:
	super(pos, 10, PRICE)
	energy_generation = 1


func _to_string() -> String:
	return "GridNodeStructure(%s, floating=%s)" % [position, is_floating]
