class_name Creep

# A creep is also destroyed when it passes through the entire map and steals a live from the player.
signal destroyed(creep: Creep)

var position = Vector2.ZERO
var speed: float
var health: float

var _game_controller: GameController

func _init(game_controller: GameController, _speed: float, _health: float):
	_game_controller = game_controller
	speed = _speed
	health = _health


func handle_affect(affect_damage: int):
	health -= affect_damage
	
	if health <= 0:
		health = 0
		self.destroyed.emit(self)


func on_grid_connection_touch(connection: GridConnection):
	pass


func _to_string() -> String:
	return "Creep(%s, health=%s)" % [position, health]
