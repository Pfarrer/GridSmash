class_name BatteryStructure
extends Structure

func _init(pos: Vector2) -> void:
	super(pos, 25, 500)
	energy_capacity = 100


func _to_string() -> String:
	return "BatteryStructure(%s, floating=%s)" % [position, is_floating]
