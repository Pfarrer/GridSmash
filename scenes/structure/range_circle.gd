extends Node2D

@onready var root_node = $".."

func _draw():
	if is_instance_of(root_node.structure, AffectingStructure):
		draw_circle(Vector2(0,0), root_node.structure.affect_radius, Color.GRAY, false, 2, true)
	elif is_instance_of(root_node.structure, GridNodeStructure):
		draw_circle(Vector2(0,0), root_node.structure.max_grid_connection_length, Color.GRAY, false, 2, true)
