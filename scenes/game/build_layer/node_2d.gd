extends Node2D

const COLOR_OK = Color.GRAY
const COLOR_COLLISION = Color.RED

var color = COLOR_OK

func _process(delta: float):
	position = get_viewport().get_mouse_position()


func _draw():
	draw_circle(Vector2(0,0), 20.0, color)


func _on_path_collision_start(area: Area2D) -> void:
	color = COLOR_COLLISION
	queue_redraw()


func _on_path_collision_end(area: Area2D) -> void:
	color = COLOR_OK
	queue_redraw()
