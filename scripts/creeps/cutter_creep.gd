class_name CutterCreep
extends Creep

const PRICE = 150

func _init(game_controller: GameController):
	super(game_controller, 100, 20)


func on_grid_connection_touch(connection: GridConnection):
	_game_controller.grid_connections.remove_grid_connection_between(connection.structure1, connection.structure2)


func _to_string() -> String:
	return "CutterCreep(%s, health=%s)" % [position, health]
