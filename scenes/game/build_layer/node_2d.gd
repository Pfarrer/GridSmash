extends Node2D

const COLOR_OK = Color.GRAY
const COLOR_COLLISION = Color.RED
const COLOR_AREA_LINE = Color.GRAY

var game_controller: GameController
var is_colliding = false

func _input(event: InputEvent) -> void:
	if event.is_action("mouse_click"):
		on_mouse_click()
		queue_free()
		get_viewport().set_input_as_handled()


func _process(_delta: float):
	position = get_viewport().get_mouse_position()


func _draw():
	var tower_color = COLOR_COLLISION if is_colliding else COLOR_OK
	draw_circle(Vector2(0,0), 20.0, tower_color, true, -1, true)
	draw_circle(Vector2(0,0), 80.0, COLOR_AREA_LINE, false, 2.0, true)


func _on_path_collision_start(_node: Node) -> void:
	is_colliding = true
	queue_redraw()


func _on_path_collision_end(_node: Node) -> void:
	is_colliding = false
	queue_redraw()


func on_mouse_click():
	if !is_colliding:
		game_controller.build(position)
