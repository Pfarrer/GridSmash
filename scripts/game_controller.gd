class_name GameController

const INITIAL_LIVES = 20
const SECONDS_PER_ROUND = 15
const INITIAL_INCOME = 100
const INITIAL_CREDITS = 1000
const CREEP_PRICE = 100
const CREEP_INCOME_INCREASE = 10
const STRUCTURE_PRICE = 500

signal lives_changed(remaining_lives: int)
signal round_changed(round_number: int)
signal clock_ticked(time_remaining_in_current_round: int)
signal income_changed(new_income: int)
signal credits_changed(new_credits: int)
signal creep_spawned()
signal structure_placed(position: Vector2)

var _lives: int = INITIAL_LIVES
var _round_number: int = 1
var _time_remaining_in_current_round: int = SECONDS_PER_ROUND
var _income: int = INITIAL_INCOME
var _credits: int = INITIAL_CREDITS
var structures: Array = []

func _init(game_clock: Signal):
	game_clock.connect(_on_clock_tick)


func send_creep():
	if _credits >= CREEP_PRICE:
		_credits -= CREEP_PRICE
		credits_changed.emit(_credits)
		
		_income += CREEP_INCOME_INCREASE
		income_changed.emit(_income)
		
		creep_spawned.emit()


func creep_passed():
	_lives -= 1
	lives_changed.emit(_lives)
	
	if _lives == 0:
		print("game over")


func build(position: Vector2) -> void:
	if _credits >= STRUCTURE_PRICE:
		_credits -= STRUCTURE_PRICE
		credits_changed.emit(_credits)
		
		var structure = Structure.new(position)
		structures.append(structure)
		structure_placed.emit(structure)


func _on_clock_tick() -> void:
	if _time_remaining_in_current_round == 1:
		_round_number += 1
		round_changed.emit(_round_number)

		_credits += _income
		credits_changed.emit(_credits)

		_time_remaining_in_current_round = SECONDS_PER_ROUND
	else:
		_time_remaining_in_current_round -= 1
	
	clock_ticked.emit(_time_remaining_in_current_round)
