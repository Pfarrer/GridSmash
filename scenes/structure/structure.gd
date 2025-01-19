extends Node2D

var game_controller: GameController
var structure: Structure

func _ready() -> void:
	assert(game_controller)
	assert(structure)
	
	position = structure.position
	_set_structure_specific_asset()
	$StructureArea/CollisionShape2D.shape.radius = structure.structure_radius
	
	$GridConnectionRangeArea/CollisionShape2D.shape.radius = structure.max_grid_connection_length
	$GridConnectionRangeArea.area_entered.connect(on_structure_in_range)
	$GridConnectionRangeArea.area_exited.connect(on_structure_out_of_range)
	
	if is_instance_of(structure, AffectingStructure):
		$AffectRangeArea/CollisionShape2D.shape.radius = structure.affect_radius
		$AffectRangeArea.body_entered.connect(on_creep_in_range)
		$AffectRangeArea.body_exited.connect(on_creep_out_of_range)
		
		structure.creep_affected.connect(on_creep_affected)

	if structure.energy_capacity > 0:
		$ChargeIndicationBar.show()
		update_grid_connection_status("")
		game_controller.grid_connections.grid_connection_added.connect(update_grid_connection_status)
		game_controller.grid_connections.grid_connection_removed.connect(update_grid_connection_status)


func _process(_delta: float) -> void:
	$ChargeIndicationBar.set_charge(structure.energy_charge, structure.energy_capacity)


func _draw():
	draw_circle(Vector2(0, 0), structure.structure_radius, Color.WHITE, true, -1, true)


func _set_structure_specific_asset():
	if structure is GridNodeStructure:
		$Sprites/GridNodeSprite.show()
	elif structure is GeneratorStructure:
		$Sprites/GeneratorSprite.show()
	elif structure is BatteryStructure:
		$Sprites/BatterySprite.show()
	elif structure is AffectingStructure:
		$Sprites/LaserSprite.show()


func on_creep_in_range(node: Node2D) -> void:
	var creep = node.get_creep()
	structure.set_creep_in_range(creep)


func on_creep_out_of_range(node: Node2D) -> void:
	var creep = node.get_creep()
	structure.set_creep_out_of_range(creep)


func on_creep_affected(creep: Creep):
	var laser_affect = preload("res://scenes/structure/laser_affect/laser_affect.tscn").instantiate()
	laser_affect.structure = structure
	laser_affect.creep = creep
	add_child(laser_affect)


func show_range() -> void:
	$RangeCircle.show()


func hide_range() -> void:
	$RangeCircle.hide()


func connect_to_structure_area_collisions(on_start: Callable, on_end: Callable):
	$StructureArea.connect("area_entered", on_start)
	$StructureArea.connect("area_exited", on_end)


func on_structure_in_range(area: Area2D) -> void:
	var drain_structure: Structure = area.get_structure()
	if structure != drain_structure && structure.is_floating && (structure is GridNodeStructure || drain_structure is GridNodeStructure):
		game_controller.grid_connections.add_grid_connection_between(structure, drain_structure)


func on_structure_out_of_range(area: Area2D) -> void:
	var drain_structure: Structure = area.get_structure()
	if structure != drain_structure && structure.is_floating:
		game_controller.grid_connections.remove_grid_connection_between(structure, drain_structure)


func update_grid_connection_status(_notused: Variant) -> void:
	if game_controller.grid_connections.find_grid_connections(structure).is_empty():
		$ChargeIndicationBar.show_grid_connection_warning()
	else:
		$ChargeIndicationBar.hide_grid_connection_warning()
