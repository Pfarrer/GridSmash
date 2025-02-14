extends Control

var game_scene = preload("res://scenes/game/game.tscn")

var game_controller: GameController

func _ready() -> void:
	var game = game_scene.instantiate()
	game_controller = GameController.new()
	game.game_controller = game_controller
	add_child(game)
	initialize_game()


func initialize_game():
	game_controller._credits = 10000

	var t1 = LaserStructure.new(Vector2(135, 132))
	var t2 = ShockwaveStructure.new(Vector2(256, 123))
	var t3 = LaserStructure.new(Vector2(188, 456))
	game_controller.build_structure(t1)
	game_controller.build_structure(t2)
	game_controller.build_structure(t3)

	var g1 = GridNodeStructure.new(Vector2(243, 196))
	var g2 = GridNodeStructure.new(Vector2(285, 281))
	game_controller.grid_connections.add_grid_connection_between(t1, g1)
	game_controller.grid_connections.add_grid_connection_between(t2, g1)
	game_controller.grid_connections.add_grid_connection_between(g1, g2)
	game_controller.build_structure(g1)
	game_controller.build_structure(g2)

	var p1 = GeneratorStructure.new(Vector2(310, 354))
	var b1 = BatteryStructure.new(Vector2(240, 356))
	game_controller.grid_connections.add_grid_connection_between(p1, g2)
	game_controller.grid_connections.add_grid_connection_between(b1, g2)
	game_controller.build_structure(p1)
	game_controller.build_structure(b1)
	
	game_controller.clock_ticked.connect(func (_t1: int):
		game_controller.send_creep(CutterCreep)
	, ConnectFlags.CONNECT_ONE_SHOT)
