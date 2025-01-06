extends Node2D

var game_controller: GameController

func _ready() -> void:
	assert(game_controller)
	
	game_controller.grid_connections.grid_connection_added.connect(on_grid_connection_added)
	game_controller.grid_connections.grid_connection_removed.connect(on_grid_connection_removed)


func on_grid_connection_added(connection: GridConnection):
	var grid_connection = preload("res://scenes/game/connection_layer/grid_connection/grid_connection.tscn").instantiate()
	grid_connection.connection = connection
	add_child(grid_connection)


func on_grid_connection_removed(connection: GridConnection):
	for child in get_children():
		if child.connection == connection:
			child.queue_free()
			return
