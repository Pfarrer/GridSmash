class_name BatteryStructure
extends Structure

const PRICE = 500

func _init(pos: Vector2) -> void:
	super(pos, 25, PRICE)
	energy_priority = 3
	energy_capacity = 100
	energy_consumption = 20


func _to_string() -> String:
	return "BatteryStructure(%s, floating=%s)" % [position, is_floating]
