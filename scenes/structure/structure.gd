extends Node2D

@onready var range_circle = $RangeCircle
@onready var affect_timer = $AffectTimer

var game_controller: GameController
var structure: Structure

func _ready() -> void:
	assert(game_controller)
	assert(structure)
	
	position = structure.position
	
	structure.creep_affected.connect(on_creep_affected)
	
	affect_timer.wait_time = structure.affect_interval_ms / 1000.
	affect_timer.start()


func _draw():
	draw_circle(Vector2(0,0), structure.structure_radius, Color.GREEN, true, -1, true)


func on_creep_in_range(area: Area2D) -> void:
	var creep = area.get_creep()
	structure.set_creep_in_range(creep)


func on_creep_out_of_range(area: Area2D) -> void:
	var creep = area.get_creep()
	structure.set_creep_out_of_range(creep)


func on_affect_timer_timeout() -> void:
	structure.set_affect_ready()


func on_creep_affected(creep: Creep):
	var laser_affect = preload("res://scenes/structure/laser_affect/laser_affect.tscn").instantiate()
	laser_affect.structure = structure
	laser_affect.creep = creep
	add_child(laser_affect)

	affect_timer.start()
