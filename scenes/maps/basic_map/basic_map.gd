extends Node2D

var creep_scene = preload("res://scenes/creep/creep.tscn")

var game_controller: GameController

func _ready() -> void:
	assert(game_controller)
	
	$CreepPath/Line2d.points = $CreepPath.curve.get_baked_points()
	add_path_collision_shapes($CreepPath.curve.get_baked_points())
	
	game_controller.creep_spawned.connect(_on_creep_spawned)


func _on_creep_spawned():
	var creep = creep_scene.instantiate()
	creep.game_controller = game_controller
	$CreepPath.add_child(creep)


func add_path_collision_shapes(points: PackedVector2Array):
	for i in range(0, points.size() - 1):
		var p1 = points[i]
		var p2 = points[i+1]
		
		var shape = RectangleShape2D.new()
		shape.size = (p1 - p2).min(p2 - p1)
		
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		collision_shape.position = p1
		$PathArea.add_child(collision_shape)
