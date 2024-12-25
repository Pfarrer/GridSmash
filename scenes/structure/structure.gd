extends Node2D

@onready var range_circle = $RangeCircle

var game_controller: GameController
var structure: Structure

func _ready() -> void:
	position = structure._position


func _draw():
	draw_circle(Vector2(0,0), 20.0, Color.GREEN, true, -1, true)


func on_creep_in_range(area: Area2D) -> void:
	print("in range", area)


func on_creep_out_of_range(area: Area2D) -> void:
	pass # Replace with function body.
