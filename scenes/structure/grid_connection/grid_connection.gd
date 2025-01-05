extends Node2D

var position_source: Vector2
var position_drain: Vector2

func _ready() -> void:
	$Line2D.add_point(position_source)
	$Line2D.add_point(position_drain)
