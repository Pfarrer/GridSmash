class_name StrongCreep
extends Creep

func _init(game_controller: GameController):
	super(game_controller, 100, 50)


func _to_string() -> String:
	return "StrongCreep(%s, health=%s)" % [position, health]
