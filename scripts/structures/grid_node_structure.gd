class_name GridNodeStructure
extends Structure

var power_generation = 1000

func _init(pos: Vector2) -> void:
	super(pos, 10, 100)


func _to_string() -> String:
	return "GridNodeStructure(%s, floating=%s)" % [position, is_floating]
