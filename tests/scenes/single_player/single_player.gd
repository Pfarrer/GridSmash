extends Node2D

var game_scene = preload("res://scenes/game/game.tscn")

var game_controller: GameController

func _ready() -> void:
	var game = game_scene.instantiate()
	game_controller = GameController.new(game.find_child("GameTimer").timeout)
	game.game_controller = game_controller
	add_child(game)
	initialize_game()


func initialize_game():
	game_controller._credits += \
		3 * AffectingStructure.new(Vector2.ZERO).structure_price + \
		1 * GridNodeStructure.new(Vector2.ZERO).structure_price + \
		1 * GameController.CREEP_PRICE
	var t1 = AffectingStructure.new(Vector2(195, 132))
	var t3 = AffectingStructure.new(Vector2(188, 526))
	var t2 = AffectingStructure.new(Vector2(359, 122))
	game_controller.build_structure(t1)
	game_controller.build_structure(t2)
	game_controller.build_structure(t3)

	var g1 = GridNodeStructure.new(Vector2(283, 196))
	game_controller.grid_connections.add_grid_connection_between(t1, g1)
	game_controller.grid_connections.add_grid_connection_between(t2, g1)
	game_controller.build_structure(g1)
	
	game_controller.clock_ticked.connect(func (_t1: int):
		game_controller.send_creep()
	, ConnectFlags.CONNECT_ONE_SHOT)
