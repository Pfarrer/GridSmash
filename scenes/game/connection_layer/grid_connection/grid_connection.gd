extends Node2D

var connection: GridConnection

func _ready() -> void:
	$Line2D.add_point(connection.structure1.position)
	$Line2D.add_point(connection.structure2.position)


func _process(_delta: float) -> void:
	if connection.structure1.is_floating:
		$Line2D.set_point_position(0, connection.structure1.position)
	if connection.structure2.is_floating:
		$Line2D.set_point_position(1, connection.structure2.position)
