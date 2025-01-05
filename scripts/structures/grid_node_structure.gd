class_name GridNodeStructure
extends Structure

var max_connection_length = 100
var connections: Array = []

func _init(pos: Vector2) -> void:
	super(pos, 10)


func add_grid_connection(drain: Structure):
	connections.push_back(drain)


func remove_grid_connection(drain: Structure):
	var idx = connections.find(drain)
	if idx == -1:
		print("Supposed to remove connection structure, but structure not connected")
	else:
		connections.remove_at(idx)
