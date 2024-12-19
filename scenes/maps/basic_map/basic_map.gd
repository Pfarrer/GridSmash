extends Node2D


var creep_scene = preload("res://scenes/creep/creep.tscn")


var game_controller: GameController


func _ready() -> void:
	$CreepPath/Line2d.points = $CreepPath.curve.get_baked_points()
	game_controller.creep_spawned.connect(_on_creep_spawned)


func _on_creep_spawned():
	var creep = creep_scene.instantiate()
	$CreepPath.add_child(creep)
