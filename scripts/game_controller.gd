class_name GameController

const INITIAL_LIVES = 20
const SECONDS_PER_ROUND = 15
const INITIAL_INCOME = 100
const INITIAL_CREDITS = 1000
const CREEP_INCOME_INCREASE = .1

signal lives_changed(remaining_lives: int)
signal round_changed(round_number: int)
signal clock_ticked(time_remaining_in_current_round: int)
signal income_changed(new_income: int)
signal credits_changed(new_credits: int)
signal creep_spawned(creep: Creep)
signal structure_placed(structure: Structure)

var _lives: int = INITIAL_LIVES
var _round_number: int = 1
var _time_remaining_in_current_round: int = SECONDS_PER_ROUND
var _income: int = INITIAL_INCOME
var _credits: int = INITIAL_CREDITS

var structures: Array[Structure] = []
var creeps: Array[Creep] = []
var grid_connections: GridConnections = GridConnections.new()
var energy_grids = EnergyGrids.new()
var fellow_players = []

func _init():
	grid_connections.grid_connection_removed.connect(energy_grids.on_grid_connection_removed)


func send_creep(creep_type: Variant):
	if _credits >= creep_type.PRICE:
		if fellow_players.is_empty():
			self.receive_creep(creep_type)
		else:
			for fellow_player in fellow_players:
				fellow_player.receive_creep(creep_type)
		
		_credits -= creep_type.PRICE
		credits_changed.emit(_credits)
		
		_income += creep_type.PRICE * CREEP_INCOME_INCREASE
		income_changed.emit(_income)


func receive_creep(creep_class: Variant) -> Creep:
	var creep = creep_class.new(self)
	creeps.append(creep)
	creep.destroyed.connect(_remove_creep)
	creep_spawned.emit(creep)

	print("receive_creep -- creep: ", creep)
	return creep


func creep_passed(creep: Creep):
	if creeps.find(creep) == -1:
		return
		
	if creep.health > 0.0:
		_lives -= 1
		lives_changed.emit(_lives)

		print("creep_passed -- creep: ", creep, " -- lives: ", _lives)

	creep.destroyed.emit(creep)
	
	if _lives == 0:
		print("game over")


func build_structure(structure: Structure) -> void:
	if _credits >= structure.structure_price:
		structure.is_floating = false

		_credits -= structure.structure_price
		credits_changed.emit(_credits)

		structures.append(structure)
		structure_placed.emit(structure)

		for connection in grid_connections.find_grid_connections(structure):
			energy_grids.on_grid_connection_added(connection)
		
		print("build_structure -- structure: ", structure)


# Must be called every second
func on_clock_tick() -> void:
	if _time_remaining_in_current_round == 1:
		_round_number += 1
		round_changed.emit(_round_number)

		_credits += _income
		credits_changed.emit(_credits)

		_time_remaining_in_current_round = SECONDS_PER_ROUND
	else:
		_time_remaining_in_current_round -= 1
	
	clock_ticked.emit(_time_remaining_in_current_round)

	for fellow_player in fellow_players:
		fellow_player.on_clock_tick()


func add_fellow_player(player: FellowPlayer) -> void:
	print("add_fellow_player -- player: ", player)
	fellow_players.push_back(player)


func _remove_creep(creep: Creep):
	var idx = creeps.find(creep)
	if idx > -1:
		creeps.remove_at(idx)
