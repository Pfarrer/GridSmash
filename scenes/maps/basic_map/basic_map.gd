extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CreepPath/Line2d.points = $CreepPath.curve.get_baked_points()
