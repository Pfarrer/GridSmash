extends Node2D

var game_controller: GameController

func _ready() -> void:
	assert(game_controller)
	
	$CreepPath/Line2d.points = $CreepPath.curve.get_baked_points()
	add_path_collision_shapes($CreepPath.curve.get_baked_points())
	
	game_controller.structure_placed.connect(on_structure_placed)
	game_controller.creep_spawned.connect(on_creep_spawned)


func on_structure_placed(structure: Structure):
	var structure_scene = preload("res://scenes/structure/structure.tscn").instantiate()
	structure_scene.game_controller = game_controller
	structure_scene.structure = structure
	$Structures.add_child(structure_scene)


func on_creep_spawned(creep: Creep):
	var creep_scence = preload("res://scenes/creep/creep.tscn").instantiate()
	creep_scence.creep = creep
	$CreepPath.add_child(creep_scence)


func add_path_collision_shapes(points: PackedVector2Array):
	for i in range(0, points.size() - 1):
		var p1 = points[i]
		var p2 = points[i+1]
		var radius = p1.distance_to(p2) / 2.0
		var center = (p2 - p1) / 2.0

		var shape = CircleShape2D.new()
		shape.radius = radius
		
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		collision_shape.position = p1
		$PathArea.add_child(collision_shape)


func on_map_area_body_exited(body: Node2D) -> void:
	var creep = body.get_creep()
	game_controller.creep_passed(creep)
