extends Node2D

const COLOR_OK = Color.GRAY
const COLOR_COLLISION = Color.RED
const COLOR_AREA_LINE = Color.GRAY

var game_controller: GameController
var structure_type: Variant

var collisions = 0
var structure: Structure
var structure_scene: Node

func _ready() -> void:
	assert(game_controller)
	assert(structure_type)
	
	structure = structure_type.new(Vector2.ZERO)
	structure.is_floating = true
	
	structure_scene = preload("res://scenes/structure/structure.tscn").instantiate()
	structure_scene.game_controller = game_controller
	structure_scene.structure = structure
	structure_scene.connect_to_structure_area_collisions(on_collision_start, on_collision_end)
	structure_scene.show_range()
	add_child(structure_scene)


func _input(event: InputEvent) -> void:
	if event.is_action("mouse_click"):
		on_mouse_click()
		queue_free()
		get_viewport().set_input_as_handled()


func _process(_delta: float):
	position = get_viewport().get_mouse_position()
	structure.position = position


func _draw():
	if collisions > 0:
		draw_circle(Vector2(0,0), structure.structure_radius, COLOR_COLLISION, true, -1, true)
		structure_scene.hide()
	else:
		structure_scene.show()


func on_collision_start(_node: Node) -> void:
	collisions += 1
	queue_redraw()


func on_collision_end(_node: Node) -> void:
	collisions -= 1
	queue_redraw()


func on_mouse_click():
	if collisions == 0:
		structure.position = position
		game_controller.build_structure(structure)
