extends Node2D

var game_controller: GameController
var structure: Structure

func _ready() -> void:
	assert(game_controller)
	assert(structure)
	
	position = structure.position
	$StructureArea/CollisionShape2D.shape.radius = structure.structure_radius
	
	if is_instance_of(structure, AffectingStructure):
		$RangeArea/CollisionShape2D.shape.radius = structure.affect_radius
		$RangeArea.monitoring = true
		structure.creep_affected.connect(on_creep_affected)
		
		$AffectTimer.wait_time = structure.affect_interval_ms / 1000.
		$AffectTimer.start()


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

	$AffectTimer.start()


func show_range() -> void:
	$RangeCircle.show()


func hide_range() -> void:
	$RangeCircle.hide()


func connect_to_structure_area_collisions(on_start: Callable, on_end: Callable):
	$StructureArea.connect("area_entered", on_start)
	$StructureArea.connect("area_exited", on_end)
