extends Node2D

@onready var root_node = $".."

func _draw():
	draw_circle(Vector2(0,0), root_node.structure.affect_radius, Color.GRAY, false, 2, true)
